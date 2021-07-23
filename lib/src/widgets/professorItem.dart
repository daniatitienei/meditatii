import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/screens/inspectProfessor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfessorItem extends StatelessWidget {
  const ProfessorItem({Key? key}) : super(key: key);

  final imgUrl =
      'https://scontent.fclj2-1.fna.fbcdn.net/v/t31.18172-8/324247_113908758721582_1720873077_o.jpg?_nc_cat=107&ccb=1-3&_nc_sid=09cbfe&_nc_ohc=G-wTNlWUCbYAX8FX9os&_nc_ht=scontent.fclj2-1.fna&oh=2bb3d28cf3b48213e19cb16a36c26592&oe=611FD850';

  final tag = 'nicola';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: () => Navigator.of(context).pushNamed(
          InspectProfessor.routeName,
          arguments: Profile(url: imgUrl, tag: tag, name: 'Nicola Alin'),
        ),
        title: Text(
          'Nicola Alin',
          style: GoogleFonts.roboto(color: MyColors().purple),
        ),
        // Animatie hero
        leading: Hero(
          tag: tag,
          child: CircleAvatar(
            backgroundImage: NetworkImage(imgUrl),
          ),
        ),
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
