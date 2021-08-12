import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_teacher/src/admob/admob.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/models/categoryTitle.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/models/typeOfFilters.dart';
import 'package:find_your_teacher/src/screens/filters.dart';
import 'package:find_your_teacher/src/widgets/addAnnouncement.dart';
import 'package:find_your_teacher/src/widgets/professorItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

class SelectedCategory extends StatefulWidget {
  static const String routeName = '/selectedCategory';
  const SelectedCategory({Key? key}) : super(key: key);

  @override
  _SelectedCategoryState createState() => _SelectedCategoryState();
}

class _SelectedCategoryState extends State<SelectedCategory> {
  MyFirebaseAuth auth = MyFirebaseAuth();

  bool isStudent = true;

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
    Future.delayed(
      Duration.zero,
      () async {
        await auth.setIsStudent(auth.auth.currentUser!.email);

        setState(() {
          this.isStudent = auth.isStudent();
        });
      },
    );
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
    final args = ModalRoute.of(context)!.settings.arguments as CategoryTitle;

    final Stream<QuerySnapshot> _anunturiStream = FirebaseFirestore.instance
        .collection('materii/${args.title}/anunturi')
        .where('oras',
            isEqualTo: Provider.of<TypeOfFilters>(context).locatie == 'Oriunde'
                ? null
                : Provider.of<TypeOfFilters>(context).locatie)
        .orderBy(
          Provider.of<TypeOfFilters>(context).getVariableName(),
          descending: Provider.of<TypeOfFilters>(context).getBoolForValue(),
        )
        // .orderBy('pret')
        .snapshots();

    return Scaffold(
      extendBody: true,
      floatingActionButton: this.isStudent ? null : AddAnouncement(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: StreamBuilder<QuerySnapshot>(
        stream: _anunturiStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
              margin: EdgeInsets.only(top: 80),
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => Container(
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
                itemCount: 10,
              ),
            );

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  iconTheme: IconThemeData(color: MyColors().purple),
                  floating: true,
                  pinned: false,
                  snap: true,
                  expandedHeight: 70,
                  backgroundColor: Colors.white,
                  actions: [
                    IconButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(Filters.routeName),
                      icon: Icon(
                        Icons.filter_list,
                      ),
                      color: MyColors().purple,
                    ),
                  ],
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                    ),
                    color: MyColors().purple,
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      args.title,
                      style: GoogleFonts.montserrat(
                        color: MyColors().purple,
                      ),
                    ),
                  ),
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
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return ProfessorItem(
                          onLongPress: () {},
                          profile: Profile(
                            uuid: snapshot.data!.docs[index]['uuid'],
                            imgUrl: snapshot.data!.docs[index]['imgUrl'],
                            tag: snapshot.data!.docs[index]['tag'],
                            firstName: snapshot.data!.docs[index]['nume'],
                            secondName: snapshot.data!.docs[index]['prenume'],
                            email: snapshot.data!.docs[index]['email'],
                            description: snapshot.data!.docs[index]
                                ['descriere'],
                            city: snapshot.data!.docs[index]['oras'],
                            phoneNumber: snapshot.data!.docs[index]['numar'],
                            materie: snapshot.data!.docs[index]['materie'],
                            price: snapshot.data!.docs[index]['pret'],
                          ),
                        );
                      },
                      childCount: snapshot.data?.docs.length,
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
