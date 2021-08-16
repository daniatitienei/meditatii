import 'dart:convert';
import 'dart:io';

import 'package:find_your_teacher/src/admob/admob.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/models/editAnnouncementModel.dart';
import 'package:find_your_teacher/src/models/professorProfile.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/screens/myAnnouncements.dart';
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

class EditAnnouncement extends StatefulWidget {
  final Profile profile;
  const EditAnnouncement({
    required this.profile,
    Key? key,
  }) : super(key: key);

  @override
  _EditAnnouncementState createState() => _EditAnnouncementState();
}

typedef void OnPickImageCallback(
    double? maxWidth, double? maxHeight, int? quality);

class _EditAnnouncementState extends State<EditAnnouncement> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _descriptionController = TextEditingController();

  final TextEditingController _priceController = TextEditingController();

  String materie = '';

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
    'Logică',
    'Psihologie',
    'Filosofie',
    'Sport',
  ];

  priceValidator(String? value) {
    if (value!.isEmpty) return 'Prețul trebuie completat.';
  }

  Widget _buildDescriptionTextFormField(TextEditingController controller) =>
      ConstrainedBox(
        constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.15),
        child: TextFormField(
          textCapitalization: TextCapitalization.sentences,
          controller: controller,
          cursorColor: MyColors().purple,
          minLines: 1,
          maxLines: 10,
          keyboardType: TextInputType.multiline,
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(color: MyColors().purple),
          ),
          decoration: InputDecoration(
            labelText: 'Descriere',
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

  Widget _buildPriceTextFormField(TextEditingController controller) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          child: TextFormField(
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
            controller: controller,
            cursorColor: MyColors().purple,
            keyboardType: TextInputType.number,
            validator: (value) => priceValidator(value),
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(color: MyColors().purple),
            ),
            decoration: InputDecoration(
              suffixText: 'RON',
              suffixStyle: GoogleFonts.montserrat(
                color: MyColors().purpleSixtyPercent,
              ),
              labelText: 'Preț pe sesiune',
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
        ),
      );

  @override
  void initState() {
    super.initState();

    this._descriptionController.text = widget.profile.description;
    this._priceController.text = widget.profile.price.toString();
    this.materie = widget.profile.materie;

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
      ),
    );
  }

  Future<void> _deleteDialog(Profile profile) async => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Sigur doriți să ștergeți anunțul?',
            style: GoogleFonts.montserrat(
              color: MyColors().purple,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Color(0xFFbd2834),
                ),
              ),
              child: Text(
                'Nu',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  MyColors().purple,
                ),
              ),
              child: Text(
                'Da',
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              onPressed: () {
                MyFirestore().removeAnnouncement(profile);
                Navigator.of(context).pushNamedAndRemoveUntil(
                    MyAnnouncements.routeName, (route) => false);
              },
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Editează anunțul',
          style: GoogleFonts.montserrat(
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
          padding: EdgeInsets.symmetric(vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'lib/src/assets/svg/edit-anunt.svg',
                            width: MediaQuery.of(context).size.width * .7,
                          ),
                        ],
                      ),
                      _buildDescriptionTextFormField(_descriptionController),
                      _buildPriceTextFormField(_priceController),
                      Searchable(
                        data: materii,
                        defaultValue: materie,
                        callBack: (String newVal) {
                          setState(() {
                            materie = newVal;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          showToast(
                            'Anunțul a fost editat.',
                            context: context,
                            animation: StyledToastAnimation.slideFromTopFade,
                            position: StyledToastPosition.top,
                            reverseAnimation: StyledToastAnimation.fade,
                            animDuration: Duration(seconds: 1),
                            duration: Duration(seconds: 2),
                            curve: Curves.elasticOut,
                            reverseCurve: Curves.linear,
                          );

                          this._interstitialAd?.show();

                          ProfessorProfile? professorProfile;
                          await MyFirestore().getProfesorDetails().then(
                                (ProfessorProfile profile) =>
                                    professorProfile = profile,
                              );

                          await MyFirestore().editAnnouncement(
                            EditAnnouncementModel(
                              uuid: widget.profile.uuid,
                              description: this._descriptionController.text,
                              materie: materie,
                              price: int.parse(
                                this._priceController.text,
                              ),
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
                            materie == ''
                                ? MyColors().purpleSixtyPercent
                                : MyColors().purple,
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
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        onPressed: () => _deleteDialog(widget.profile),
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                            EdgeInsets.only(
                              top: 14,
                              bottom: 14,
                            ),
                          ),
                          backgroundColor: MaterialStateProperty.all(
                            Color(0xFFbd2834),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        child: Text(
                          'Ștergeți anunțul',
                          style: GoogleFonts.montserrat(
                            textStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
