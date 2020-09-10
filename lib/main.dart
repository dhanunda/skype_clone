// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts/provider/image_upload_provider.dart';
import 'package:contacts/provider/user_provider.dart';
import 'package:contacts/resources/firebase_repository.dart';
import 'package:contacts/screens/Homescreen.dart';
import 'package:contacts/screens/LoginsScreen.dart';
import 'package:contacts/screens/searchscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'Homepage.dart';

void main(){runApp(MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
    ChangeNotifierProvider(create: (_) => UserProvider()),
  ],
  child:   MaterialApp(
    title: "skype clone",
    home: Myapp(),
    theme: ThemeData(
      // primaryColor: Colors.black,
      // backgroundColor: Colors.black,
      brightness: Brightness.dark,
    ),
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/search_screen': (context) => SearchScreen(),
    },
  ),
));}

class Myapp extends StatefulWidget {
  @override
  _MyappState createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  FirebaseRepository _repository=FirebaseRepository();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _repository.getCurrentUser(),
        builder: (context,AsyncSnapshot<FirebaseUser>snapshot) {
          if(snapshot.hasData){
            return HomeScreen();
          }
          else
            {
              return LoginScreen();
            }
        }
    );
  }
}

