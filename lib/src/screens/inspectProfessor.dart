import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InspectProfessor extends StatelessWidget {
  static const String routeName = '/inspect';

  const InspectProfessor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Profile;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          args.name,
          style: GoogleFonts.roboto(
            textStyle: TextStyle(
              color: MyColors().purple,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
          color: MyColors().purple,
        ),
        centerTitle: true,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: args.tag,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.35,
                height: MediaQuery.of(context).size.height * 0.35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.contain,
                    image: NetworkImage(args.url),
                  ),
                ),
              ),
            ),
            Text(
              args.name,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  color: MyColors().purple,
                  fontSize: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
