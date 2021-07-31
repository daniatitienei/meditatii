import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/models/typeOfFilters.dart';
import 'package:find_your_teacher/src/widgets/searchableModal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';

class Filters extends StatefulWidget {
  static const String routeName = '/filters';
  const Filters({Key? key}) : super(key: key);

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  String? oras;

  List<String> orase = [
        'Resita',
        'Bucuresti',
        'Timisoara',
      ],
      ordonareArr = [
        'Crescător',
        'Descrescător',
        'Noi',
      ];

  String ordonare = 'Noi';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.close,
            color: MyColors().purple,
            size: 32,
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        minimum: EdgeInsets.only(top: 5),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 25, right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Filtre',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'Ordonează după:',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: GroupButton(
                          isRadio: true,
                          selectedButton: 2,
                          mainGroupAlignment: MainGroupAlignment.start,
                          buttons: ordonareArr,
                          onSelected: (index, isSelected) {
                            this.ordonare = this.ordonareArr[index];
                          },
                          spacing: 10,
                          selectedColor: MyColors().purple,
                          unselectedColor: MyColors().purpleSixtyPercent,
                          selectedShadow: <BoxShadow>[
                            BoxShadow(color: Colors.transparent)
                          ],
                          unselectedShadow: <BoxShadow>[
                            BoxShadow(color: Colors.transparent)
                          ],
                          borderRadius: BorderRadius.circular(10),
                          selectedTextStyle: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          unselectedTextStyle: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        child: Text(
                          'Locație',
                          style: GoogleFonts.roboto(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Searchable(
                        data: orase,
                        defaultValue: 'Alegeți locația',
                        callBack: (String newVal) {
                          setState(() {
                            oras = newVal;
                          });
                        },
                      )
                    ],
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(bottom: 10),
                child: ElevatedButton(
                  onPressed: () {
                    TypeOfFilters filtre = TypeOfFilters();

                    filtre.setLocatie = this.oras ?? this.oras as String;
                    filtre.setOrdonare = this.ordonare;
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(MyColors().purple),
                    padding: MaterialStateProperty.all(
                      EdgeInsets.only(
                        top: 10,
                        bottom: 10,
                      ),
                    ),
                  ),
                  child: Text(
                    'Salvează modificările',
                    style: GoogleFonts.roboto(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
