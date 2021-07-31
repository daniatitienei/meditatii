import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/models/categoryTitle.dart';
import 'package:find_your_teacher/src/models/profile.dart';
import 'package:find_your_teacher/src/models/typeOfFilters.dart';
import 'package:find_your_teacher/src/screens/filters.dart';
import 'package:find_your_teacher/src/widgets/addAnnouncement.dart';
import 'package:find_your_teacher/src/widgets/professorItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class SelectedCategory extends StatelessWidget {
  static const String routeName = '/selectedCategory';

  const SelectedCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as CategoryTitle;

    final Stream<QuerySnapshot> _anunturiStream = FirebaseFirestore.instance
        .collection('materii/${args.title}/anunturi')
        .orderBy(
          Provider.of<TypeOfFilters>(context).getVariableName(),
          descending: Provider.of<TypeOfFilters>(context).getBoolForValue(),
        )
        .snapshots();

    return Scaffold(
      extendBody: true,
      floatingActionButton: AddAnnouncement(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // bottomNavigationBar: BottomBar(),
      body: StreamBuilder<QuerySnapshot>(
        stream: _anunturiStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return SafeArea(
              child: Container(
                margin: EdgeInsets.only(top: 80),
                child: ListView.builder(
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade400,
                      highlightColor: Colors.grey.shade300,
                      child: ListTile(
                        contentPadding: EdgeInsets.fromLTRB(
                          MediaQuery.of(context).size.width * 0.08,
                          5,
                          MediaQuery.of(context).size.width * 0.08,
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
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                        title: Shimmer.fromColors(
                          baseColor: Colors.grey.shade400,
                          highlightColor: Colors.grey.shade300,
                          child: Container(
                            color: Colors.green,
                            height: 15,
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
                  itemCount: 10,
                ),
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
                  actions: [
                    IconButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(Filters.routeName),
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
                        return Container(
                          height: MediaQuery.of(context).size.height,
                          child: ListView(
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              Map<String, dynamic> data = documentSnapshot
                                  .data() as Map<String, dynamic>;

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
                        );
                      },
                      childCount: snapshot.data!.docs.length,
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
