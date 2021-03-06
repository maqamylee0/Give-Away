import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fooddrop2/constants.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:fooddrop2/screens/addMarker.dart';
import 'package:fooddrop2/screens/homedetail.dart';
import 'package:fooddrop2/screens/homes.dart';
import 'package:fooddrop2/screens/login.dart';
import 'package:fooddrop2/screens/sent.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class Map extends StatefulWidget {
  final List? datat;
  final LatLng? positions;
  const Map(
      {Key? key,
      @required data,
      @required position,
      this.datat,
      this.positions})
      : super(key: key);

  @override
  MapState createState() => MapState();
}

class MapState extends State<Map> {
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('homes');

  late GoogleMapController mapController;
  late LatLng _center;
  late BitmapDescriptor pinLocationIcon;
  final Set<Marker> _markers = new Set();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static List? data;
  // late Marker marker;
  Icon customIcon = const Icon(Icons.logout);
  late final prefs;

  void initState() {
    getIds();
    _LoadPosition();
    super.initState();
    setState(() {});
  }
  getIds() async {


    }




  getMarkers(uid, title, info, phone, lat, long, location, followers, adults,
      aids, blind, children, deaf, dumb, orphans, others, teenagers,userid) async {
    BitmapDescriptor markerbitmap = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(),
        "assets/map.png",
        );
        _markers.add(Marker(
        markerId: MarkerId(uid),
        position: LatLng(lat as double, long as double),
        icon: markerbitmap,
        infoWindow: InfoWindow(
            title: title,
            onTap: () {
              var bottomSheetController =
                  scaffoldKey.currentState!.showBottomSheet(
                (context) => Container(
                  child: getBottomSheet( uid,
                      lat,
                      long,
                      title.toString(),
                      info.toString(),
                      phone.toString(),
                      location,
                      followers,
                      adults,
                      aids,
                      blind,
                      children,
                      deaf,
                      dumb,
                      orphans,
                      others,
                      teenagers,
                      userid),
                  height: 250,
                  color: Colors.transparent,
                ),
              );
            },
            snippet: info)));
    // return marker;
  }

  Future<LatLng> _LoadPosition() async {
    _center = LatLng(LoginState.currentPosition.latitude,
        LoginState.currentPosition.longitude);

    QuerySnapshot querySnapshot = await _collectionRef.get();

    data = querySnapshot.docs.map((doc) => doc.data()).toList();
    print("datass is ${data!}");
    for (int i = 0; i < data!.length; i++) {


      HomeModel a = HomeModel();

      a.uid = data![i]["uid"].toString();
      a.title = data![i]["title"];
      a.info = data![i]["info"];
      a.phone = data![i]["phone"];
      a.lat = data![i]["lat"];
      a.long = data![i]["long"];
      a.loc = data![i]["loc"];
      a.followers = data![i]["followers"];
      a.adults = data![i]["stats"]["adults"];
      a.aids = data![i]["stats"]["aids"];
      a.blind = data![i]["stats"]["blind"];
      a.children = data![i]["stats"]["children"];
      a.deaf = data![i]["stats"]["deaf"];
      a.dumb = data![i]["stats"]["dumb"];
      a.orphans = data![i]["stats"]["orphans"];
      a.others = data![i]["stats"]["others"];
      a.teenagers = data![i]["stats"]["teenagers"];
      a.userid=data![i]["userid"];
      // print("item => ${a.uid} ,${a.title} ,${a.info} ,${a.phone} ,${a.lat}, ${a.long}");
      getMarkers(
          a.uid,
          a.title,
          a.info,
          a.phone,
          a.lat,
          a.long,
          a.loc,
          a.followers,
          a.adults,
          a.aids,
          a.blind,
          a.children,
          a.deaf,
          a.dumb,
          a.orphans,
          a.others,
          a.teenagers,
      a.userid);
    }

    return _center;
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  int _selectedIndex = 0; //New

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 0) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Map()));
      } else if (index == 1) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Homes(datas: data)));
      } else if(index == 2){
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MarkerPage(datas: data)));
      }else  {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => Sent()));}
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(

        key: scaffoldKey,

        appBar: AppBar(
          title: const Text('Find Homes'),
          actions: [
            // ElevatedButton.icon(
            //   // <-- ElevatedButton
            //
            //   onPressed: () {
            //     setState(() async{
            //
            //       if (customIcon.icon == Icons.logout) {
            //         // Perform set of instructions.
            //         Box box1 = await Hive.openBox('personaldata');
            //         box1.deleteFromDisk();
            //         Navigator.of(context).push(MaterialPageRoute(
            //             builder: (context) => Login()));
            //
            //       }
            //
            //     });

             //  },
             //  icon: customIcon,
             //
             //  label: Text('Logout'),
             // ),
        //IconButton(
            //
            //   icon: customIcon,
            //   onPressed: () {
            //
            //   },
            // ),
          ],
          backgroundColor: fButtonColor,
        ),
        // body:
        // ),

        bottomNavigationBar: Container(
            margin: EdgeInsets.all(15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(50), topLeft: Radius.circular(50)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black38, spreadRadius: 0, blurRadius: 10),
              ],
            ),
            child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50.0),
                  topRight: Radius.circular(50.0),
                ),
                child: BottomNavigationBar(
                  selectedFontSize: 20,
                  selectedIconTheme:
                      IconThemeData(color: fButtonColor, size: 40),
                  selectedItemColor: fButtonColor,
                  selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                  backgroundColor: fBackgroundColor,
                  unselectedItemColor: Colors.black,

                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.list),
                      label: 'Homes',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add),
                      label: 'Add Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.card_giftcard),
                      label: 'Donations',
                    ),
                  ],
                  currentIndex: _selectedIndex, //New
                  onTap: _onItemTapped,
                ))),
        body: FutureBuilder(
          builder: (ctx, snapshot) {
            // Checking if future is resolved or not
            if (snapshot.connectionState == ConnectionState.done) {
              // If we got an error
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    '${snapshot.error} occured',
                    style: TextStyle(fontSize: 18),
                  ),
                );

                // if we got our data
              } else if (snapshot.hasData) {
                // Extracting data from snapshot object
                return Center(
                    child: GoogleMap(
                  compassEnabled: true,
                  markers: _markers,
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: this._center,
                    zoom: 11.0,
                  ),
                ));
              }
            }

            // Displaying LoadingSpinner to indicate waiting state
            return Center(
              child: CircularProgressIndicator(),
            );
          },

          // Future that needs to be resolved
          // inorder to display something on the Canvas
          future: _LoadPosition(),
        ),
      ),
    );
  }

  Widget getBottomSheet(
      String uid,
      double lat,
      double long,
      String title,
      String info,
      String phone,
      String location,
      int followers,
      int adults,
      int aids,
      int blind,
      int children,
      int deaf,
      int dumb,
      int orphans,
      int others,
      int teenagers,
      String userid) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: fButtonColor,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),

                // color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: TextStyle(color: Colors.white, fontSize: 14),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          // Text(info,
                          //     style:
                          //         TextStyle(color: Colors.white, fontSize: 12)),
                          // mj
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(location,
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  const Icon(
                    Icons.map,
                    color: fButtonColor,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("$lat" + "  " + "$long")
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  SizedBox(
                    width: 20,
                  ),
                  Icon(
                    Icons.call,
                    color: fButtonColor,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text("$phone")
                ],
              )
            ],
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
              alignment: Alignment.topRight,
              child: FloatingActionButton(
                backgroundColor:Colors.white ,
                  child: Icon(Icons.more,color: fButtonColor,),
                  onPressed: () {
                    HomeModel a = new HomeModel();
                    a.uid=uid;
                    a.title = title;
                    a.info = info;
                    a.phone = phone;
                    a.lat = lat as double?;
                    a.long = long as double?;
                    a.loc = location;
                    a.followers = followers;
                    a.adults = adults;
                    a.aids = aids;
                    a.blind = blind;
                    a.children = children;
                    a.deaf = deaf;
                    a.dumb = dumb;
                    a.orphans = orphans;
                    a.others = others;
                    a.teenagers = teenagers;
                    a.userid=userid;
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeDetail(datas: a)));
                    //   Navigator.of(context).push(MaterialPageRoute(
                    //       builder: (context) => HomeDetail(datas: this.data)));
                    // }),
                  }),
            ))
      ],
    );
  }
}

