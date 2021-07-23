import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfessorItem extends StatelessWidget {
  const ProfessorItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO
    // Sa nu mai fie textul overflow
    return Card(
      child: ListTile(
        title: Text(
          'Nicola Alin',
          style: GoogleFonts.roboto(color: MyColors().purple),
        ),
        // leading: Image.network(
        //   "https://firebasestorage.googleapis.com/v0/b/gaseste-ti-profesorul.appspot.com/o/atom.svg?alt=media&token=f517545f-001a-4ba0-a0e4-384c5f152fdb",
        //   width: 40,
        //   height: 40,
        // ),
        trailing: Text(
          '50 LEI',
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Row(
          children: [
            Text(
              'Strada Caransebului Nr.5',
              style: GoogleFonts.roboto(color: MyColors().purpleSixtyPercent),
            ),
          ],
        ),
      ),
    );
  }
}
