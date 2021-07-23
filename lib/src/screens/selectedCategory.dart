import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/models/categoryTitle.dart';
import 'package:find_your_teacher/src/widgets/addAnnouncement.dart';

import 'package:find_your_teacher/src/widgets/professorItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectedCategory extends StatelessWidget {
  static const String routeName = '/selectedCategory';

  const SelectedCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CategoryTitle;

    final Stream<DocumentSnapshot> _anunturiStream = FirebaseFirestore.instance
        .collection('materii')
        .doc(args.title)
        .snapshots();

    return Scaffold(
      extendBody: true,
      floatingActionButton: AddAnnouncement(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomNavigationBar: BottomBar(),
      body: StreamBuilder(
        stream: _anunturiStream,
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(
                color: MyColors().purple,
              ),
            );

          return SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: true,
                  snap: true,
                  expandedHeight: 80,
                  backgroundColor: Colors.white,
                  leading: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                    ),
                    color: MyColors().purple,
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      args.title,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: MyColors().purple,
                        textStyle: TextStyle(),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final myData = snapshot.data!.get('anunturi')[index];
                        return ProfessorItem();
                      },
                      childCount: snapshot.data!.get('anunturi').length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
