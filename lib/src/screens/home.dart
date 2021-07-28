import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/screens/favorites.dart';
import 'package:find_your_teacher/src/screens/selectedCategory.dart';
import 'package:find_your_teacher/src/widgets/addAnnouncement.dart';

import 'package:find_your_teacher/src/widgets/materie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  static const String routeName = '/';

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final Stream<QuerySnapshot> _materiiStream =
      FirebaseFirestore.instance.collection('materii').snapshots();

  PageController _pageController = PageController();

  Widget _BottomBar() => BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: MyColors().purple,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () => _pageController.jumpToPage(0),
              icon: Icon(
                Icons.home,
              ),
              color: Colors.white,
            ),
            IconButton(
              onPressed: () => _pageController.jumpToPage(1),
              icon: Icon(
                Icons.favorite,
              ),
              color: Colors.white,
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      floatingActionButton: AddAnnouncement(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _BottomBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _materiiStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: TargetPlatform.android == true
                  ? CircularProgressIndicator(
                      color: MyColors().purple,
                    )
                  : CupertinoActivityIndicator(),
            );

          return PageView(
            controller: _pageController,
            children: [
              SafeArea(
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                      floating: true,
                      pinned: true,
                      snap: true,
                      expandedHeight: 80,
                      backgroundColor: Colors.white,
                      actions: [
                        IconButton(
                          onPressed: () => MyFirebaseAuth().signOut(context),
                          icon: Icon(
                            Icons.remove_done_rounded,
                          ),
                          color: MyColors().purple,
                        )
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(
                          'Categorii',
                          style: GoogleFonts.roboto(color: MyColors().purple),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) => Materie(
                          circleColor: MyColors().circleColors[index],
                          backgroundColor: MyColors().backgroundColors[index],
                          title: snapshot.data!.docs[index].id,
                          announces:
                              snapshot.data!.docs[index]['anunturi'].length,
                          imageUrl: snapshot.data!.docs[index]['imageUrl'],
                        ),
                        childCount: snapshot.data?.docs.length,
                      ),
                    ),
                  ],
                ),
              ),
              Favorites(),
            ],
          );
        },
      ),
    );
  }
}
