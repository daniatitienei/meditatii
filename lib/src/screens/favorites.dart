import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_teacher/src/admob/admob.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/widgets/professorItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Favorites extends StatefulWidget {
  static const String routeName = '/favorites';
  const Favorites({Key? key}) : super(key: key);

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  final Stream<DocumentSnapshot> _favoriteStream = FirebaseFirestore.instance
      .collection('users')
      .doc(MyFirebaseAuth().auth.currentUser!.email)
      .snapshots();

  InterstitialAd? _interstitialAd;
  final BannerAd myBanner = BannerAd(
    adUnitId: AdMob().bannerAdId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  @override
  void initState() {
    super.initState();
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _favoriteStream,
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(
              color: MyColors().purple,
            ),
          );

        return SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.white,
                // centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Favorite',
                    style: GoogleFonts.roboto(
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
                padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      final myData = snapshot.data!.get('favorite')[index];

                      return ProfessorItem(
                        profile: Profile(
                          uuid: myData['uuid'],
                          imgUrl: myData['imgUrl'],
                          tag: myData['tag'],
                          firstName: myData['nume'],
                          secondName: myData['prenume'],
                          email: myData['email'],
                          description: myData['descriere'],
                          city: myData['oras'],
                          phoneNumber: myData['numar'],
                          materie: myData['materie'],
                          price: myData['pret'],
                        ),
                      );
                    },
                    childCount: snapshot.data!.get('favorite').length,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
