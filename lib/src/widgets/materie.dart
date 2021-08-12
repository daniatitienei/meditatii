import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/models/categoryTitle.dart';
import 'package:find_your_teacher/src/screens/selectedCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class Materie extends StatelessWidget {
  final Color circleColor;
  final Color backgroundColor;
  final String title;
  final announces;
  final String imageUrl;

  const Materie({
    required this.circleColor,
    required this.backgroundColor,
    required this.title,
    required this.announces,
    required this.imageUrl,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 13),
      child: ListTile(
        onTap: () => Navigator.of(context).pushNamed(
          SelectedCategory.routeName,
          arguments: CategoryTitle(title: this.title),
        ),
        contentPadding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.08,
          5,
          MediaQuery.of(context).size.width * 0.08,
          5,
        ),
        tileColor: this.backgroundColor,
        leading: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: this.circleColor,
          ),
          child: SvgPicture.network(
            this.imageUrl,
            width: 40,
            height: 40,
            placeholderBuilder: (context) => SvgPicture.asset(
              'lib/src/assets/svg/graduation-hat.svg',
              width: 40,
              height: 40,
            ),
          ),
        ),
        title: Text(
          this.title,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: MyColors().purple,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        subtitle: Text(
          '${this.announces} anunțuri',
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: MyColors().purple,
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          color: MyColors().purple,
        ),
      ),
    );
  }
}
