import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/widgets/searchableModal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Announcement extends StatefulWidget {
  static const String routeName = '/addAnouncement';

  const Announcement({Key? key}) : super(key: key);

  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final RegExp numberRegExp = RegExp(r'[0-9]');

  final List<String> orase = ['Resita', 'Arad', 'Alba', 'Bucuresti'];

  final List<String> materii = [
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
  ];

  nameValidator(String? value, String hintText) {
    if (value!.isEmpty)
      return '${hintText}le trebuie completat.';
    else if (numberRegExp.hasMatch(value))
      return '${hintText}le nu trebuie sa includa numere.';
  }

  phoneValidator(String? value) {
    if (value!.isEmpty) return 'Numărul trebuie completat.';
  }

  priceValidator(String? value) {
    if (value!.isEmpty) return 'Prețul trebuie completat.';
  }

  Widget _buildNameTextFormField(
          TextEditingController controller, String hintText) =>
      TextFormField(
        controller: controller,
        cursorColor: MyColors().purple,
        validator: (name) => nameValidator(name, hintText),
        style: GoogleFonts.roboto(
          textStyle: TextStyle(color: MyColors().purple),
        ),
        decoration: InputDecoration(
          hintText: hintText,
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
      );

  Widget _buildStreetTextFormField(TextEditingController controller) =>
      TextFormField(
        controller: controller,
        cursorColor: MyColors().purple,
        validator: (address) {
          if (address!.isEmpty) return 'Adresa trebuie completată';
        },
        style: GoogleFonts.roboto(
          textStyle: TextStyle(color: MyColors().purple),
        ),
        decoration: InputDecoration(
          hintText: 'Adresă',
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
      );

  Widget _buildDescriptionTextFormField(TextEditingController controller) =>
      ConstrainedBox(
        constraints:
            BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.2),
        child: TextFormField(
          controller: controller,
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
              borderSide: BorderSide(color: MyColors().purpleSixtyPercent),
            ),
          ),
        ),
      );

  Widget _buildPhoneNumberTextFormField(TextEditingController controller) =>
      TextFormField(
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        cursorColor: MyColors().purple,
        keyboardType: TextInputType.number,
        validator: (number) => phoneValidator(number),
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
      );

  Widget _buildPriceTextFormField(TextEditingController controller) =>
      Container(
        width: MediaQuery.of(context).size.width * 0.5,
        child: TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          controller: controller,
          cursorColor: MyColors().purple,
          keyboardType: TextInputType.number,
          validator: (value) => priceValidator(value),
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
              borderSide: BorderSide(color: MyColors().purpleSixtyPercent),
            ),
          ),
        ),
      );

  final String imageUrl =
      'https://scontent.fclj2-1.fna.fbcdn.net/v/t1.6435-9/89625766_1466749073502837_7540155679034572800_n.jpg?_nc_cat=104&ccb=1-3&_nc_sid=174925&_nc_ohc=U-mIxfB-SZ8AX-R76vv&_nc_ht=scontent.fclj2-1.fna&oh=85b987926553621ea0033864cde8bcdf&oe=61205662';

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
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildNameTextFormField(_firstNameController, 'Prenume'),
                  _buildNameTextFormField(_lastNameController, 'Nume'),
                  _buildStreetTextFormField(_streetController),
                  _buildDescriptionTextFormField(_descriptionController),
                  _buildPhoneNumberTextFormField(_numberController),
                  Row(
                    children: [
                      _buildPriceTextFormField(_priceController),
                      Text(
                        'LEI',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Searchable(
                    data: materii,
                    defaultValue: "Selectați materia",
                  ),
                  Searchable(
                    data: orase,
                    defaultValue: "Selectați orașul",
                  ),
                ],
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) return;
                  },
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                      EdgeInsets.only(
                        top: 14,
                        bottom: 14,
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(MyColors().purple),
                  ),
                  child: Text(
                    'Adăugați anunțul',
                    style: GoogleFonts.roboto(
                      textStyle: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
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
