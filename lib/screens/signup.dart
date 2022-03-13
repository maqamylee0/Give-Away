import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddrop2/main.dart';
import 'package:fooddrop2/models/user.dart';
import 'package:fooddrop2/screens/home.dart';
import 'package:fooddrop2/screens/login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../constants.dart';
// import 'package:google_fonts/google_fonts.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}


class _SignupState extends State<Signup> {
  bool showSpinner = false;
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _validate = false;
  static late Position currentPosition;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: fBackgroundColor,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: const Text(
                        'Make It Work',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  Container(
                    padding: EdgeInsets.all(0),
                    child: Image.asset('assets/logo.png') ,
                    height: 60,
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(0),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      )),
                  SizedBox(height: 40),
                  Container(
                    height: 65,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
                      style: TextStyle(color: Colors.red),
                      validator: (value) {
                         RegExp regex = new RegExp(r'^.{3,}$');
                        if (value!.isEmpty) {
                          return ("Name cannot be Empty");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid name(Min. 3 Character)");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        nameController.text = value!;
                        //Do something with the user input.
                      },
                      controller: nameController,
                      decoration:  InputDecoration(
                        fillColor: Colors.white, filled: true,
                        //errorText: _validate ? 'Name Can\'t Be Empty' : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13.0)),
                        ),
                        labelText: 'Enter your Name',
                        prefixIcon: Icon(Icons.account_circle),

                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 65,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),                    child: TextFormField(
                      style: TextStyle(color: Colors.red),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter Your Email");
                        }
                        // reg expression for email validation
                        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                            .hasMatch(value)) {
                          return ("Please Enter a valid email");
                        }
                        return null;
                      },

                      onSaved: (value) {
                        emailController.text = value!;
                        //Do something with the user input.
                      },
                      controller: emailController,
                      decoration:  InputDecoration(
                        fillColor: Colors.white, filled: true,
                       // errorText: _validate ? 'Email Can\'t Be Empty' : null,
                        border: OutlineInputBorder(

                          borderRadius: BorderRadius.all(Radius.circular(13.0)),
                        ),
                        labelText: 'Enter email address',
                        prefixIcon: Icon(Icons.mail),

                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 65,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) {
                         RegExp regex = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Password is required for login");
                        }else if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }else
                        return null;
                      },
                      onSaved: (value) {
                        passwordController.text = value!;
                        //Do something with the user input.
                      },
                      controller: passwordController,
                      decoration:  InputDecoration(
                        fillColor: Colors.white, filled: true,
                        errorText: _validate ? 'Password Can\'t Be Empty' : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13.0)),
                        ),
                        labelText: 'Enter Password',
                        prefixIcon: Icon(Icons.vpn_key),

                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 65,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (!(confirmpasswordController.text ==
                            passwordController.text)) {
                          return "Password don't match";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        confirmpasswordController.text = value!;
                        //Do something with the user input.
                      },
                      controller: confirmpasswordController,
                      decoration:  InputDecoration(
                        fillColor: Colors.white, filled: true,
                        errorText: _validate ? 'Password Can\'t Be Empty' : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13.0)),
                        ),
                        labelText: 'Enter Password',
                        prefixIcon: Icon(Icons.vpn_key),

                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 65,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: TextFormField(
                      keyboardType: TextInputType.number,

                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');                    // RegExp regex = new RegExp(r'^.{6,}$');

                        if (value!.isEmpty) {
                          return ("Password is required for login");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        phoneController.text = value!;
                        //Do something with the user input.
                      },
                      controller: phoneController,
                      decoration:  InputDecoration(
                        fillColor: Colors.white, filled: true,
                        errorText: _validate ? 'Phone Can\'t Be Empty' : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(13.0)),
                        ),
                        labelText: 'Enter your phone number',
                        prefixIcon: Icon(Icons.local_phone),

                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                          child: const Text('SIGN UP'),
                          onPressed:

                              () async {

                            setState(() {
                              nameController.text.isEmpty ? _validate = true : _validate = false;
                              passwordController.text.isEmpty ? _validate = true : _validate = false;
                              emailController.text.isEmpty ? _validate = true : _validate = false;

                              phoneController.text.isEmpty ? _validate = true : _validate = false;

                            });
                            currentPosition = await _determinePosition();

                            await signUp(emailController.text, passwordController.text);
                            setState(() {
                              showSpinner = false;
                            });

                         }
                          )),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      const Text('Does not have account?',style: TextStyle(fontSize: 15, color: Colors.green),),
                      ElevatedButton(
                        child: const Text(
                          'Sign in',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          //signup screen
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              )),
        ));
  }

postDetailsToFirestore() async {


  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  User? user = _auth.currentUser;

  UserModel userModel = UserModel();

  // writing all the values
  userModel.email = user!.email;
  userModel.uid = user.uid;
  userModel.name = nameController.text;
  userModel.phone = phoneController.text;


  await firebaseFirestore
      .collection("users")
      .doc(user.uid)
      .set(userModel.toMap());
  setState(() {
    showSpinner = false;
  });
  Fluttertoast.showToast(msg: "Account created successfully :) ");
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => Map(position:LatLng(currentPosition.latitude,currentPosition.latitude))));

}

  signUp(String email, String password) async {
    // if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        setState(() {
          showSpinner = false;
        });
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        setState(() {
          showSpinner = false;
        });
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
//}

Future<Position> _determinePosition() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the
    // App to enable the location services.
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.
      return Future.error('Location permissions are denied');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever, handle appropriately.
    return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);
}