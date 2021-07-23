import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:flutter/material.dart';

class AddAnnouncement extends StatelessWidget {
  const AddAnnouncement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: MyColors().purple,
      onPressed: () {},
      child: Icon(
        Icons.add,
      ),
    );
  }
}
