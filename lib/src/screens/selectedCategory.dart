import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/models/categoryTitle.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/models/typeOfFilters.dart';
import 'package:find_your_teacher/src/screens/filters.dart';
import 'package:find_your_teacher/src/widgets/addAnnouncement.dart';
import 'package:find_your_teacher/src/widgets/professorItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shimmer/flutter_shimmer.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SelectedCategory extends StatelessWidget {
  static const String routeName = '/selectedCategory';

  const SelectedCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CategoryTitle;

    final Stream<QuerySnapshot> _anunturiStream = FirebaseFirestore.instance
        .collection('materii/${args.title}/anunturi')
        // .where('oras', isEqualTo: 'Resita')
        .orderBy(
          Provider.of<TypeOfFilters>(context).getVariableName(),
          descending: Provider.of<TypeOfFilters>(context).getBoolForValue(),
        )
        .snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          args.title,
          style: GoogleFonts.roboto(
            color: MyColors().purple,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).pushNamed(Filters.routeName),
            icon: Icon(
              Icons.filter_list,
            ),
            color: MyColors().purple,
          ),
        ],
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
          color: MyColors().purple,
        ),
      ),
      extendBody: true,
      floatingActionButton: AddAnnouncement(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomNavigationBar: BottomBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _anunturiStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
              margin: EdgeInsets.only(top: 80),
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ListTileShimmer(
                    hasCustomColors: true,
                    height: 15,
                    colors: [
                      // Dark color
                      Colors.grey.shade400,
                      // light color
                      Colors.grey.shade200,
                      // Medium color
                      Colors.grey.shade300,
                    ],
                  ),
                ),
                itemCount: 10,
              ),
            );

          return SafeArea(
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
                  Map<String, dynamic> data =
                      documentSnapshot.data() as Map<String, dynamic>;

                  return ProfessorItem(
                    profile: Profile(
                      uuid: data['uuid'],
                      imgUrl: data['imgUrl'],
                      tag: data['tag'],
                      firstName: data['nume'],
                      secondName: data['prenume'],
                      email: data['email'],
                      description: data['descriere'],
                      city: data['oras'],
                      street: data['strada'],
                      phoneNumber: data['numar'],
                      materie: data['materie'],
                      price: data['pret'],
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}
