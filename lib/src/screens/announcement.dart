import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Announcement extends StatefulWidget {
  static const String routeName = '/addAnouncement';

  const Announcement({Key? key}) : super(key: key);

  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Adaugă un anunț',
          style: GoogleFonts.roboto(
            color: MyColors().purple,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close,
            size: 32,
            color: MyColors().purple,
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Nume',
                hintStyle: GoogleFonts.roboto(
                  color: MyColors().purpleSixtyPercent,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyColors().purple),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyColors().purpleSixtyPercent),
                ),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Prenume',
                hintStyle: GoogleFonts.roboto(
                  color: MyColors().purpleSixtyPercent,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyColors().purple),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyColors().purpleSixtyPercent),
                ),
              ),
            ),
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Strada',
                hintStyle: GoogleFonts.roboto(
                  color: MyColors().purpleSixtyPercent,
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyColors().purple),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: MyColors().purpleSixtyPercent),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
