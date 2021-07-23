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
  final int announces;
  final String imageUrl;

  const Materie(
      {required this.circleColor,
      required this.backgroundColor,
      required this.title,
      required this.announces,
      required this.imageUrl,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
        SelectedCategory.routeName,
        arguments: CategoryTitle(title: this.title),
      ),
      child: Container(
        color: this.backgroundColor,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width * 0.08,
          10,
          MediaQuery.of(context).size.width * 0.08,
          10,
        ),
        margin: EdgeInsets.only(bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
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
                Container(
                  margin: EdgeInsets.only(left: 25),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        this.title,
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: MyColors().purple,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        '${this.announces} anunturi',
                        style: GoogleFonts.roboto(
                          textStyle: TextStyle(
                            color: MyColors().purple,
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: MyColors().purple,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
