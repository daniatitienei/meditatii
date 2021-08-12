import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/screens/home.dart';
import 'package:find_your_teacher/src/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class MyFirebaseAuth {
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Mesajul pe care-l va primi user-ul in caz de este o eroare de la firebase

  String? _registerErrorEmail = null;
  String? _registerErrorPassword = null;

  String? _loginErrorEmail = null;
  String? _loginErrorPassword = null;

  bool _isStudent = true;

  bool isSignedIn() => auth.currentUser == null ? false : true;

  String? validateRegisterEmail(String? email) =>
      email!.isEmpty && this._registerErrorEmail == null
          ? 'Adresă invalidă.'
          : this._registerErrorEmail;

  String? validateRegisterPassword(String? password) =>
      password!.isEmpty && this._registerErrorPassword == null
          ? 'Parolă invalidă.'
          : this._registerErrorPassword;

  String? validateLoginEmail(String? email) =>
      email!.isEmpty && this._loginErrorEmail == null
          ? 'Adresă invalidă.'
          : this._loginErrorEmail;

  String? validateLoginPassword(String? password) =>
      password!.isEmpty && this._loginErrorPassword == null
          ? 'Parolă invalidă.'
          : this._loginErrorPassword;

  bool isStudent() => this._isStudent;

  // Adauga user-ul in baza colectia "users"

  Future<void> addUser(email, bool isStudent) => users.doc(email).set({
        'isStudent': isStudent,
      });

  setIsStudent(email) async {
    await users.doc(email).get().then((response) {
      Map<String, dynamic> data = response.data() as Map<String, dynamic>;

      this._isStudent = data['isStudent'];
    });
  }

  // Inregistrare cu email si parola

  Future<void> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await loginWithEmailAndPassword(email, password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password')
        this._registerErrorPassword = 'Parola este prea slabă';
      else if (e.code == 'email-already-in-use')
        this._registerErrorEmail =
            'Deja există un cont cu aceasta adresă de email.';
    }
  }

  // Autentificare cu email si parola

  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found')
        this._loginErrorEmail =
            'Nu există niciun utilizator cu aceasta adresa.';
      else if (e.code == 'wrong-password')
        this._loginErrorPassword = 'Parolă incorectă.';
    }
  }

  // Autentificare cu Google

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

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

  Widget googleButtonRegister({
    required isStudent,
    required context,
    required InterstitialAd? interstitialAd,
  }) =>
      Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async {
            await signInWithGoogle();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Home.routeName, (route) => false);

            MyFirebaseAuth().addUser(
              MyFirebaseAuth().auth.currentUser?.email,
              isStudent,
            );

            interstitialAd?.show();

            showToast(
              'V-ați conectat cu succes.',
              context: context,
              animation: StyledToastAnimation.slideFromTopFade,
              position: StyledToastPosition.top,
              reverseAnimation: StyledToastAnimation.fade,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 2),
              curve: Curves.elasticOut,
              reverseCurve: Curves.linear,
            );
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
  Widget googleButtonLogin({
    required context,
    required InterstitialAd? interstitialAd,
  }) =>
      Container(
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async {
            await signInWithGoogle();
            Navigator.of(context)
                .pushNamedAndRemoveUntil(Home.routeName, (route) => false);

            interstitialAd?.show();

            showToast(
              'V-ați conectat cu succes.',
              context: context,
              animation: StyledToastAnimation.slideFromTopFade,
              position: StyledToastPosition.top,
              reverseAnimation: StyledToastAnimation.fade,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 2),
              curve: Curves.elasticOut,
              reverseCurve: Curves.linear,
            );
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

class MyFirebaseStorage {
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  getImageUrl(String fileName) async {
    var ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child("poze_profesori/${fileName}");
    String url = (await ref.getDownloadURL()).toString();
    return url;
  }

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('poze_profesori/${fileName}')
          .putFile(file);
    } catch (e) {
      print(e);
    }
  }
}

class MyFirestore {
  void loadAnunturiLength() {
    final List<String> materii = [
      'Matematică',
      'Română',
      'Informatică',
      'Biologie',
      'Fizică',
      'Engleză',
      'Chimie',
      'Desen',
      'Franceză',
      'Geografie',
      'Germană',
      'Istorie',
      'Latină',
      'Muzică',
      'Psihologie',
      'Sport',
    ];

    for (int index = 0; index < materii.length; index++)
      FirebaseFirestore.instance
          .collection('materii/${materii[index]}/anunturi')
          .get()
          .then((response) {
        FirebaseFirestore.instance
            .collection('materii')
            .doc(materii[index])
            .update({
          'anunturi': response.docs.length,
        });
      });
  }

