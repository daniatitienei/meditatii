import 'dart:io';

import 'package:find_your_teacher/src/admob/admob.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

class InspectProf extends StatefulWidget {
  final Profile profile;
  const InspectProf({required this.profile, Key? key}) : super(key: key);

  @override
  _InspectProfState createState() => _InspectProfState();
}

class _InspectProfState extends State<InspectProf> {
  bool isFav = false;

  final BannerAd myBanner = BannerAd(
    adUnitId: AdMob().bannerAdId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  Widget _buildCard(BuildContext context, Profile profile) => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 15,
          bottom: 25,
        ),
        decoration: BoxDecoration(
          color: MyColors().purple,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Row(
          children: [
            Hero(
              tag: profile.tag,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(profile.imgUrl),
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${profile.firstName} ${profile.secondName}',
                        overflow: TextOverflow.fade,
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Profesor de ${profile.materie.toLowerCase()}',
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  void _openPhoneNumber(Profile profile) async =>
      await canLaunch('tel://${profile.phoneNumber}')
          ? await launch('tel://${profile.phoneNumber}')
          : throw 'Could not launch ${profile.phoneNumber}';

  void _openEmail(Profile profile) async => await launch(
        Mailto(
          to: [profile.email],
        ).toString(),
      );

  Widget _buildAbout(BuildContext context, Profile profile) => Flexible(
        child: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.04),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
          child: ListView(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          'Despre ${profile.firstName} ${profile.secondName}',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: MediaQuery.of(context).size.height * 0.2,
                        ),
                        child: Container(
                          padding: EdgeInsets.only(top: 10),
                          child: Scrollbar(
                            isAlwaysShown: true,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Text(
                                profile.description.trim() == ''
                                    ? 'Nicio descriere'
                                    : profile.description,
                                style: GoogleFonts.montserrat(
                                  textStyle: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pre?? pe sesiune',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          child: Text(
                            '${profile.price} LEI',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Contact',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () => _openPhoneNumber(profile),
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.phone,
                            color: MyColors().purple,
                          ),
                          title: Text(
                            profile.phoneNumber,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: MyColors().purple,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () => _openEmail(profile),
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.email,
                            color: MyColors().purple,
                          ),
                          title: Text(
                            profile.email,
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                color: MyColors().purple,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  final firestore = MyFirestore();

  @override
  void initState() {
    super.initState();
    myBanner.load();
    Future.delayed(
      Duration.zero,
      () async {
        await firestore.isFavorite(widget.profile);
        setState(() {
          isFav = firestore.getIsFav;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColors().purple,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close_rounded,
            color: Colors.white,
            size: 32,
          ),
          color: MyColors().purple,
        ),
        actions: [
          IconButton(
            onPressed: () async {
              isFav
                  ? await firestore.removeFavorite(widget.profile)
                  : await firestore.newFavorite(widget.profile);

              await firestore.isFavorite(widget.profile);

              setState(() {
                isFav = firestore.getIsFav;
              });
            },
            icon: Icon(
              Platform.isAndroid
                  ? isFav
                      ? Icons.favorite
                      : Icons.favorite_outline
                  : isFav
                      ? CupertinoIcons.heart_fill
                      : CupertinoIcons.heart,
              size: 28,
            ),
          ),
        ],
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCard(context, widget.profile),
                  _buildAbout(context, widget.profile),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10),
              height: 50,
              child: AdWidget(
                ad: myBanner,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
