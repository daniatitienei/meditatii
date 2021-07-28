import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/widgets/inspectProf.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher.dart';

class InspectProfessor extends StatefulWidget {
  static const String routeName = '/inspect';
  const InspectProfessor({Key? key}) : super(key: key);

  @override
  _InspectProfessorState createState() => _InspectProfessorState();
}

class _InspectProfessorState extends State<InspectProfessor> {
  @override
  Widget build(BuildContext context) {
    final profile = ModalRoute.of(context)!.settings.arguments as Profile;

    return InspectProf(profile: profile);
  }
}
