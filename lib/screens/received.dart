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
import 'package:hive/hive.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'globals.dart' as globals;


class Received extends StatefulWidget {

  const Received({Key? key}) : super(key: key);

  @override
  ReceivedState createState() => ReceivedState();
}



class ReceivedState extends State<Received> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Donations');
  List? results = [];
  String hintText = 'enter location';
  CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('donations');
  bool showSpinner = false;
  List? _foundDonations=[];
  late final Box box1;

  late final touid;
  String getName(int index) {
    return results![index]["item"];
  }

  String getInfo(int index) {
    return results![index]["tophone"];
  }
  String getTime(int index) {
    return results![index]["date"];
  }

  String getUid(int index) {
    return results![index]["uid"];
  }

  String getPhone(int index) {
    bool delivered = results![index]["status"];
    if (delivered == true) {
      return "Yes";
    } else {
      return "Not Yet";
    }
  }


  int? getLength() {
    return results?.length;
  }

getId()  async {
  // final prefs = await SharedPreferences.getInstance();
  // touid = prefs.getString('homeuid') ?? 0;
 // touid=globals.homeuid;
  box1 = await Hive.openBox('personaldata');
  touid=box1.get('homeuid');
}
  @override
  void initState() {
getId();
    _LoadDonations();
    if(results != null ){
      showSpinner=false;
    }else{
      showSpinner=true;
    }
    // at the beginning, all users are shown
    super.initState();
  }
  Future<List?> _LoadDonations() async {
    setState(() {
      if (results!.isEmpty){
        showSpinner=true;
      }
    });

    QuerySnapshot querySnapshot = await _collectionRef.get();

    results = querySnapshot.docs.map((doc) => doc.data()).toList();
    if(results!.isNotEmpty){
      setState(() {
        showSpinner=false;
      });
    }
    _runFilter();
    return results;
  }

    Future<void> _runFilter() async {
      _foundDonations = results!
          .where((home) =>
          home["touid"].contains(touid))
          .toList();

      print("results are $results");
      print("results are $_foundDonations");

      // we use the toLowerCase() method to make it case-insensitive


    // Refresh the UI
    // setState(() {
    //   _foundDonations = results;
    //   print(" results are $results");
    // });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(

        appBar:
        AppBar(title: customSearchBar,
          // actions: [
          //   IconButton(
          //     icon: customIcon,
          //     onPressed: () {
          //       setState(() {
          //         if (customIcon.icon == Icons.search) {
          //           // Perform set of instructions.
          //
          //         } else {
          //           customIcon = const Icon(Icons.search);
          //           customSearchBar = const Text('Homes');
          //
          //         }
          //         if (customIcon.icon == Icons.search) {
          //           customIcon = const Icon(Icons.cancel);
          //           customSearchBar =  ListTile(
          //             leading: Icon(
          //               Icons.search,
          //               color: Colors.white,
          //               size: 28,
          //             ),
          //
          //             title: TextField(
          //               // focusNode: focusNode,
          //
          //               // onChanged:(value) => _runFilter(value),
          //               decoration: InputDecoration(
          //                 floatingLabelBehavior: FloatingLabelBehavior.never,
          //                 hintText: hintText,
          //                 hintStyle: TextStyle(
          //                   color: Colors.white,
          //                   fontSize: 18,
          //                   fontStyle: FontStyle.italic,
          //                 ),
          //                 border: InputBorder.none,
          //               ),
          //               style: TextStyle(
          //                 color: Colors.white,
          //               ),
          //             ),
          //           );
          //         }
          //
          //       });
          //
          //     },
          //   ),
          // ]
    ),
        backgroundColor: fBackgroundColor,
        body:ModalProgressHUD(
            inAsyncCall: showSpinner,

            child:Container(
                child: _foundDonations!.isNotEmpty?

                ListView.builder(
                  padding: const EdgeInsets.all(4.5),
                  itemCount: _foundDonations?.length,
                  itemBuilder: _itemBuilder,
                ):
                Container(
                    child: const Center(
                      child:Text(
                        'No results found',
                        style: TextStyle(fontSize: 24),
                      ),
                    )

                )


            )),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
        height: 130,
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: EdgeInsets.all(3),
        child: Column(

          children: [
            ListTile(
              leading: Text("Date: ${getTime(index)},",style: (TextStyle(color: Colors.green)),),
              title: Text("Item : ${getName(index)}" ,style: TextStyle(fontSize: 17)),
              subtitle: Text("Delivered : ${getPhone(index)}",style: TextStyle(fontSize: 14)),
              trailing: IconButton(icon:const Icon(Icons.delete),color: Colors.green, onPressed: () async{
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                        elevation: 6,
                        backgroundColor: Colors.transparent,
                        child: _DialogWithTextField(context,index),
                      );
                    });

              },),
            ),

          ],
        ));

  }
  Widget _DialogWithTextField(BuildContext context,index) =>
      Container(
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
                  onPressed: ()=>submit(index),
                )
              ],
            ),
          ],
        ),

      );

  void submit(index) async{
    print("id issssssssssssssss ${getUid(index)}");
    await _collectionRef.doc(getUid(index)).delete();
    Fluttertoast.showToast(msg: "Donation Deleted Successfully");
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => Received(),
      ),
          (route) => true,
    );

  }
}


//

// class _DialogWithTextField(BuildContext context) =>
//   Container(
//   height: 280,
//   decoration: BoxDecoration(
//   color: Colors.white,
//   shape: BoxShape.rectangle,
//   borderRadius: BorderRadius.all(Radius.circular(12)),
//   ),
//   child: Column(
//   children: <Widget>[
//   SizedBox(height: 24),
//   Text(
//   "DONATE".toUpperCase(),
//   textAlign: TextAlign.center,
//   style: TextStyle(
//   color: Colors.black,
//   fontWeight: FontWeight.bold,
//   fontSize: 17,
//   ),
//   ),
//   SizedBox(height: 10),
//   Padding(
//   padding: EdgeInsets.only(
//   top: 10, bottom: 10, right: 15, left: 15),
//   child: TextFormField(
//   maxLines: 1,
//   autofocus: false,
//   controller: itemController,
//   keyboardType: TextInputType.text,
//   decoration: InputDecoration(
//   labelText: 'Item to donate',
//   border: OutlineInputBorder(
//   borderRadius: BorderRadius.circular(20.0),
//   ),
//   ),
//   )
//   ),
//   Container(
//   width: 150.0,
//   height: 1.0,
//   color: Colors.grey[400],
//   ),
//   Padding(
//   padding: EdgeInsets.only(top: 10, right: 15, left: 15),
//   child: TextFormField(
//   maxLines: 1,
//   autofocus: false,
//   keyboardType: TextInputType.text,
//   controller: phoneController,
//   decoration: InputDecoration(
//   labelText: 'phone number',
//   border: OutlineInputBorder(
//   borderRadius: BorderRadius.circular(20.0),
//   ),
//   ),
//   )
//   ),
//   SizedBox(height: 10),
//   Row(
//   mainAxisSize: MainAxisSize.min,
//   children: <Widget>[
//   FlatButton(
//   onPressed: () {
//   Navigator.of(context).pop();
//   },
//   child: Text(
//   "Cancel",
//   style: TextStyle(
//   color: Colors.black,
//   ),
//   ),
//   ),
//   SizedBox(width: 8),
//   RaisedButton(
//   color: Colors.white,
//   child: Text(
//   "DONATE".toUpperCase(),
//   style: TextStyle(
//   color: Colors.green,
//   ),
//   ),
//   onPressed: submit,
//   )
//   ],
//   ),
//   ],
//   ),
//
//   );
// }
