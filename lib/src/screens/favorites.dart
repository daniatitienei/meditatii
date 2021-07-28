import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/widgets/professorItem.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Favorites extends StatelessWidget {
  static const String routeName = '/favorites';

  final Stream<DocumentSnapshot> _favoriteStream = FirebaseFirestore.instance
      .collection('users')
      .doc(MyFirebaseAuth().auth.currentUser!.email)
      .snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _favoriteStream,
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
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Favorite',
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
                        final myData = snapshot.data!.get('favorite')[index];

                        return ProfessorItem(
                          profile: Profile(
                            uuid: myData['uuid'],
                            imgUrl: myData['imgUrl'],
                            tag: myData['tag'],
                            firstName: myData['nume'],
                            secondName: myData['prenume'],
                            email: myData['email'],
                            description: myData['descriere'],
                            city: myData['oras'],
                            street: myData['strada'],
                            phoneNumber: myData['numar'],
                            materie: myData['materie'],
                            price: myData['pret'],
                          ),
                        );
                      },
                      childCount: snapshot.data!.get('favorite').length,
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
