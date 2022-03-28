import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddrop2/constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:fooddrop2/screens/homedetail.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart' as globals;

class Sent extends StatefulWidget {
  const Sent({Key? key}) : super(key: key);

  @override
  _SentState createState() => _SentState();
}

class _SentState extends State<Sent> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Donations');
  List? results = [];
  List? _foundDonations = [];
  late final user;
  String hintText = 'enter location';
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('donations');
  bool showSpinner = false;
  late final Box box1;
  late final useruid;
  late final homeuid;
  late final touid;
  String getName(int index) {
    return _foundDonations![index]["item"];
  }

  String getTo(int index) {
    return _foundDonations![index]["to"].toString();
  }

  String getInfo(int index) {
    return _foundDonations![index]["tophone"];
  }

  String getTime(int index) {
    return _foundDonations![index]["date"];
  }

  String getUid(int index) {
    return _foundDonations![index]["uid"];
  }

  bool getStatus(int index) {
    return _foundDonations![index]["status"];
  }

  String getPhone(int index) {
    return _foundDonations![index]["tophone"];
  }

  String getstatus(int index) {
    bool delivered = _foundDonations![index]["status"];
    if (delivered == true) {
      return "Yes";
    } else {
      return "No";
    }
  }

  int? getLength() {
    return _foundDonations?.length;
  }

  getId() async {
    box1 = await Hive.openBox('personaldata');
    useruid = box1.get('userid');
    // useruid=globals.userid;
    //homeuid=globals.homeuid;
    // touid=globals.
    // final prefs = await SharedPreferences.getInstance();
    // useruid = prefs.getString('useruid');
    // homeuid = prefs.getString('homeuid');
    // touid = prefs.getString('homeuid') ?? 0;
  }

  @override
  void initState() {
    getId();
    _LoadDonations();
    if (results != null) {
      showSpinner = false;
    } else {
      showSpinner = true;
    }
    // at the beginning, all users are shown
    super.initState();
  }

  Future<List?> _LoadDonations() async {
    setState(() {
      if (results!.isEmpty) {
        showSpinner = true;
      }
    });

    QuerySnapshot querySnapshot = await _collectionRef.get();

    results = querySnapshot.docs.map((doc) => doc.data()).toList();
    if (results!.isNotEmpty) {
      setState(() {
        showSpinner = false;
      });
    }
    //print("usersssssss $useruid and ${results!.where((element) => element['from'])}");

    _runFilter();
    return results;
  }

  Future<void> _runFilter() async {
    showSpinner = false;

    _foundDonations =
        results!.where((user) => user["from"].contains(useruid)).toList();

    print("results are $results");
    print("results are $_foundDonations");

    // we use the toLowerCase() method to make it case-insensitive
  }
  // Refresh the UI

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(
          appBar: AppBar(
            title: customSearchBar,
          ),
          backgroundColor: fBackgroundColor,
          body: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Container(
                  child: _foundDonations!.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(4.5),
                          itemCount: _foundDonations?.length,
                          itemBuilder: _itemBuilder,
                        )
                      : Container(
                          child: const Center(
                          child: Text(
                            'No Donations Sent',
                            style: TextStyle(fontSize: 24),
                          ),
                        ))))),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
        height: 150,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: EdgeInsets.fromLTRB(8, 3, 1, 3),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  child: Text("Date: ${getTime(index)} "),
                ),
                SizedBox(),

                Container(
                  child: Text("Item: ${getName(index)} "),
                ),
                SizedBox(),

                IconButton(
                  icon: const Icon(Icons.delete),
                  color: fButtonColor,
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 6,
                            backgroundColor: Colors.transparent,
                            child: _DialogWithTextField(context, index),
                          );
                        });
                  },
                )
              ],
            ),
            Container(
              child: Text("To: ${getTo(index)} "),
            ),
            // Container(
            //   child: Text(": ${getstatus(index)} "),
            // ),
            // ListTile(
            //   leading: Text("Date: ${getTime(index)} \n  To: ${getTo(index)} \nDelivered :${getPhone(index)}",style: GoogleFonts.lato(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold )),
            //   title: Text("Item :${getName(index)}" ,style: TextStyle(fontSize: 15)),
            //   // subtitle: Text("",style: TextStyle(fontSize: 14)),
            // trailing:
            //  ),
            Container(
              child: getStatus(index) == true
                  ? Container(
                      child: Text('Seen and Scheduled for pick up soon',style: TextStyle(
                        color: Colors.red,
                      ),))
                  : TextButton(
                      child: const Text('CONTACT AGENT'),
                      onPressed: () {
                        launch('tel:${getPhone(index)}');
                      },
                    ),
            ),
          ],
        ));
  }

  Widget _DialogWithTextField(BuildContext context, index) => Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              "Are sure you want to delete Donation?".toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
            SizedBox(height: 5),
            Container(
              width: 100.0,
              height: 1.0,
              color: Colors.grey[400],
            ),
            SizedBox(height: 5),
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
                    "Delete".toUpperCase(),
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  onPressed: () => submit(index),
                )
              ],
            ),
          ],
        ),
      );

  void submit(index) async {
    print("id issssssssssssssss ${getUid(index)}");
    await _collectionRef.doc(getUid(index)).delete();
    Fluttertoast.showToast(msg: "Donation Deleted Successfully");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Sent(),
      ),
      (route) => true,
    );
  }
}
