import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:google_fonts/google_fonts.dart';

class ForgotPassword extends StatefulWidget {
  static const String routeName = '/forgotPassword';
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: MyColors().purple,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  'Resetare parolă',
                  style: GoogleFonts.roboto(
                    color: MyColors().purple,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value!.isEmpty) return 'Email-ul trebuie completat.';
                },
                cursorColor: MyColors().purpleSixtyPercent,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(
                    color: MyColors().purple,
                  ),
                ),
                decoration: InputDecoration(
                  hintText: 'Introduceți email-ul',
                  hintStyle: TextStyle(color: MyColors().purpleSixtyPercent),
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
              Container(
                margin: EdgeInsets.only(top: 15),
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) return;

                    MyFirebaseAuth()
                        .auth
                        .sendPasswordResetEmail(email: _emailController.text);

                    _emailController.clear();

                    showToast(
                      'Email-ul a fost trimis.',
                      context: context,
                      animation: StyledToastAnimation.slideFromTopFade,
                      position: StyledToastPosition.top,
                      reverseAnimation: StyledToastAnimation.fade,
                      animDuration: Duration(seconds: 1),
                      duration: Duration(seconds: 5),
                      curve: Curves.elasticOut,
                      reverseCurve: Curves.linear,
                    );

                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.only(top: 14, bottom: 14),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(MyColors().purple),
                  ),
                  child: Text(
                    'Resetează parola',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
