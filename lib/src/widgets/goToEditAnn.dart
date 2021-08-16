import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/screens/editAnnouncement.dart';
import 'package:flutter/material.dart';

class GoToEditAnnouncement extends StatelessWidget {
  static const String routeName = '/editAnnouncement';
  const GoToEditAnnouncement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profile = ModalRoute.of(context)!.settings.arguments as Profile;

    return EditAnnouncement(profile: profile);
  }
}
