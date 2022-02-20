import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddrop2/main.dart';
import 'package:fooddrop2/models/user.dart';
import 'package:fooddrop2/screens/home.dart';
import 'package:fooddrop2/screens/login.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
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

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
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
                        'FoodDrop',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      )),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(

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
                        errorText: _validate ? 'Name Can\'t Be Empty' : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        labelText: 'Enter your Name',
                        prefixIcon: Icon(Icons.account_circle),

                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(

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
                        errorText: _validate ? 'Email Can\'t Be Empty' : null,
                        border: OutlineInputBorder(

                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        labelText: 'Enter email address',
                        prefixIcon: Icon(Icons.mail),

                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) {
                         RegExp regex = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Password is required for login");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }
                        return null;
                      },
                      onSaved: (value) {
                        passwordController.text = value!;
                        //Do something with the user input.
                      },
                      controller: passwordController,
                      decoration:  InputDecoration(
                        errorText: _validate ? 'Password Can\'t Be Empty' : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        labelText: 'Enter Password',
                        prefixIcon: Icon(Icons.vpn_key),

                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (confirmpasswordController.text !=
                            passwordController.text) {
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
                        errorText: _validate ? 'Password Can\'t Be Empty' : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        labelText: 'Enter Password',
                        prefixIcon: Icon(Icons.vpn_key),

                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');                    // RegExp regex = new RegExp(r'^.{6,}$');

                        if (value!.isEmpty) {
                          return ("Password is required for login");
                        }
                        // if (!regex.hasMatch(value)) {
                        //   return ("Enter Valid Password(Min. 6 Character)");
                        // }
                        return null;
                      },
                      onSaved: (value) {
                        phoneController.text = value!;
                        //Do something with the user input.
                      },
                      controller: phoneController,
                      decoration:  InputDecoration(
                        errorText: _validate ? 'Phone Can\'t Be Empty' : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        labelText: 'Enter your phone number',
                        prefixIcon: Icon(Icons.local_phone),

                      ),
                    ),
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                          child: const Text('SIGN UP'),
                          onPressed: () async {
                            setState(() {
                              nameController.text.isEmpty ? _validate = true : _validate = false;
                              passwordController.text.isEmpty ? _validate = true : _validate = false;
                              emailController.text.isEmpty ? _validate = true : _validate = false;

                              phoneController.text.isEmpty ? _validate = true : _validate = false;

                              showSpinner = true;
                            });

                            signUp(emailController.text, passwordController.text);
                            setState(() {
                              showSpinner = false;
                            });

                         }
                          )),
                  Row(
                    children: <Widget>[
                      const Text('Does not have account?'),
                      TextButton(
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
  Navigator.pushAndRemoveUntil((context),

      MaterialPageRoute(builder: (context) => Map()),
          (route) => false);

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