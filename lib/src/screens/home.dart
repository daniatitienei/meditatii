import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_teacher/src/admob/admob.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/screens/favorites.dart';
import 'package:find_your_teacher/src/widgets/addAnnouncement.dart';
import 'package:find_your_teacher/src/widgets/drawer.dart';
import 'package:find_your_teacher/src/widgets/materie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Home extends StatefulWidget {
  static const String routeName = '/';
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MyFirebaseAuth auth = MyFirebaseAuth();

  bool isStudent = true;

  InterstitialAd? _interstitialAd;
  final BannerAd myBanner = BannerAd(
    adUnitId: AdMob().bannerAdId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  final Stream<QuerySnapshot> _materiiStream =
      FirebaseFirestore.instance.collection('materii').snapshots();

  PageController _pageController = PageController();

  int navbarIndex = 0;

  Widget _BottomBar() => BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: MyColors().purple,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: () {
                  _pageController.jumpToPage(0);
                  setState(() => this.navbarIndex = 0);
                },
                icon: Icon(
                  Platform.isAndroid ? Icons.home : CupertinoIcons.home,
                  size: this.navbarIndex == 0 ? 28 : 26,
                  color: this.navbarIndex == 0
                      ? Colors.white
                      : Colors.grey.shade400,
                ),
                color: Colors.white,
              ),
              IconButton(
                onPressed: () {
                  _pageController.jumpToPage(1);
                  setState(() => this.navbarIndex = 1);
                },
                icon: Icon(
                  Platform.isAndroid
                      ? Icons.favorite
                      : CupertinoIcons.heart_fill,
                  size: this.navbarIndex == 1 ? 28 : 26,
                  color: this.navbarIndex == 1
                      ? Colors.white
                      : Colors.grey.shade400,
                ),
                color: Colors.white,
              ),
            ],
          ),
        ),
      );

  @override
  void initState() {
    super.initState();

    MyFirestore().isStudent().then((bool response) {
      setState(
        () => this.isStudent = response,
      );
    });

    myBanner.load();
    InterstitialAd.load(
      adUnitId: AdMob().interstitialAdId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          this._interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    MyFirestore().loadAnunturiLength();
    return Scaffold(
      drawer: MyDrawer(
          isStudent: this.isStudent,
          interstitialAd: this._interstitialAd,
          onFavoriteTap: () {
            _pageController.jumpToPage(1);
            setState(() {
              this.navbarIndex = 1;
            });
            Navigator.of(context).pop();
          }),
      backgroundColor: Colors.white,
      extendBody: true,
      floatingActionButton: this.isStudent ? null : AddAnouncement(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _materiiStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: 120),
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    for (int i = 0; i < 4; i++)
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: ListTileShimmer(
                          hasCustomColors: true,
                          height: 15,
                          colors: [
                            // Dark color
                            Colors.grey.shade400,
                            // light color
                            Colors.grey.shade200,
                            // Medium color
                            Colors.grey.shade300,
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            );

          return PageView(
            onPageChanged: (int newIndex) {
              setState(() => this.navbarIndex = newIndex);
            },
            controller: _pageController,
            children: [
              SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      iconTheme: IconThemeData(color: MyColors().purple),
                      backgroundColor: Colors.white,
                      // centerTitle: true,
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          'Materii',
                          style: GoogleFonts.montserrat(
                            color: MyColors().purple,
                          ),
                        ),
                      ),
                      actions: [
                        IconButton(
                          onPressed: () {
                            MyFirebaseAuth().signOut(context);
                            this._interstitialAd?.show();
                            showToast(
                              'V-ați deconectat cu succes.',
                              context: context,
                              animation: StyledToastAnimation.slideFromTopFade,
                              position: StyledToastPosition.top,
                              reverseAnimation: StyledToastAnimation.fade,
                              animDuration: Duration(seconds: 1),
                              duration: Duration(seconds: 2),
                              curve: Curves.elasticOut,
                              reverseCurve: Curves.linear,
                            );
                          },
                          icon: Icon(
                            Icons.logout,
                            color: MyColors().purple,
                          ),
                        ),
                      ],
                      expandedHeight: 70,
                      floating: true,
                      snap: true,
                      pinned: false,
                    ),
                    SliverToBoxAdapter(
                      child: Container(
                        height: 50,
                        child: AdWidget(
                          ad: myBanner,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: EdgeInsets.only(top: 10),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) => Materie(
                            circleColor: Color(
                                snapshot.data?.docs[index]['circleColor']),
                            backgroundColor: Color(
                                snapshot.data?.docs[index]['backgroundColor']),
                            title: snapshot.data!.docs[index].id,
                            announces: snapshot.data?.docs[index]['anunturi'],
                            imageUrl: snapshot.data!.docs[index]['imageUrl'],
                          ),
                          childCount: snapshot.data!.docs.length,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Favorites(),
            ],
          );
        },
      ),
    );
  }
}
