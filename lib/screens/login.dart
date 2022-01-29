import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddrop2/main.dart';
import 'package:fooddrop2/screens/signup.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? errorMessage;
  final _formKey = GlobalKey<FormState>();

  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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
                        'Sign In',
                        style: TextStyle(fontSize: 20, color: Colors.green),
                      )),
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
                      // controller: emailController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),

                        ),
                        labelText: ' Enter your email address',

                        prefixIcon: Icon(Icons.mail),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      validator: (value) {
                        RegExp regex = new RegExp(r'^.{6,}$');
                        if (value!.isEmpty) {
                          return ("Password is required for login");
                        }
                        if (!regex.hasMatch(value)) {
                          return ("Enter Valid Password(Min. 6 Character)");
                        }
                      },
                      onSaved: (value) {
                        passwordController.text = value!;
                        //Do something with the user input.
                      },
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32.0)),

                        ),
                        prefixIcon: Icon(Icons.vpn_key),

                        labelText: 'Enter your Password',
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //forgot password screen
                    },
                    child: const Text('Forgot Password',),
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        child: const Text('Login'),
                        onPressed: () async {
                          setState(() {
                            showSpinner = true;
                          });
                          signIn(emailController.text, passwordController.text);


                        },
                      )
                  ),
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
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => Signup()));
                        },
                      )
                    ],
                    mainAxisAlignment: MainAxisAlignment.center,
                  ),
                ],
              )),
        ));
  }

    void signIn(String email, String password) async {
      if (_formKey.currentState!.validate()) {
        try {
          await _auth
              .signInWithEmailAndPassword(email: email, password: password)
              .then((uid) =>
          {
            Fluttertoast.showToast(msg: "Login Successful"),
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyHomePage(title: "fooddropped"))),
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
              errorMessage =
              "Signing in with Email and Password is not enabled.";
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

}