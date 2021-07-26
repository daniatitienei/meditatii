import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dropdown_search/dropdown_search.dart';

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
        padding: EdgeInsets.fromLTRB(20, 5, 20, 5),
        child: Column(
          children: [
            TextFormField(
              cursorColor: MyColors().purple,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(color: MyColors().purple),
              ),
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
              cursorColor: MyColors().purple,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(color: MyColors().purple),
              ),
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
              cursorColor: MyColors().purple,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(color: MyColors().purple),
              ),
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
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.2),
              child: TextFormField(
                cursorColor: MyColors().purple,
                minLines: 1,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(color: MyColors().purple),
                ),
                decoration: InputDecoration(
                  hintText: 'Descriere',
                  hintStyle: GoogleFonts.roboto(
                    color: MyColors().purpleSixtyPercent,
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors().purple),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: MyColors().purpleSixtyPercent),
                  ),
                ),
              ),
            ),
            TextFormField(
              cursorColor: MyColors().purple,
              keyboardType: TextInputType.number,
              style: GoogleFonts.roboto(
                textStyle: TextStyle(color: MyColors().purple),
              ),
              decoration: InputDecoration(
                hintText: 'Număr de telefon',
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
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: TextFormField(
                    cursorColor: MyColors().purple,
                    keyboardType: TextInputType.number,
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(color: MyColors().purple),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Preț pe sesiune',
                      hintStyle: GoogleFonts.roboto(
                        color: MyColors().purpleSixtyPercent,
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: MyColors().purple),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: MyColors().purpleSixtyPercent),
                      ),
                    ),
                  ),
                ),
                Text(
                  'LEI',
                  style: GoogleFonts.roboto(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            DropdownSearch<String>(
              mode: Mode.BOTTOM_SHEET,
              // TODO sa ii schimb culoarea din negru in mov
              items: [
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
              ],
              hint: 'Materia',
            ),
          ],
        ),
      ),
    );
  }
}
