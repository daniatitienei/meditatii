import 'dart:io';

import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/widgets/searchableModal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class Announcement extends StatefulWidget {
  static const String routeName = '/addAnouncement';

  const Announcement({Key? key}) : super(key: key);

  @override
  _AnnouncementState createState() => _AnnouncementState();
}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);

class _AnnouncementState extends State<Announcement> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(
    text: MyFirebaseAuth().auth.currentUser!.email,
  );
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

  final List<String> genuri = ['Masculin', 'Feminin', 'Altul'];

  String materie = '', oras = '', gen = '';

  dynamic _pickImageError;

  final String uuid = Uuid().v5(Uuid.NAMESPACE_URL, 'www.google.com');

  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  final ImagePicker _picker = ImagePicker();

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    await _displayPickImageDialog(context!,
        (double? maxWidth, double? maxHeight, int? quality) async {
      try {
        final pickedFile = await _picker.pickImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        setState(() {
          _imageFile = pickedFile;
        });
      } catch (e) {
        setState(() {
          _pickImageError = e;
        });
      }
    });
  }

  _displayPickImageDialog(BuildContext context, OnPickImageCallback onPick) =>
      onPick(null, null, null);

  Widget _previewImages() {
    if (_imageFileList != null) {
      return Semantics(
          child: ListView.builder(
            key: UniqueKey(),
            itemBuilder: (context, index) {
              return Semantics(
                label: 'image_picker_example_picked_image',
                child: kIsWeb
                    ? Image.network(_imageFileList![index].path)
                    : Container(
                        width: MediaQuery.of(context).size.width * 0.35,
                        height: MediaQuery.of(context).size.height * 0.15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: FileImage(File(_imageFileList![index].path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
              );
            },
            itemCount: _imageFileList!.length,
          ),
          label: 'image_picker_example_picked_images');
    } else if (_pickImageError != null) {
      return Text(
        'Pick image error: $_pickImageError',
        textAlign: TextAlign.center,
      );
    } else {
      return SvgPicture.asset(
        'lib/src/assets/svg/user.svg',
        color: MyColors().purple,
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.height * 0.15,
      );
    }
  }

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
          LengthLimitingTextInputFormatter(10),
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

  Widget _buildEmailTextFormField(TextEditingController controller) =>
      TextFormField(
        controller: controller,
        cursorColor: MyColors().purple,
        style: GoogleFonts.roboto(
          textStyle: TextStyle(color: MyColors().purple),
        ),
        decoration: InputDecoration(
          hintText: 'Email',
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
          child: ListView(
            children: [
              Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => _onImageButtonPressed(
                              ImageSource.gallery,
                              context: context,
                            ),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height * 0.15,
                              child: _previewImages(),
                            ),
                          ),
                        ],
                      ),
                      _buildNameTextFormField(_firstNameController, 'Nume'),
                      _buildNameTextFormField(_lastNameController, 'Prenume'),
                      _buildStreetTextFormField(_streetController),
                      _buildDescriptionTextFormField(_descriptionController),
                      _buildEmailTextFormField(_emailController),
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
                        callBack: (String newVal) {
                          setState(() {
                            materie = newVal;
                          });
                        },
                      ),
                      Searchable(
                        data: orase,
                        defaultValue: "Selectați orașul",
                        callBack: (String newVal) {
                          setState(() {
                            oras = newVal;
                          });
                        },
                      ),
                      Searchable(
                        data: genuri,
                        defaultValue: "Selectați genul",
                        callBack: (String newVal) {
                          setState(() {
                            gen = newVal;
                          });
                        },
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 25),
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (oras == '' || materie == '' || gen == '') return;

                        if (!_formKey.currentState!.validate()) return;

                        await MyFirebaseStorage()
                            .uploadFile(_imageFileList![0].path, uuid);

                        var imgUrl =
                            await MyFirebaseStorage().getImageUrl(uuid);

                        await MyFirestore().addAnnouncement(
                          Profile(
                            uuid: this.uuid,
                            email: this._emailController.text,
                            materie: this.materie,
                            firstName: this._firstNameController.text,
                            secondName: this._lastNameController.text,
                            description: this._descriptionController.text,
                            phoneNumber: this._numberController.text,
                            street: this._streetController.text,
                            city: this.oras,
                            price: int.parse(this._priceController.text),
                            imgUrl: imgUrl,
                            tag:
                                '${this._firstNameController.text} ${this._lastNameController.text}',
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                          EdgeInsets.only(
                            top: 14,
                            bottom: 14,
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all(
                          (oras == '' ||
                                  materie == '' ||
                                  gen == '' ||
                                  _imageFileList?.length == null)
                              ? MyColors().purpleSixtyPercent
                              : MyColors().purple,
                        ),
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
            ],
          ),
        ),
      ),
    );
  }
}
