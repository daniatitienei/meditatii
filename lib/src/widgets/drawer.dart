import 'dart:io';

import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/screens/MyAnnouncements.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyDrawer extends StatelessWidget {
  bool isStudent;
  InterstitialAd? interstitialAd;
  Function onFavoriteTap;

  MyDrawer({
    Key? key,
    required this.isStudent,
    required this.interstitialAd,
    required this.onFavoriteTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              color: MyColors().purple,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  this.isStudent ? 'Student' : 'Profesor',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${MyFirebaseAuth().auth.currentUser!.email}',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (!isStudent)
            ListTile(
              onTap: () {
                interstitialAd?.show();
                Navigator.of(context).pushNamed(MyAnnouncements.routeName);
              },
              title: Text(
                'Anunțurile mele',
                style: GoogleFonts.montserrat(
                  color: MyColors().purple,
                  fontSize: 14,
                ),
              ),
              leading: Icon(
                Platform.isAndroid
                    ? Icons.announcement_rounded
                    : CupertinoIcons.square_stack_fill,
                color: MyColors().purple,
              ),
            ),
          ListTile(
            onTap: () => onFavoriteTap(),
            title: Text(
              'Favorite',
              style: GoogleFonts.montserrat(
                color: MyColors().purple,
              ),
            ),
            leading: Icon(
              Platform.isAndroid ? Icons.favorite : CupertinoIcons.heart_fill,
              color: MyColors().purple,
            ),
          ),
          ListTile(
            onTap: () => MyFirebaseAuth().signOut(context),
            title: Text(
              'Deconectare',
              style: GoogleFonts.montserrat(
                color: MyColors().purple,
              ),
            ),
            leading: Icon(
              Platform.isAndroid
                  ? Icons.logout_rounded
                  : CupertinoIcons.xmark_circle_fill,
              color: MyColors().purple,
            ),
          ),
        ],
      ),
    );
  }
}
