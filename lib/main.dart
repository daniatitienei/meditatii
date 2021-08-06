import 'package:find_your_teacher/src/admob/admob.dart';
import 'package:find_your_teacher/src/assets/colors/colors.dart';
import 'package:find_your_teacher/src/firebase/firebase.dart';
import 'package:find_your_teacher/src/models/typeOfFilters.dart';
import 'package:find_your_teacher/src/screens/Announcement.dart';
import 'package:find_your_teacher/src/screens/MyAnnouncements.dart';
import 'package:find_your_teacher/src/screens/favorites.dart';
import 'package:find_your_teacher/src/screens/filters.dart';
import 'package:find_your_teacher/src/screens/forgotPassword.dart';
import 'package:find_your_teacher/src/screens/home.dart';
import 'package:find_your_teacher/src/screens/inspectProfessor.dart';
import 'package:find_your_teacher/src/screens/login.dart';
import 'package:find_your_teacher/src/screens/register.dart';
import 'package:find_your_teacher/src/screens/selectedCategory.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final initFuture = MobileAds.instance.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TypeOfFilters(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    Theme.of(context).textTheme.apply(
          bodyColor: MyColors().purple,
          displayColor: MyColors().purple,
        );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText1: TextStyle(),
          bodyText2: TextStyle(),
          headline1: TextStyle(),
          headline2: TextStyle(),
          headline3: TextStyle(),
          headline4: TextStyle(),
          headline5: TextStyle(),
          headline6: TextStyle(),
        ).apply(
          bodyColor: MyColors().purple,
          displayColor: MyColors().purple,
        ),
      ),
      initialRoute: Home.routeName,
      routes: {
        Favorites.routeName: (context) => Favorites(),
        SelectedCategory.routeName: (context) => SelectedCategory(),
        Register.routeName: (context) => Register(),
        Login.routeName: (context) => Login(),
        InspectProfessor.routeName: (context) => InspectProfessor(),
        Announcement.routeName: (context) => Announcement(),
        Filters.routeName: (context) => Filters(),
        ForgotPassword.routeName: (context) => ForgotPassword(),
        MyAnnouncements.routeName: (context) => MyAnnouncements(),
      },
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              !MyFirebaseAuth().isSignedIn())
            return Login();
          else if (snapshot.connectionState == ConnectionState.done &&
              MyFirebaseAuth().isSignedIn()) return Home();
          return Center(
            child: MaterialApp(
              home: Scaffold(
                body: CircularProgressIndicator(
                  color: MyColors().purple,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
