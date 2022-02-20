import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddrop2/main.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:fooddrop2/screens/forgotPassword.dart';
import 'package:fooddrop2/screens/home.dart';
import 'package:fooddrop2/screens/login.dart';
import 'package:fooddrop2/screens/signup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:fooddrop2/screens/home.dart';

class MarkerPage extends StatefulWidget {
  const MarkerPage({Key? key}) : super(key: key);

  @override
  _MarkerPageState createState() => _MarkerPageState();
}

class _MarkerPageState extends State<MarkerPage> {
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  TextEditingController titleController = TextEditingController();
  TextEditingController infoController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController phoneController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Add Home',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,

                            fontSize: 30),
                      )),

                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Institution Name");
                        }

                        return null;
                      },
                      onSaved: (value) {
                        titleController.text = value!;
                        //Do something with the user input.
                      },
                      controller: titleController,
                      decoration: InputDecoration(
                        errorText: errorMessage,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),

                        ),
                        labelText: ' Enter Institution Name',

                        prefixIcon: Icon(Icons.title_outlined),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      validator: (value) {
                        // RegExp regex = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Enter short Info about Institution");
                        }

                        return null;
                      },
                      onSaved: (value) {
                        latController.text =
                        LoginState.currentPosition.latitude as String;
                        //Do something with the user input.
                      },
                      controller: infoController,
                      decoration: InputDecoration(
                        errorText: errorMessage,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),

                        ),
                        prefixIcon: Icon(Icons.info_outline),

                        labelText: 'Enter Info about  Institution',
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Institution Phone");
                        }

                        return null;
                      },
                      onSaved: (value) {
                        phoneController.text = value!;
                        //Do something with the user input.
                      },
                      controller: phoneController,
                      decoration: InputDecoration(
                        errorText: errorMessage,

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),

                        ),
                        labelText: ' Enter Institution Number',

                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                  ),


                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Submit Home'),
                          onPressed: () async {
                          this.addMarkerToFireStore();
                          setState(() {
                            showSpinner = true;
                          });

                        },
                      )
                  ),

                ],
              )),
        ));
  }

addMarkerToFireStore() async {

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  HomeModel homeModel = HomeModel();

  homeModel.title = titleController.text;
  homeModel.info = infoController.text;
  homeModel.phone = phoneController.text;
  homeModel.lat = LoginState.currentPosition.latitude   ;
  homeModel.long = LoginState.currentPosition.longitude;


  await firebaseFirestore
      .collection("homes")
      .add(homeModel.toMap()).catchError((e)=>"failed").then((uid)=>{

  });
  setState(() {
    showSpinner = false;
  });
  Fluttertoast.showToast(msg: "Home Added Successfully :) ");
  Navigator.pushAndRemoveUntil((context),

      MaterialPageRoute(builder: (context) => Map()),
          (route) => false);

}}
  // void addMarker(String title, String snippet,) async {
  //   // if (_formKey.currentState!.validate()) {
  //   try {
//       await _auth
//           .(title: title, snippet: snippet)
//           .then((uid) =>
//       {
//         Fluttertoast.showToast(msg: "Login Successful"),
//         Navigator.of(context).pushReplacement(
//             MaterialPageRoute(builder: (context) => Map())),
//       });
//     } on FirebaseAuthException catch (error) {
//       switch (error.code) {
//         case "invalid-email":
//           errorMessage = "Your email address appears to be malformed.";
//           break;
//         case "wrong-password":
//           errorMessage = "Your password is wrong.";
//           break;
//         case "user-not-found":
//           errorMessage = "User with this email doesn't exist.";
//           break;
//         case "user-disabled":
//           errorMessage = "User with this email has been disabled.";
//           break;
//         case "too-many-requests":
//           errorMessage = "Too many requests";
//           break;
//         case "operation-not-allowed":
//           errorMessage =
//           "Signing in with Email and Password is not enabled.";
//           break;
//         default:
//           errorMessage = "Fill in this field correctly.";
//       }
//       setState(() {
//         showSpinner = false;
//       });
//       Fluttertoast.showToast(msg: errorMessage!);
//       print(error.code);
//     }
//   }
//
//   Future<void> findlocation() async {
//     Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//
//   }
// }
//
// //}