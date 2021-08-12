import 'dart:io';

import 'package:find_your_teacher/src/admob/admob.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/screens/forgotPassword.dart';
import 'package:find_your_teacher/src/screens/home.dart';
import 'package:find_your_teacher/src/screens/register.dart';
import 'package:find_your_teacher/src/screens/selectType.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Login extends StatefulWidget {
  static const String routeName = '/login';

  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  MyFirebaseAuth auth = MyFirebaseAuth();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  InterstitialAd? _interstitialAd;

  bool obscureText = true;

  Widget _buildLoginButton() => Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async {
            await auth.loginWithEmailAndPassword(
              _emailController.text,
              _passwordController.text,
            );

            if (!_formKey.currentState!.validate()) return;

            this._interstitialAd!.show();

            showToast(
              'Conectarea a fost realizată cu succes.',
              context: context,
              animation: StyledToastAnimation.slideFromTopFade,
              position: StyledToastPosition.top,
              reverseAnimation: StyledToastAnimation.fade,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 5),
              curve: Curves.elasticOut,
              reverseCurve: Curves.linear,
            );

            if (auth.auth.currentUser != null)
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(Home.routeName, (route) => false);
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
            'Intra in cont'.toUpperCase(),
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.w700,
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
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                    'Bine ai revenit!',
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  cursorColor: MyColors().purpleSixtyPercent,
                  validator: (email) => auth.validateLoginEmail(email),
                  style: GoogleFonts.montserrat(
                    color: MyColors().purple,
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
                      controller: _passwordController,
                      validator: (password) =>
                          auth.validateLoginPassword(password),
                      cursorColor: MyColors().purpleSixtyPercent,
                      obscureText: this.obscureText,
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
                      onTap: () => Navigator.of(context)
                          .pushNamed(ForgotPassword.routeName),
                      child: Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          'Ai uitat parola?',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                _buildLoginButton(),
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 5),
                  child: Text(
                    "SAU",
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        // fontSize: 16,
                      ),
                    ),
                  ),
                ),
                auth.googleButtonLogin(
                    context: context, interstitialAd: this._interstitialAd),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(SelectType.routeName);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: MyColors().purple,
                          ),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Nu ai cont? ',
                          ),
                          TextSpan(
                            text: 'Crează-ți unul',
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: MyColors().purple,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
