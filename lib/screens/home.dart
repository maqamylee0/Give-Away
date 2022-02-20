import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:fooddrop2/screens/addMarker.dart';
import 'package:fooddrop2/screens/login.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({Key? key}) : super(key: key);

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
  // List? allData;
  // late Marker marker;

  get uid => null;

  get title => null;

  get info => null;

  get phone => null;

  get lat => null;

  get long => null;

  void initState() {
    _LoadPosition();
    super.initState();
    setState(() {

    });
  }

getMarkers(uid,title,info,phone,lat,long){

    _markers.add(
        Marker(
            markerId: MarkerId(uid),
            position: LatLng(lat as double,long as double),

            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            infoWindow: InfoWindow(
                title: title,onTap: (){
              var bottomSheetController=scaffoldKey.currentState!.showBottomSheet((
                  context) => Container(
                child: getBottomSheet(lat.toString(),long.toString(),title.toString()),
                height: 250,
                color: Colors.transparent,
              ),);
            },snippet: info
            )
        )
    );
  // return marker;
}
//  Future<Set<Marker>> getMarkers() async {
// //  StreamBuilder(stream: ,)
// }
  Future<LatLng> _LoadPosition() async {

    _center = LatLng(LoginState.currentPosition.latitude, LoginState.currentPosition.longitude);

    QuerySnapshot querySnapshot = await _collectionRef.get();

   List? data = querySnapshot.docs.map((doc) => doc.data()).toList();

    for (int i = 0; i < data!.length; i++) {

          _markers.add( Marker(
              markerId: MarkerId(data[i]['uid'].toString()),
              position: LatLng(data[i]['lat'],data[i]['long']),

              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              infoWindow: InfoWindow(
                  title: title,onTap: (){
                var bottomSheetController=scaffoldKey.currentState!.showBottomSheet((
                    context) => Container(
                  child: getBottomSheet(data[i]['lat'].toString(),data[i]['long'].toString(),data[i]['title'].toString()),
                  height: 250,
                  color: Colors.transparent,
                ));
              },snippet: info
              )
          ),);
      // a.uid = allData![i]["uid"].toString();
      // a.title = allData![i]["title"];
      // a.info = allData![i]["info"];
      // a.phone = allData![i]["phone"];
      // a.lat = allData![i]["lat"];
      // a.long = allData![i]["long"];
      // // print("item => ${a.uid} ,${a.title} ,${a.info} ,${a.phone} ,${a.lat}, ${a.long}");
      //    getMarkers(a.uid, a.title, a.info, a.phone, a.lat, a.long);

    }

    return _center;
  }

  Future<void> _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        key: scaffoldKey,

        appBar: AppBar(
          title: const Text('Drop Points'),
          backgroundColor: Colors.green[500],
        ),
        // body:
        // ),
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
  Widget getBottomSheet(String lat, String long ,String title,)
  {
    return Stack(
      children: <Widget>[
        Container(

          margin: EdgeInsets.only(top: 32),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.green,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title,style: TextStyle(
                          color: Colors.white,
                          fontSize: 14
                      ),),
                      SizedBox(height: 5,),
                      Row(children: <Widget>[

                        Text("4.5",style: TextStyle(
                            color: Colors.white,
                            fontSize: 12
                        )),
                        Icon(Icons.star,color: Colors.yellow,),
                        SizedBox(width: 20,),
                        Text("100 Folowers",style: TextStyle(
                            color: Colors.white,
                            fontSize: 14
                        ))
                      ],),
                      SizedBox(height: 5,),
                      Text("Entebbe",style: TextStyle(
                          color: Colors.white,
                          fontSize: 14
                      )),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[SizedBox(width: 20,),Icon(Icons.map,color: Colors.blue,),SizedBox(width: 20,),Text("$lat"+""+"$long")],
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[SizedBox(width: 20,),Icon(Icons.call,color: Colors.blue,),SizedBox(width: 20,),Text("0772024843")],
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
                onPressed: (){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MarkerPage()));
                }),
          ),
        )
      ],

    );
  }

}
