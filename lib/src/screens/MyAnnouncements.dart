import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_teacher/src/admob/admob.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/widgets/professorItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyAnnouncements extends StatefulWidget {
  static const String routeName = '/myAnnouncements';
  const MyAnnouncements({Key? key}) : super(key: key);

  @override
  _MyAnnouncementsState createState() => _MyAnnouncementsState();
}

class _MyAnnouncementsState extends State<MyAnnouncements> {
  final Stream<QuerySnapshot> _myAnunturiStream = FirebaseFirestore.instance
      .collection('users/${MyFirebaseAuth().auth.currentUser!.email}/anunturi')
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
      ),
    );
  }

  Future<void> _deleteDialog(Profile profile) async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Doriți să ștergeți anunțul?',
            style: GoogleFonts.montserrat(
              color: MyColors().purple,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.red,
                ),
              ),
              child: Text(
                'Nu',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  MyColors().purple,
                ),
              ),
              child: Text(
                'Da',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                MyFirestore().removeAnnouncement(profile);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder(
        stream: _myAnunturiStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                      'Anunțurile mele',
                      style: GoogleFonts.montserrat(
                        color: MyColors().purple,
                      ),
                    ),
                  ),
                  leading: IconButton(
                    onPressed: () {
                      this._interstitialAd?.show();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: MyColors().purple,
                    ),
                  ),
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
                        final Profile profile = Profile(
                          uuid: snapshot.data!.docs[index]['uuid'],
                          imgUrl: snapshot.data!.docs[index]['imgUrl'],
                          tag: snapshot.data!.docs[index]['tag'],
                          firstName: snapshot.data!.docs[index]['nume'],
                          secondName: snapshot.data!.docs[index]['prenume'],
                          email: snapshot.data!.docs[index]['email'],
                          description: snapshot.data!.docs[index]['descriere'],
                          city: snapshot.data!.docs[index]['materie'],
                          phoneNumber: snapshot.data!.docs[index]['numar'],
                          materie: snapshot.data!.docs[index]['materie'],
                          price: snapshot.data!.docs[index]['pret'],
                        );

                        return ProfessorItem(
                          onLongPress: () => _deleteDialog(profile),
                          profile: profile,
                        );
                      },
                      childCount: snapshot.data!.size,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
