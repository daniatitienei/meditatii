import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:find_your_teacher/src/screens/home.dart';
import 'package:find_your_teacher/src/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyFirebase {
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Mesajul pe care-l va primi user-ul in caz de este o eroare de la firebase
  String? _errorEmail = null;
  String? _errorPassword = null;

  bool isSignedIn() {
    if (auth.currentUser == null) return false;
    return true;
  }

  validateEmail(String? email) => this._errorEmail;

  validatePassword(String? password) => this._errorPassword;

  // Adauga user-ul in baza colectia "users"
  Future<void> addUser(email, bool isStudent) {
    return users.add({
      'email': email,
      'isStudent': isStudent,
    });
  }

  // Inregistrare cu email si parola
  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await loginWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
        this._errorPassword = 'Parola este prea slabă';
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
        this._errorEmail = 'Deja există un cont cu aceasta adresă de email.';
      }
    }
    // print(this._errorText);
  }

  Future<String> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      }
    }
    return 'text';
  }

  Future<UserCredential> signInWithGoogle() async {
    GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<void> signOut(context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    Navigator.of(context)
        .pushNamedAndRemoveUntil(Login.routeName, (route) => false);
  }

  Widget googleButton(context) => Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () {
            signInWithGoogle();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Home.routeName, (route) => false);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.only(top: 14, bottom: 14),
            ),
            backgroundColor: MaterialStateProperty.all(
              Colors.white,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'lib/src/assets/svg/google.svg',
                width: 25,
                height: 25,
              ),
              Container(
                margin: EdgeInsets.only(left: 10),
                child: Text(
                  'Continua cu Google'.toUpperCase(),
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
