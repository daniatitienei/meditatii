import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/screens/Announcement.dart';
import 'package:flutter/material.dart';

class AddAnnouncement extends StatelessWidget {
  const AddAnnouncement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: MyColors().purple,
      onPressed: () => Navigator.of(context).pushNamed(Announcement.routeName),
      child: Icon(
        Icons.add,
      ),
    );
  }
}