  removeAnnouncement(Profile profile) {
    final favorite = FirebaseFirestore.instance.collection('users').get();

    favorite.then((QuerySnapshot doc) {
      doc.docs.forEach((user) {
        FirebaseFirestore.instance
            .doc('users/${user.id}/favorite/${profile.uuid}')
            .delete();
      });
    });

    final homeAnnouncement = FirebaseFirestore.instance
        .doc('materii/${profile.materie}/anunturi/${profile.uuid}')
        .delete();

    int? count;

    FirebaseFirestore.instance
        .doc('materii/${profile.materie}')
        .get()
        .then((data) => count = data['anunturi']);

    final updateCount =
        FirebaseFirestore.instance.doc('materii/${profile.materie}').update({
      'anunturi': count! - 1,
    });

    final myAnnoucement = FirebaseFirestore.instance
        .doc(
            'users/${MyFirebaseAuth().auth.currentUser!.email}/anunturi/${profile.uuid}')
        .delete();

    firebase_storage.FirebaseStorage.instance
        .refFromURL(profile.imgUrl)
        .delete();

    MyFirestore().loadAnunturiLength();
  }

  Future<void> addAnnouncement(Profile profile) {
    CollectionReference materii = FirebaseFirestore.instance
        .collection('materii/${profile.materie}/anunturi');

    CollectionReference user = FirebaseFirestore.instance.collection(
        'users/${MyFirebaseAuth().auth.currentUser!.email}/anunturi');

    return materii.doc(profile.uuid).set(
      {
        'uuid': profile.uuid,
        'nume': profile.firstName.trim(),
        'prenume': profile.secondName.trim(),
        'descriere': profile.description,
        'materie': profile.materie,
        'oras': profile.city,
        'numar': profile.phoneNumber,
        'pret': profile.price,
        'imgUrl': profile.imgUrl,
        'tag': profile.tag,
        'email': profile.email,
        'date': DateTime.now(),
      },
    ).then(
      (value) {
        MyFirestore().loadAnunturiLength();
        user.doc(profile.uuid).set({
          'uuid': profile.uuid,
          'nume': profile.firstName.trim(),
          'prenume': profile.secondName.trim(),
          'descriere': profile.description,
          'materie': profile.materie,
          'oras': profile.city,
          'numar': profile.phoneNumber,
          'pret': profile.price,
          'imgUrl': profile.imgUrl,
          'tag': profile.tag,
          'email': profile.email,
          'date': DateTime.now(),
        });
      },
    ).catchError((err) => print('nu a fost updatat'));
  }

  bool _isFav = false;

  set isFav(bool newVal) => _isFav = newVal;
  bool get getIsFav => _isFav;

  Future<void> isFavorite(Profile profile) {
    final announce = FirebaseFirestore.instance
        .doc(
            'users/${MyFirebaseAuth().auth.currentUser!.email}/favorite/${profile.uuid}')
        .get()
        .then((doc) {
      isFav = doc.exists;
    });

    return announce;
  }

  Future<void> newFavorite(Profile profile) {
    CollectionReference user = FirebaseFirestore.instance.collection(
        'users/${MyFirebaseAuth().auth.currentUser!.email}/favorite');
    return user
        .doc(profile.uuid)
        .set({
          'uuid': profile.uuid,
          'nume': profile.firstName,
          'prenume': profile.secondName,
          'descriere': profile.description,
          'materie': profile.materie,
          'oras': profile.city,
          'numar': profile.phoneNumber,
          'pret': profile.price,
          'imgUrl': profile.imgUrl,
          'tag': profile.tag,
          'email': profile.email,
        })
        .then((value) => isFav = true)
        .catchError((err) => print('nu a fost updatat'));
  }

  Future<void> removeFavorite(Profile profile) {
    final announce = FirebaseFirestore.instance
        .doc(
            'users/${MyFirebaseAuth().auth.currentUser!.email}/favorite/${profile.uuid}')
        .delete();

    return announce;
  }
}
