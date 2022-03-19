import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddrop2/screens/login.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgot-password';
  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  String? _email;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Form(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enter Your Email',
                    style: TextStyle(fontSize: 30, color: Colors.green),
                  ),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      onSaved: (newEmail) {
                        _email = newEmail!;
                      },
                      style: TextStyle(color: Colors.green),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),
                        ),
                        labelText: 'Email',
                        icon: Icon(
                          Icons.mail,
                          color: Colors.green,
                        ),
                        errorStyle: TextStyle(color: Colors.green),
                        labelStyle: TextStyle(color: Colors.green),
                        hintStyle: TextStyle(color: Colors.green),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    color: Colors.green,
                    child: Text('Send Email'),
                    onPressed: () {
                      _passwordReset(_email);
                      print(_email);
                    },
                  ),
                  FlatButton(
                    child: Text('Sign In'),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Login()));
                    },
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _passwordReset(String? email) async {
    setState(() {
      showSpinner = true;
    });
    final _auth = FirebaseAuth.instance;
    try {
      _formKey.currentState?.save();

      await _auth.sendPasswordResetEmail(email: email!);
      setState(() {
        showSpinner = false;
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ConfirmEmail();
        }),
      );
    } catch (e) {
      print(e);
    }
  }
}

String id = 'confirm-email';

class ConfirmEmail extends StatelessWidget {
  const ConfirmEmail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'An Email has been sent to you ,Click it to reset password',
                style: TextStyle(fontSize: 30, color: Colors.green),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // return Container(
  //
  //   padding: const EdgeInsets.all(10),
  //
  //   child: Center(
  //
  //       child: Text(
  //         'An email has just been sent to you, Click the link provided to complete registration',
  //         style: TextStyle(color: Colors.white, fontSize: 16),
  //       )),
  // );
}
