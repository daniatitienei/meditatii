import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/screens/announcement.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AddAnouncement extends StatelessWidget {
  const AddAnouncement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: MyColors().purple,
      onPressed: () {
        Navigator.of(context).pushNamed(Announcement.routeName);
      },
      child: Icon(
        Icons.add,
      ),
    );
  }
}
