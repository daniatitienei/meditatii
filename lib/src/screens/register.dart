import 'dart:io';

import 'package:find_your_teacher/src/admob/admob.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/screens/createProfile.dart';
import 'package:find_your_teacher/src/screens/home.dart';
import 'package:find_your_teacher/src/screens/login.dart';
import 'package:find_your_teacher/src/screens/selectType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:group_button/group_button.dart';

class Register extends StatefulWidget {
  static const String routeName = '/register';
  const Register({Key? key}) : super(key: key);

  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final myFirebase = MyFirebaseAuth();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  InterstitialAd? _interstitialAd;

  bool obscureText = true;

  Widget _buildRegisterButton(bool isStudent) => Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async {
            await myFirebase.registerWithEmailAndPassword(
              _emailController.text,
              _passwordController.text,
            );
            if (!_formKey.currentState!.validate()) return;

            MyFirebaseAuth().addUser(_emailController.text, isStudent);

            _emailController.clear();
            _passwordController.clear();

            this._interstitialAd!.show();

            showToast(
              'Contul a fost creat cu succes.',
              context: context,
              animation: StyledToastAnimation.slideFromTopFade,
              position: StyledToastPosition.top,
              reverseAnimation: StyledToastAnimation.fade,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 5),
              curve: Curves.elasticOut,
              reverseCurve: Curves.linear,
            );

            Navigator.of(context).pushNamedAndRemoveUntil(
                CreateProfile.routeName, (route) => false);
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.only(top: 14, bottom: 14),
            ),
            backgroundColor: MaterialStateProperty.all(
              MyColors().purple,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10),
              ),
            ),
          ),
          child: Text(
            'Crează cont'.toUpperCase(),
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
    InterstitialAd.load(
      adUnitId: AdMob().interstitialAdId,
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          this._interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Student;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Bine ai venit!',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  cursorColor: MyColors().purpleSixtyPercent,
                  controller: _emailController,
                  validator: (email) => myFirebase.validateRegisterEmail(email),
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      color: MyColors().purple,
                    ),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: MyColors().purpleSixtyPercent),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: MyColors().purple,
                      ),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: MyColors().purple,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      obscureText: this.obscureText,
                      controller: _passwordController,
                      validator: (password) =>
                          myFirebase.validateRegisterPassword(password),
                      cursorColor: MyColors().purpleSixtyPercent,
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: MyColors().purple,
                        ),
                      ),
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              this.obscureText = !this.obscureText;
                            });
                          },
                          icon: Icon(
                            Platform.isIOS
                                ? this.obscureText
                                    ? CupertinoIcons.eye_slash
                                    : CupertinoIcons.eye
                                : this.obscureText
                                    ? Icons.remove_red_eye_outlined
                                    : Icons.remove_red_eye_rounded,
                            color: MyColors().purple,
                          ),
                        ),
                        hintText: 'Parola',
                        hintStyle:
                            TextStyle(color: MyColors().purpleSixtyPercent),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColors().purple,
                          ),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: MyColors().purpleSixtyPercent,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(Login.routeName);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          'Am cont',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                _buildRegisterButton(args.isStudent),
                Divider(
                  height: 5,
                ),
                Text(
                  "SAU",
                  style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      // fontSize: 16,
                    ),
                  ),
                ),
                Divider(
                  height: 5,
                ),
                myFirebase.googleButtonRegister(
                  isStudent: args.isStudent,
                  context: context,
                  interstitialAd: this._interstitialAd,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
