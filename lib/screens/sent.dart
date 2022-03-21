import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fooddrop2/constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:fooddrop2/screens/homedetail.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';

class Sent extends StatefulWidget {

  const Sent({Key? key}) : super(key: key);

  @override
  _SentState createState() => _SentState();
}

class _SentState extends State<Sent> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('Donations');
  List? results = [];
  String hintText = 'enter location';
  CollectionReference _collectionRef =
  FirebaseFirestore.instance.collection('donations');
  bool showSpinner = false;

  String getName(int index) {
    return results![index]["item"];
  }

  String getInfo(int index) {
    return results![index]["tophone"];
  }

  String getPhone(int index) {
    return results![index]["status"].toString();
  }



  int? getLength() {
    return results?.length;
  }


  @override
  initState() {

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
    return results;
  }

  //   void _runFilter(String enteredKeyword) {
  //   if (enteredKeyword.isEmpty) {
  //     // if the search field is empty or only contains white-space, we'll display all users
  //     results = widget.datas;
  //   } else {
  //     results = widget.datas!
  //         .where((home) =>
  //         home["loc"].toLowerCase().contains(enteredKeyword.toLowerCase()))
  //         .toList();
  //
  //     print("results are $results");
  //     // we use the toLowerCase() method to make it case-insensitive
  //   }
  //
  //   // Refresh the UI
  //   setState(() {
  //     _foundDonations = results;
  //     print(" results are $results");
  //   });
  // }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(

          appBar:
          AppBar(title: customSearchBar,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: customIcon,
                onPressed: () {
                  setState(() {
                    if (customIcon.icon == Icons.search) {
                      // Perform set of instructions.

                    } else {
                      customIcon = const Icon(Icons.search);
                      customSearchBar = const Text('Homes');

                    }
                    if (customIcon.icon == Icons.search) {
                      customIcon = const Icon(Icons.cancel);
                      customSearchBar =  ListTile(
                        leading: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),

                        title: TextField(
                          // focusNode: focusNode,

                          // onChanged:(value) => _runFilter(value),
                          decoration: InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            hintText: hintText,
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }

                  });

                },
              ),
            ],),
          backgroundColor: fBackgroundColor,
          body:ModalProgressHUD(
          inAsyncCall: showSpinner,

          child:Container(
              child: results!.isNotEmpty?

              ListView.builder(
                padding: const EdgeInsets.all(4.5),
                itemCount: results?.length,
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
        height: 150,
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: EdgeInsets.all(3),
        child: Column(

          children: [
            ListTile(
              title: Text(getName(index)),
              subtitle: Text(getPhone(index)),
              trailing: Icon(Icons.favorite_outline),
            ),

            Container(
              padding: EdgeInsets.all(3.0),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text(getName(index)),
            ),

          ],
        ));
  }

}
