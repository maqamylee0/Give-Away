import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:fooddrop2/screens/addMarker.dart';
import 'package:fooddrop2/screens/homedetail.dart';
import 'package:fooddrop2/screens/homes.dart';
import 'package:fooddrop2/screens/login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  // Set<Marker> _markers = {};
  final Set<Marker> _markers = new Set();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  static List? data;
  // late Marker marker;

  void initState() {
    _LoadPosition();
    super.initState();
    setState(() {});
  }

  getMarkers(uid, title, info, phone, lat, long, location, followers, adults,
      aids, blind, children, deaf, dumb, orphans, others, teenagers) {
    _markers.add(Marker(
        markerId: MarkerId(uid),
        position: LatLng(lat as double, long as double),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
            title: title,
            onTap: () {
              var bottomSheetController =
                  scaffoldKey.currentState!.showBottomSheet(
                (context) => Container(
                  child: getBottomSheet(
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
                      teenagers),
                  height: 250,
                  color: Colors.transparent,
                ),
              );
            },
            snippet: info)));
    // return marker;
  }

//  Future<Set<Marker>> getMarkers() async {
// //  StreamBuilder(stream: ,)
// }
  Future<LatLng> _LoadPosition() async {
    _center = LatLng(LoginState.currentPosition.latitude,
        LoginState.currentPosition.longitude);

    QuerySnapshot querySnapshot = await _collectionRef.get();

    data = querySnapshot.docs.map((doc) => doc.data()).toList();
    print("datass is ${data!}");
    for (int i = 0; i < data!.length; i++) {
      // _markers.add( Marker(
      //     markerId: MarkerId(data[i]['uid'].toString()),
      //     position: LatLng(data[i]['lat'],data[i]['long']),
      //
      //     icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      //     infoWindow: InfoWindow(
      //         title: title,onTap: (){
      //       var bottomSheetController=scaffoldKey.currentState!.showBottomSheet((
      //           context) => Container(
      //         child: getBottomSheet(data[i]['lat'].toString(),data[i]['long'].toString(),data[i]['title'].toString()),
      //         height: 250,
      //         color: Colors.transparent,
      //       ));
      //     },snippet: info
      //     )
      // ),);

      HomeModel a = HomeModel();

      a.uid = data![i]["uid"].toString();
      a.title = data![i]["title"];
      a.info = data![i]["info"];
      a.phone = data![i]["phone"];
      a.lat = data![i]["lat"];
      a.long = data![i]["long"];
      a.location = data![i]["loc"];
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
      // print("item => ${a.uid} ,${a.title} ,${a.info} ,${a.phone} ,${a.lat}, ${a.long}");
      getMarkers(
          a.uid,
          a.title,
          a.info,
          a.phone,
          a.lat,
          a.long,
          a.location,
          a.followers,
          a.adults,
          a.aids,
          a.blind,
          a.children,
          a.deaf,
          a.dumb,
          a.orphans,
          a.others,
          a.teenagers);
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
      } else if (index == 1) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => Homes(datas: data)));
      } else {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => MarkerPage(datas: data)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,

        appBar: AppBar(
          title: const Text('Find Homes'),
          backgroundColor: Colors.green[500],
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
                      IconThemeData(color: Colors.white, size: 40),
                  selectedItemColor: Colors.white,
                  selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
                  backgroundColor: Colors.green,
                  unselectedItemColor: Colors.black,

                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Homes',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.card_giftcard),
                      label: 'Donate',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.add),
                      label: 'Add Home',
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
      int teenagers) {
    return Stack(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(15),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
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
                          Text("4.5",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                          Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text("100 Folowers",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14))
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Entebbe",
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
                  Icon(
                    Icons.map,
                    color: Colors.blue,
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
                    color: Colors.blue,
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
                  child: Icon(Icons.navigation),
                  onPressed: () {
                    HomeModel a = new HomeModel();

                    a.title = title;
                    a.info = info;
                    a.phone = phone;
                    a.lat = lat as double?;
                    a.long = long as double?;
                    a.location = location;
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
