import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddrop2/constants.dart';
import 'package:fooddrop2/main.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:fooddrop2/screens/forgotPassword.dart';
import 'package:fooddrop2/screens/home.dart';
import 'package:fooddrop2/screens/login.dart';
import 'package:fooddrop2/screens/signup.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:fooddrop2/screens/home.dart';
import 'package:uuid/uuid.dart';

class MarkerPage extends StatefulWidget {
  final List? datas;
  const MarkerPage({Key? key, List? this.datas}) : super(key: key);

  @override
  _MarkerPageState createState() => _MarkerPageState();
}

class _MarkerPageState extends State<MarkerPage> {
  String? errorMessage;

  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  TextEditingController numbersController = TextEditingController();

  TextEditingController labelController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController infoController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController longController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController locController = TextEditingController();
  String dropdownValue='aids';
  // List<Map> stats = <Map>[];



  List <String> spinnerItems = [
    'adults',
    'aids',
    'blind',
    'children',
    'deaf',
    'dumb',
    'orphans',
    'others',
    'teenagers'
  ] ;
  HomeModel homeModel = HomeModel();
  @override
  void initState(){
    String uid = Uuid().v1();
    homeModel.uid = uid;
    homeModel.title = titleController.text;
    homeModel.info = infoController.text;
    homeModel.phone = phoneController.text;
    homeModel.followers = 0;
    homeModel.location = locController.text;
    homeModel.lat = LoginState.currentPosition.latitude;
    homeModel.long = LoginState.currentPosition.longitude;
    homeModel.stats?["aids"]=2;
    print("homel is ${homeModel.stats!["aids"]} ");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),

            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 6,
                      backgroundColor: Colors.transparent,
                      child: _DialogWithTextField(context),
                    );
                  });
            }),
        appBar: AppBar(
          title: const Text('New Home'),
          backgroundColor: Colors.green[500],
        ),
        backgroundColor: fBackgroundColor,
        body: ModalProgressHUD(
          inAsyncCall: showSpinner,
          child: Padding(
              padding: const EdgeInsets.all(10),

              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.topLeft,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Image.asset('assets/home.png'),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                              height: 30,
                              width: 100,
                              child: ElevatedButton(
                                child: const Text('Submit'),
                                onPressed: () async {
                                  this.addMarkerToFireStore();
                                  setState(() {
                                    showSpinner = true;
                                  });
                                },
                              )),
                        ],
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
                        labelText: ' Enter Institution Number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return ("Please Enter location/city");
                        }

                        return null;
                      },
                      onSaved: (value) {
                        locController.text = value!;
                        //Do something with the user input.
                      },
                      controller: locController,
                      decoration: InputDecoration(
                        errorText: errorMessage,
                        labelText: ' Enter location',
                        prefixIcon: Icon(Icons.map),
                      ),
                    ),
                  ),
                  Container(
                      child:Container(
                          child: homeModel.stats!.isNotEmpty?

                          ListView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(4.5),
                            itemCount: homeModel.stats?.length,
                            itemBuilder: _itemBuilder,
                          ):
                          Container(
                              child: const Center(
                                child:Text(
                                  'No additional data found',
                                  style: TextStyle(fontSize: 24),
                                ),
                              )

                          )


                      )
                  )
                 ],
              )),
        ));
  }

  addMarkerToFireStore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore
        .collection("homes")
        .doc(homeModel.uid)
        .set(homeModel.toMap())
        .catchError((e) => "failed")
        .then((uid) => {});
    setState(() {
      showSpinner = false;
    });
    Fluttertoast.showToast(msg: "Home Added Successfully :) ");
    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(
            builder: (context) => Map(
                position: LatLng(LoginState.currentPosition.latitude,
                    LoginState.currentPosition.longitude))),
        (route) => false);
  }

  Widget _DialogWithTextField(BuildContext context) =>
      Container(
        height: 340,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 24),
            Text(
              "Add Fields".toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            SizedBox(height: 10),
            Padding(
                padding: EdgeInsets.only(
                    top: 10, bottom: 10, right: 15, left: 15),
              child:Column(children: <Widget>[

                DropdownButton<String>(

                  onChanged: (String? newValue) {
                    setState(() {
                      dropdownValue = newValue!;
                    });
                  },
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.red, fontSize: 18),

                  items: spinnerItems.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),

              ]),
            ),
            Container(
              width: 150.0,
              height: 1.0,
              color: Colors.grey[400],
            ),
            Padding(
                padding: EdgeInsets.only(top: 10, right: 15, left: 15),
                child: TextFormField(
                  maxLines: 1,
                  autofocus: false,
                  keyboardType: TextInputType.number,
                  controller: numbersController,
                  decoration: InputDecoration(
                    labelText: 'number',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                )
            ),
            SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                RaisedButton(
                  color: Colors.white,
                  child: Text(
                    "SUBMIT".toUpperCase(),
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  onPressed:()=> submit(dropdownValue,numbersController.text),
                )
              ],
            ),
          ],
        ),

      );
  void submit(dropdownvalue,amount) async{
    Navigator.of(context).pop();
    setState(() {
      homeModel.stats!['$dropdownvalue']=int.parse(amount);
print("value is ${int.parse(amount) } and $dropdownvalue");
    });

  }
  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
        height: 150,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: EdgeInsets.all(5),
        child: Column(

          children: [
            ListTile(
              title: Text("${homeModel.stats?[index]}"),
              subtitle: Text("${homeModel.stats?.values.toList()[index]}"),
              trailing: Icon(Icons.change_circle),
            ),


              ],
            ),

  );

  }
}
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
