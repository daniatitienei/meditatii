import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/screens/home.dart';
import 'package:find_your_teacher/src/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Login extends StatefulWidget {
  static const String routeName = '/login';

  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Widget _buildLoginButton() => Container(
        margin: EdgeInsets.only(top: 10),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          onPressed: () async {
            await MyFirebase().loginWithEmailAndPassword(
              _emailController.text,
              _passwordController.text,
            );

            if (!_formKey.currentState!.validate()) return;

            if (MyFirebase().auth.currentUser != null)
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
          ),
          child: Text(
            'Intra in cont'.toUpperCase(),
            style: GoogleFonts.roboto(
              textStyle: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.fromLTRB(
                20, MediaQuery.of(context).size.height * .25, 20, 25),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: Text(
                    'Bine ai revenit!',
                    style: GoogleFonts.robotoSlab(
                      textStyle: TextStyle(fontSize: 32),
                    ),
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  cursorColor: MyColors().purpleSixtyPercent,
                  validator: (email) => MyFirebase().validateLoginEmail(),
                  style: GoogleFonts.roboto(
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
                      controller: _passwordController,
                      validator: (password) =>
                          MyFirebase().validateLoginPassword(),
                      cursorColor: MyColors().purpleSixtyPercent,
                      obscureText: true,
                      style: GoogleFonts.roboto(
                        textStyle: TextStyle(
                          color: MyColors().purple,
                        ),
                      ),
                      decoration: InputDecoration(
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
                        // Navigator.of(context).pushNamed(Register.routeName);
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 8),
                        child: Text(
                          'Ai uitat parola?',
                          style: GoogleFonts.roboto(
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
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(Register.routeName);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 8),
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.roboto(
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
                            text: 'Creaza-ti unul',
                            style: GoogleFonts.roboto(
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
                Container(
                  margin: EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    "SAU",
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        // fontSize: 16,
                      ),
                    ),
                  ),
                ),
                MyFirebase().googleButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
