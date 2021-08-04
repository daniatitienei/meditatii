import 'dart:convert';
import 'dart:io';

import 'package:find_your_teacher/src/admob/admob.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/models/city.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/widgets/searchableModal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class Announcement extends StatefulWidget {
  static const String routeName = '/addAnnouncement';

  const Announcement({Key? key}) : super(key: key);

  @override
  _AnnouncementState createState() => _AnnouncementState();
}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);

class _AnnouncementState extends State<Announcement> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(
    text: MyFirebaseAuth().auth.currentUser!.email,
  );
  final TextEditingController _priceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final RegExp numberRegExp = RegExp(r'[0-9]');
  InterstitialAd? _interstitialAd;

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
                        height: MediaQuery.of(context).size.height * 0.20,
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
      return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade300,
        ),
        child: SvgPicture.asset(
          'lib/src/assets/svg/user.svg',
          color: MyColors().purple,
          width: MediaQuery.of(context).size.width * 0.15,
          height: MediaQuery.of(context).size.height * 0.15,
        ),
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
    if (value.length < 10) return 'Numărul trebuie să conțină 10 cifre';
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
    InterstitialAd.load(
        adUnitId: AdMob().interstitialAdId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            this._interstitialAd = ad;
            ad.show();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      body: FutureBuilder<City>(
        future: cities,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<String> listaOrase = [];
            for (int i = 0; i < snapshot.data!.orase.length; i++)
              listaOrase.add(snapshot.data!.orase[i]['nume']);

            return Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                child: ListView(
                  children: [
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: MediaQuery.of(context).size.height *
                                        0.20,
                                    child: _previewImages(),
                                  ),
                                ),
                              ],
                            ),
                            _buildNameTextFormField(
                                _firstNameController, 'Nume'),
                            _buildNameTextFormField(
                                _lastNameController, 'Prenume'),
                            _buildDescriptionTextFormField(
                                _descriptionController),
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
                              data: genuri,
                              defaultValue: "Selectați genul",
                              callBack: (String newVal) {
                                setState(() {
                                  gen = newVal;
                                });
                              },
                            ),
                            Searchable(
                              data: listaOrase,
                              defaultValue: "Selectați orașul",
                              callBack: (String newVal) {
                                setState(() {
                                  oras = newVal;
                                });
                              },
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
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 25),
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (oras == '' || materie == '' || gen == '')
                                return;

                              if (!_formKey.currentState!.validate()) return;

                              String uuid = Uuid().v1();

                              await MyFirebaseStorage().uploadFile(
                                _imageFileList![0].path,
                                uuid,
                              );

                              var imgUrl =
                                  await MyFirebaseStorage().getImageUrl(uuid);

                              await MyFirestore().addAnnouncement(
                                Profile(
                                  uuid: uuid,
                                  email: this._emailController.text,
                                  materie: this.materie,
                                  firstName: this._firstNameController.text,
                                  secondName: this._lastNameController.text,
                                  description: this._descriptionController.text,
                                  phoneNumber: this._numberController.text,
                                  city: this.oras,
                                  price: int.parse(this._priceController.text),
                                  imgUrl: imgUrl,
                                  tag:
                                      '${this._firstNameController.text.toLowerCase()}${this._lastNameController.text.toLowerCase()}$uuid',
                                ),
                              );

                              this._interstitialAd?.show();

                              showToast(
                                'Anunțul a fost adăugat.',
                                context: context,
                                animation:
                                    StyledToastAnimation.slideFromTopFade,
                                position: StyledToastPosition.top,
                                reverseAnimation: StyledToastAnimation.fade,
                                animDuration: Duration(seconds: 1),
                                duration: Duration(seconds: 2),
                                curve: Curves.elasticOut,
                                reverseCurve: Curves.linear,
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
      ),
    );
  }
}
