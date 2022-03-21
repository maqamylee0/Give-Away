import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddrop2/constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddrop2/models/donation.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:fooddrop2/screens/sent.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

class HomeDetail extends StatefulWidget {
  final HomeModel? datas;

  const HomeDetail({Key? key, @required this.datas}) : super(key: key);
  @override
  _HomeDetailState createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  // List stats = [{"children":23,"teenagers":34,"adults":43},{"children":23,"teenagers":34,"adults":43}];
  //   Map<String, int>? stat;
  DatabaseReference ref = FirebaseDatabase.instance.ref();

  get dats => widget.datas!.toMap();

  get stats => dats.uid;

  get keys => dats["stats"].keys.toList();

  get values => dats["stats"].values.toList();
  late TextEditingController phoneController;
  late TextEditingController itemController;
  bool showSpinner = false;

  @override
  void initState() {
    // TODO: implement initState
    phoneController = TextEditingController();
    itemController = TextEditingController();
    super.initState();
    getInfo();
  }

  @override
  void dispose() {
    phoneController.dispose();
    itemController.dispose();
    super.dispose();
  }

  String? getId() {
    return widget.datas!.uid;
  }

  get children => dats["stats"][children];

  String? getName() {
    return widget.datas!.title;
  }

  String? getInfo() {
    print("dats is ${keys}");

    return widget.datas!.info;
  }

  String? getPhone() {
    return widget.datas!.phone;
  }

  String getAdults(int index) {
    return dats!["stats"]["children"];
  }


  void submit() async{
    Navigator.of(context).pop();
    setState(() {
      showSpinner = true;
    });
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    DonationModel donationModel=new DonationModel();
    final String uid=Uuid().v1().toString();

    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    donationModel.uid=uid;
     donationModel.from=phoneController.text;
     donationModel.tophone=widget.datas?.phone.toString();
     donationModel.touid=widget.datas?.uid;
     donationModel.item=itemController.text;
     donationModel.status=false;
     donationModel.date=formattedDate;
    print(donationModel.toMap());

    await firebaseFirestore
        .collection("donations")
    .doc(uid)
        .set(donationModel.toMap())
        .catchError((e) => "failed")
        .then((uid) => {});
    setState(() {
      showSpinner = false;
    });
print(donationModel.toMap());
    DatabaseReference ref = FirebaseDatabase.instance.ref(uid);
    await ref.set({
      "uid": uid,
      "from": phoneController.text,
      "tophone": widget.datas?.phone,
      "touid":widget.datas?.uid,
      "item":itemController.text,
      'date':formattedDate,

    });

    Fluttertoast.showToast(msg: "Message sent Successfully :) ");
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Sent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(

        child: Text("Donate"),

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
          title: Text("${widget.datas!.title}",
              style: TextStyle(color: Colors.white))),
      body:  ModalProgressHUD(
    inAsyncCall: showSpinner,
      child:Wrap(
          children: [
        Container(
          child:Center(
            child:Container(
              height: 150,
              decoration: BoxDecoration(
                  color: fBackgroundColor,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Image.asset("assets/home.png"),
            )

          )

        ),
        Container(
          height: 130,

          // child: new SingleChildScrollView(
          child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(4.5),
              itemCount: dats["stats"].length,
              itemBuilder: (BuildContext ctx, index) {
                return Container(
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.all(Radius.circular(30))),
                        padding: EdgeInsets.all(20),
                        child: Text(
                          '${keys[index]}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10))),
                        padding: EdgeInsets.all(20),
                        child: Text(
                          '${values[index]} ',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ]));
              }),
        ),
        Container(
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.all(5),
                    height: 60,
                    child: Text(
                      '${dats["title"]}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        fontSize: 10,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                    height: 60,
                    margin: EdgeInsets.all(5),
                    child: Text(
                      'Description : ${dats["info"]}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        fontSize: 10,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    height: 60,
                    child: Text(
                      ' Location: ${dats["loc"]}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        fontSize: 10,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    height: 60,
                    child: Text(
                      'Phone: ${dats["phone"]}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        fontSize: 10,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: EdgeInsets.all(10),
                  ),
                  Container(
                    margin: EdgeInsets.all(5),
                    height: 60,
                    child: Text(
                      'Followers: ${dats["followers"]}',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.5,
                        fontSize: 10,
                      ),
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    padding: EdgeInsets.all(10),
                  )
                ],
              ),
            ))
      ])),
    );
  }

  // Widget _itemBuilder(BuildContext context, int index) {
  //   return


  Widget _DialogWithTextField(BuildContext context) =>
      Container(
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 24),
            Text(
              "DONATE".toUpperCase(),
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
                child: TextFormField(
                  maxLines: 1,
                  autofocus: false,
                  controller: itemController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Item to donate',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                )
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
                  keyboardType: TextInputType.text,
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: 'phone number',
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
                    "DONATE".toUpperCase(),
                    style: TextStyle(
                      color: Colors.green,
                    ),
                  ),
                  onPressed: submit,
                )
              ],
            ),
          ],
        ),

      );


}