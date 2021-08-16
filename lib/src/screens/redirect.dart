import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/screens/createProfile.dart';
import 'package:find_your_teacher/src/screens/home.dart';
import 'package:find_your_teacher/src/screens/selectType.dart';
import 'package:flutter/material.dart';

class Redirect extends StatefulWidget {
  const Redirect({Key? key}) : super(key: key);

  @override
  _RedirectState createState() => _RedirectState();
}

class _RedirectState extends State<Redirect> {
  bool hasProfile = false;

  bool isStudent = true;

  @override
  void initState() {
    super.initState();
    MyFirestore().hasProfessorProfile().then((bool response) {
      setState(
        () => hasProfile = response,
      );
    });
    MyFirestore().isStudent().then((bool response) {
      setState(
        () => isStudent = response,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!MyFirebaseAuth().isSignedIn())
      return SelectType();
    else if (MyFirebaseAuth().isSignedIn() &&
        !this.isStudent &&
        !this.hasProfile)
      return CreateProfile();
    else if (MyFirebaseAuth().isSignedIn() &&
        (this.isStudent || this.hasProfile)) return Home();

    return Center(
      child: CircularProgressIndicator(
        color: MyColors().purple,
      ),
    );
  }
}
