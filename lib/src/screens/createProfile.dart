import 'dart:convert';
import 'dart:io';

import 'package:find_your_teacher/src/admob/admob.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/models/city.dart';
import 'package:find_your_teacher/src/models/judete.dart';
import 'package:find_your_teacher/src/screens/announcement.dart';
import 'package:find_your_teacher/src/screens/home.dart';
import 'package:find_your_teacher/src/widgets/searchableModal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

class CreateProfile extends StatefulWidget {
  static const String routeName = '/createProfile';

  const CreateProfile({Key? key}) : super(key: key);

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController(
    text: MyFirebaseAuth().auth.currentUser!.email,
  );

  String oras = '', judet = '';

  String genderValue = 'Gen';

  final _formKey = GlobalKey<FormState>();

  final RegExp numberRegExp = RegExp(r'[0-9]');

  dynamic _pickImageError;

  List<XFile>? _imageFileList;

  late Future<City> cities;

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
        padding: EdgeInsets.all(30),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: MyColors().purple,
        ),
        child: SvgPicture.asset(
          'lib/src/assets/svg/camera.svg',
          color: Colors.white,
        ),
      );
    }
  }

  nameValidator(String? value, String labelText) {
    if (value!.isEmpty)
      return '${labelText}le trebuie completat.';
    else if (numberRegExp.hasMatch(value))
      return '${labelText}le nu trebuie sa includa numere.';
  }

  phoneValidator(String? value) {
    if (value!.isEmpty) return 'Numărul trebuie completat.';
    if (value.length < 10) return 'Numărul trebuie să conțină 10 cifre';
  }

  priceValidator(String? value) {
    if (value!.isEmpty) return 'Prețul trebuie completat.';
  }

  Widget _selectGender() => DropdownButton<String>(
        underline: Divider(
          color: MyColors().purpleSixtyPercent,
          height: 0,
          thickness: 1,
        ),
        hint: Text(
          genderValue,
          style: GoogleFonts.montserrat(
            color: genderValue == 'Gen'
                ? MyColors().purpleSixtyPercent
                : MyColors().purple,
            fontSize: 16,
          ),
        ),
        style: GoogleFonts.montserrat(
          color: MyColors().purple,
        ),
        iconEnabledColor: MyColors().purple,
        onChanged: (String? newValue) {
          setState(() => genderValue = newValue!);
        },
        items: <String>['Masculin', 'Feminin', 'Altul']
            .map(
              (String value) => DropdownMenuItem(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.montserrat(
                    color: MyColors().purple,
                  ),
                ),
              ),
            )
            .toList(),
      );

  Widget _buildNameTextFormField(
          TextEditingController controller, String labelText) =>
      TextFormField(
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        cursorColor: MyColors().purple,
        validator: (name) => nameValidator(name, labelText),
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(color: MyColors().purple),
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: GoogleFonts.montserrat(
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

  Widget _buildPhoneNumberTextFormField(TextEditingController controller) =>
      Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: TextFormField(
          controller: controller,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          cursorColor: MyColors().purple,
          keyboardType: TextInputType.number,
          validator: (number) => phoneValidator(number),
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(color: MyColors().purple),
          ),
          decoration: InputDecoration(
            labelText: 'Număr de telefon',
            labelStyle: GoogleFonts.montserrat(
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

  Widget _buildEmailTextFormField(TextEditingController controller) =>
      TextFormField(
        controller: controller,
        cursorColor: MyColors().purple,
        style: GoogleFonts.montserrat(
          textStyle: TextStyle(color: MyColors().purple),
        ),
        decoration: InputDecoration(
          labelText: 'Email',
          labelStyle: GoogleFonts.montserrat(
            color: MyColors().purpleSixtyPercent,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: MyColors().purple),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: MyColors().purpleSixtyPercent,
            ),
          ),
        ),
      );

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

  InterstitialAd? _interstitialAd;

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
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  Widget _buildCreateProfileButton() => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            if (_imageFileList?.length == null) {
              showToast(
                'Trebuie să selectați o imagine.',
                context: context,
                animation: StyledToastAnimation.slideFromTopFade,
                position: StyledToastPosition.top,
                reverseAnimation: StyledToastAnimation.fade,
                animDuration: Duration(seconds: 1),
                duration: Duration(seconds: 2),
                curve: Curves.elasticOut,
                reverseCurve: Curves.linear,
              );
              return;
            }

            if (oras == '' || genderValue == '' || judet == '') {
              showToast(
                'Trebuie să completați tot.',
                context: context,
                animation: StyledToastAnimation.slideFromTopFade,
                position: StyledToastPosition.top,
                reverseAnimation: StyledToastAnimation.fade,
                animDuration: Duration(seconds: 1),
                duration: Duration(seconds: 2),
                curve: Curves.elasticOut,
                reverseCurve: Curves.linear,
              );
              return;
            }

            String uuid = Uuid().v1();

            await MyFirebaseStorage().uploadFile(
              _imageFileList![0].path,
              uuid,
            );

            var imgUrl = await MyFirebaseStorage().getImageUrl(uuid);

            MyFirestore().addProfessorProfile(
              nume: this._lastNameController.text.trim(),
              prenume: this._firstNameController.text.trim(),
              email: this._emailController.text,
              numar: this._numberController.text,
              oras: this.oras,
              gen: this.genderValue,
              imageUrl: imgUrl,
              judet: this.judet,
            );

            this._interstitialAd?.show();

            showToast(
              'Profilul a fost creat.',
              context: context,
              animation: StyledToastAnimation.slideFromTopFade,
              position: StyledToastPosition.top,
              reverseAnimation: StyledToastAnimation.fade,
              animDuration: Duration(seconds: 1),
              duration: Duration(seconds: 3),
              curve: Curves.elasticOut,
              reverseCurve: Curves.linear,
            );

            MyFirestore()
                .hasProfessorProfile()
                .then((response) => print(response));

            Navigator.of(context).pushNamedAndRemoveUntil(
              Home.routeName,
              (route) => false,
            );
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
              EdgeInsets.only(top: 14, bottom: 14),
            ),
            backgroundColor: MaterialStateProperty.all(
              MyColors().purple,
            ),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(10),
              ),
            ),
          ),
          child: Text(
            'Creează profilul'.toUpperCase(),
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Creare profil de profesor',
          style: GoogleFonts.montserrat(
            color: MyColors().purple,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: FutureBuilder<City>(
        future: cities,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<String> listaOrase = [];
            final List<String> listaJudete = Judete().judete;
            for (int i = 0; i < snapshot.data!.orase.length; i++)
              listaOrase.add('${snapshot.data!.orase[i]['nume']}');

            return Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.only(bottom: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
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
                                _lastNameController, 'Nume'),
                            _buildNameTextFormField(
                                _firstNameController, 'Prenume'),
                            _buildEmailTextFormField(_emailController),
                            _buildPhoneNumberTextFormField(_numberController),
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
                              data: listaJudete,
                              defaultValue: "Selectați județul",
                              callBack: (String newVal) {
                                setState(() {
                                  judet = newVal;
                                });
                              },
                            ),
                            _selectGender(),
                          ],
                        ),
                      ],
                    ),
                    _buildCreateProfileButton(),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) return Text('${snapshot.error}');

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
