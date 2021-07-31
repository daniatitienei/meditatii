import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/screens/favorites.dart';

import 'package:find_your_teacher/src/widgets/addAnnouncement.dart';
import 'package:shimmer/shimmer.dart';
import 'package:find_your_teacher/src/widgets/materie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
              child: Platform.isAndroid == true
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
                        (BuildContext context, int index) => StreamBuilder<
                                QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection(
                                  'materii/${snapshot.data!.docs[index].id}/anunturi',
                                )
                                .snapshots(),
                            builder: (context, snapshot2) {
                              if (snapshot2.connectionState ==
                                  ConnectionState.waiting)
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade400,
                                  highlightColor: Colors.grey.shade300,
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    child: Shimmer.fromColors(
                                      baseColor: Colors.grey.shade400,
                                      highlightColor: Colors.grey.shade300,
                                      child: ListTile(
                                        contentPadding: EdgeInsets.fromLTRB(
                                          MediaQuery.of(context).size.width *
                                              0.08,
                                          5,
                                          MediaQuery.of(context).size.width *
                                              0.08,
                                          5,
                                        ),
                                        leading: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade400,
                                          highlightColor: Colors.grey.shade300,
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              color: Colors.green,
                                              shape: BoxShape.circle,
                                            ),
                                            child: SvgPicture.asset(
                                              'lib/src/assets/svg/graduation-hat.svg',
                                              width: 40,
                                              height: 40,
                                            ),
                                          ),
                                        ),
                                        title: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade400,
                                          highlightColor: Colors.grey.shade300,
                                          child: Container(
                                            height: 15,
                                            color: Colors.green,
                                          ),
                                        ),
                                        subtitle: Shimmer.fromColors(
                                          baseColor: Colors.grey.shade400,
                                          highlightColor: Colors.grey.shade300,
                                          child: Container(
                                            height: 10,
                                            color: Colors.green,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );

                              return Materie(
                                circleColor: MyColors().circleColors[index],
                                backgroundColor:
                                    MyColors().backgroundColors[index],
                                title: snapshot.data!.docs[index].id,
                                announces: snapshot2.data?.size,
                                imageUrl: snapshot.data!.docs[index]
                                    ['imageUrl'],
                              );
                            }),
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
