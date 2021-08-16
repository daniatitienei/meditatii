import 'dart:convert';

import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/models/city.dart';
import 'package:find_your_teacher/src/models/judete.dart';
import 'package:find_your_teacher/src/models/typeOfFilters.dart';
import 'package:find_your_teacher/src/widgets/searchableModal.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Filters extends StatefulWidget {
  static const String routeName = '/filters';
  const Filters({Key? key}) : super(key: key);

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  List<String> ordonareArr = [
    'Crescător',
    'Descrescător',
    'Noi',
  ];

  String ordonare = 'Noi';

  late Future<City> cities;

  Future<City> fetchCities() async {
    final response = await http.get(
      Uri.parse(
        'https://raw.githubusercontent.com/catalin87/baza-de-date-localitati-romania/master/date/localitati.json',
      ),
    );

    if (response.statusCode == 200) {
      return City.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load city');
    }
  }

  @override
  void initState() {
    super.initState();
    cities = fetchCities();
  }

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
        body: FutureBuilder<City>(
          future: cities,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<String> listaOrase = [];
              for (int i = 0; i < snapshot.data!.orase.length; i++)
                listaOrase.add(snapshot.data!.orase[i]['nume']);

              return SafeArea(
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
                            style: GoogleFonts.montserrat(
                              textStyle: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w500,
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
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 10),
                                child: GroupButton(
                                  isRadio: true,
                                  selectedButton: Provider.of<TypeOfFilters>(
                                          context,
                                          listen: false)
                                      .defaultNumber,
                                  mainGroupAlignment: MainGroupAlignment.start,
                                  buttons: ordonareArr,
                                  onSelected: (index, isSelected) {
                                    this.ordonare = this.ordonareArr[index];
                                  },
                                  spacing: 10,
                                  selectedColor: MyColors().purple,
                                  unselectedColor:
                                      MyColors().purpleSixtyPercent,
                                  selectedShadow: <BoxShadow>[
                                    BoxShadow(color: Colors.transparent)
                                  ],
                                  unselectedShadow: <BoxShadow>[
                                    BoxShadow(color: Colors.transparent)
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  selectedTextStyle: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  unselectedTextStyle: GoogleFonts.montserrat(
                                    textStyle: TextStyle(
                                      fontSize: 14,
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
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Searchable(
                                data: listaOrase,
                                defaultValue: Provider.of<TypeOfFilters>(
                                  context,
                                  listen: false,
                                ).locatie,
                                callBack: (String newVal) {
                                  setState(() {
                                    Provider.of<TypeOfFilters>(
                                      context,
                                      listen: false,
                                    ).setLocatie = newVal;
                                  });
                                },
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                child: Text(
                                  'Județ',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Searchable(
                                data: Judete().judete,
                                defaultValue: Provider.of<TypeOfFilters>(
                                  context,
                                  listen: false,
                                ).judet,
                                callBack: (String newVal) {
                                  setState(() {
                                    Provider.of<TypeOfFilters>(
                                      context,
                                      listen: false,
                                    ).setJudet = newVal;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(bottom: 10),
                        child: ElevatedButton(
                          onPressed: () {
                            // Provider.of<TypeOfFilters>(context, listen: false)
                            // .setLocatie = this.oras ?? this.oras as String;
                            Provider.of<TypeOfFilters>(context, listen: false)
                                .setOrdonare = this.ordonare;
                            Provider.of<TypeOfFilters>(context, listen: false)
                                    .defaultNumber =
                                this.ordonareArr.indexOf(this.ordonare);

                            Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(MyColors().purple),
                            padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Text(
                            'Salvează modificările',
                            style: GoogleFonts.montserrat(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }

            return Center(
              child: CircularProgressIndicator(
                color: MyColors().purple,
              ),
            );
          },
        ));
  }
}
