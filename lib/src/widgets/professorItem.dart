import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/screens/inspectProfessor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfessorItem extends StatelessWidget {
  final Profile profile;
  final Function onLongPress;

  const ProfessorItem(
      {Key? key, required this.profile, required this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onLongPress: () => onLongPress(),
        onTap: () => Navigator.of(context).pushNamed(
          InspectProfessor.routeName,
          arguments: profile,
        ),
        title: Text(
          '${profile.firstName} ${profile.secondName}',
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.roboto(color: MyColors().purple),
        ),
        // Animatie hero
        leading: Hero(
          tag: profile.tag,
          child: CircleAvatar(
            backgroundImage: NetworkImage(profile.imgUrl),
          ),
        ),
        trailing: Text(
          '${profile.price} LEI',
          style: TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          profile.city,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.roboto(color: MyColors().purpleSixtyPercent),
        ),
      ),
    );
  }
}
