import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/widgets/inspectProf.dart';
import 'package:flutter/material.dart';

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
