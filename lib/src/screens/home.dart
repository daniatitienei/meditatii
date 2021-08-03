import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_teacher/src/admob/admob.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/screens/favorites.dart';
import 'package:find_your_teacher/src/widgets/addAnnouncement.dart';
import 'package:find_your_teacher/src/widgets/materie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static const String routeName = '/';
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  InterstitialAd? _interstitialAd;
  final BannerAd myBanner = BannerAd(
    adUnitId: AdMob().homeAdId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  final Stream<QuerySnapshot> _materiiStream =
      FirebaseFirestore.instance.collection('materii').snapshots();

  PageController _pageController = PageController();

  Widget _BottomBar() => BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: MyColors().purple,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => _pageController.jumpToPage(0),
              icon: Icon(
                Icons.home,
              ),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () => _pageController.jumpToPage(1),
              icon: Icon(
                Icons.favorite,
              ),
              color: Colors.white,
            ),
          ],
        ),
      );

  @override
  void initState() {
    super.initState();
    myBanner.load();
    InterstitialAd.load(
        adUnitId: AdMob().betweenProfessors,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            print('done');
            this._interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    MyFirestore().loadAnunturiLength();
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Categorii',
          style: GoogleFonts.roboto(color: MyColors().purple),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              MyFirebaseAuth().signOut(context);
              this._interstitialAd!.show();
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
      ),
      floatingActionButton: AddAnnouncement(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _materiiStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
              margin: EdgeInsets.only(top: 70),
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTileShimmer(
                    hasCustomColors: true,
                    height: 20,
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
                itemCount: 10,
              ),
            );

          return PageView(
            controller: _pageController,
            children: [
              SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) => Materie(
                          circleColor: MyColors().circleColors[index],
                          backgroundColor: MyColors().backgroundColors[index],
                          title: snapshot.data!.docs[index].id,
                          announces: snapshot.data?.docs[index]['anunturi'],
                          imageUrl: snapshot.data!.docs[index]['imageUrl'],
                        ),
                        itemCount: snapshot.data?.docs.length,
                      ),
                    ),
                    Container(
                      height: 50,
                      child: AdWidget(
                        ad: myBanner,
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
