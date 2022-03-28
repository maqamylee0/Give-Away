import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fooddrop2/constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddrop2/models/donation.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:fooddrop2/screens/received.dart';
import 'package:fooddrop2/screens/sent.dart';
import 'package:fooddrop2/screens/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import 'globals.dart' as globals;

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
   String? useruid;
 late final Box box1;
  @override
  void initState()  {
    // TODO: implement initState
    getIds();


    phoneController = TextEditingController();
    itemController = TextEditingController();
    super.initState();
    getInfo();
  }
getIds()  async {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  // setState(() {
  //   useruid =  prefs.getString('userid') ?? 0;
  //
  // });
   box1 = await Hive.openBox('personaldata');
   setState(() {
     useruid=box1.get('userid');

   });

   print('userrrrrrrrrr ${widget.datas!.userid} and $useruid ');

  // useruid=globals.userid;
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

  get children => dats["stats"]['children'];

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
     donationModel.fromphone=phoneController.text;
    donationModel.from=useruid;
    donationModel.to=widget.datas!.title;
    donationModel.tophone=widget.datas?.phone.toString();
     donationModel.touid=getId();
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
    // DatabaseReference ref = FirebaseDatabase.instance.ref(uid);
    // await ref.set({
    //   "uid": uid,
    //   "fromphone": phoneController.text,
    //   "from": useruid,
    //   "tophone": widget.datas?.phone,
    //   "touid":widget.datas?.uid,
    //   "item":itemController.text,
    //   'date':formattedDate,
    //
    // });

    Fluttertoast.showToast(msg: "Message sent Successfully :) ");
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Sent()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


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
              child: getwidget(),
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
                        color: fButtonColor,
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
          alignment: Alignment.center,
            margin: EdgeInsets.all(20),
            padding:  EdgeInsets.all(20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Center(
              child: Column(
                children: [
                  Container(

                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                          children:[
                            ElevatedButton(


                              child: const Text('Make Donation'),
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
                                        child: _DialogWithTextField(context),
                                      );
                                    });

                              },
                            )]
                      )//:
                        //Container()

                  ),
                  Container(
                    child: Text(
                      '${dats["title"]}',
                       style:GoogleFonts.lato(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 18),

                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  Container(
                    child: Text(
                      '${dats["info"]}',
                      style:GoogleFonts.adamina(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 15),

                  ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  Container(
                    child: Text(
                      ' Located at: ${dats["loc"]}',
                      style:GoogleFonts.adamina(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 15),

                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  Container(
                    child: Text(
                      'Phone: ${dats["phone"]}',
                      style:GoogleFonts.adamina(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 15),

                  ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                  Container(
                    child: Text(
                      'Followers: ${dats["followers"]}',
                      style:GoogleFonts.adamina(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 15),

                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),

                  Container(

                      child: ElevatedButton(
                        child: const Text('Contact Home'),
                        onPressed: () {
                          launch('tel:${getPhone()}');
                        },
                      )
                  )
                ],
              ),
            )),

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
                      color: fButtonColor,
                    ),
                  ),
                  onPressed: submit,
                )
              ],
            ),
          ],
        ),

      );

  getwidget() {
    if(useruid == widget.datas!.userid)
     return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: fBackgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: ElevatedButton(
          child: const Text('See Donations'),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Received()));                  },
        )
    );
    else
     return Container();
  }


}