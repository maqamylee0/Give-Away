import 'dart:ffi';
import 'package:fooddrop2/constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDetail extends StatefulWidget {
  final  HomeModel? datas;

  const HomeDetail({Key? key, @required this.datas}) : super(key: key);
  @override
  _HomeDetailState createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
 // List stats = [{"children":23,"teenagers":34,"adults":43},{"children":23,"teenagers":34,"adults":43}];
 //   Map<String, int>? stat;
   get dats => widget.datas!.toMap();
   get stats => dats.uid;
   get keys =>dats["stats"].keys.toList();
   get values =>dats["stats"].values.toList();


  @override

  void initState() {
    // TODO: implement initState
    super.initState();
getInfo();
  }
  String? getId() {
    return widget.datas!.uid;
  }
get children=> dats["stats"][children];
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
  var cardImage = NetworkImage(
      'https://source.unsplash.com/random/800x600?house');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.datas!.title}",style: TextStyle(color: Colors.white)
      )),
      body: Column(
children:[
  Container(
    height: 150,
    decoration: BoxDecoration(
        color: fBackgroundColor,
        borderRadius: BorderRadius.all(
            Radius.circular(20))),
    child:  Image.asset("assets/home.png"),
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
                  decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.all(
                          Radius.circular(30))),
                  child: Column(

                      children: [


                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                  Radius.circular(30))),
                          padding: EdgeInsets.all(20),
                          child: Text('${keys[index]}',
                            style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontFamily: 'Roboto',
                            letterSpacing: 0.5,
                            fontSize: 10,),

                          ),),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(10))),
                          padding: EdgeInsets.all(20),

                          child: Text('${values[index]} ', style: TextStyle(
                              fontSize: 15),),

                        ),
                      ]));
            }),
    ),
  Container(
    child: new SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child:Column(
      children: [
        Container(
          margin: EdgeInsets.all(5),
          height:60,
          child: Text('${dats["title"]}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 10,),

          ),
          decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.all(
                  Radius.circular(10))),
          padding: EdgeInsets.all(10),
        ),

        Container(
          height:60,
          margin: EdgeInsets.all(5),
          child: Text('Description : ${dats["info"]}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 10,),

          ),          decoration: BoxDecoration(
            color: Colors.white,
              borderRadius: BorderRadius.all(
                  Radius.circular(10))),
          padding: EdgeInsets.all(10),
        ),
        Container(
          margin: EdgeInsets.all(5),
          height:60,
          child: Text(' Location: ${dats["loc"]}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 10,),

          ),
          decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.all(
                  Radius.circular(10))),
          padding: EdgeInsets.all(10),
        ),
        Container(
          margin: EdgeInsets.all(5),
          height:60,
          child: Text('Phone: ${dats["phone"]}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 10,),

          ),
          decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.all(
                  Radius.circular(10))),
          padding: EdgeInsets.all(10),
        ),
        Container(
          margin: EdgeInsets.all(5),
          height:60,
          child: Text('Followers: ${dats["followers"]}',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontFamily: 'Roboto',
              letterSpacing: 0.5,
              fontSize: 10,),

          ),
          decoration: BoxDecoration(
              color: Colors.white,

              borderRadius: BorderRadius.all(
                  Radius.circular(10))),
          padding: EdgeInsets.all(10),
        )
      ],
    ),
    )
  )

]),);}

  // Widget _itemBuilder(BuildContext context, int index) {
  //   return


  }
    //       Container(
    //   child: Card(
    //       elevation: 2.0,
    //       child: Column(
    //         children: [
    //           ListTile(
    //             title: Text(getName()!),
    //             subtitle: Text(getPhone()!),
    //             trailing: Icon(Icons.favorite_outline),
    //           ),
    //           Container(
    //             padding: EdgeInsets.only(right: 30, left:30),
    //             height: 100.0,
    //             child: Ink.image(
    //               image: cardImage,
    //               fit: BoxFit.fill,
    //             ),
    //           ),
    //           Container(
    //             padding: EdgeInsets.all(5.0),
    //             alignment: Alignment.centerLeft,
    //             child: Text(getName()!),
    //           ),
    //           ButtonBar(
    //             children: [
    //               TextButton(
    //                 child: const Text('CONTACT AGENT'),
    //                 onPressed: () {
    //                   launch('tel:${getPhone()}');
    //                 },
    //               ),
    //               TextButton(
    //                 child: const Text('LEARN MORE'),
    //                 onPressed: () {
    //                   //Navigator.of(context).push(MaterialPageRoute(
    //                  //     builder: (context) => HomeDetail(datas: widget.datas![index])));
    //                 },
    //               )
    //             ],
    //           )
    //         ],
    //       )),
    // ),
    //           Container(
    //             margin: EdgeInsets.all(30),
    //
    //             child: new SingleChildScrollView(
    //                 scrollDirection: Axis.horizontal,
    //
    //                 child :Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //
    //                 children: [
    //                 Container(
    //                   padding: EdgeInsets.all(15.0),
    //
    //                   child:  Card(
    //                     child: Column(
    //
    //                       children: [
    //
    //                 Container(
    //                   padding: EdgeInsets.all(15.0),
    //
    //                   height: 100,
    //                   child: Card(
    //                     child: Column(
    //                       children: [
    //                         Container(
    //                           child: const Text("Teenagers"),
    //                         ),
    //                         Container(
    //                           child: const Text("45"),
    //
    //                         )
    //
    //                       ],
    //                     ),
    //
    //                   ),
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.all(Radius.circular(30)),
    //                 ),),
    //
    //                 Container(
    //                   padding: EdgeInsets.all(15.0),
    //
    //                   height: 100,
    //                   child: Card(
    //                   child:Column(
    //                   children: [
    // Container(
    // child: const Text("Adults"),
    // ),
    // Container(
    // child: const Text("45"),
    //
    // )
    //
    // ],
    // ) ,
    //                   ),
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.all(Radius.circular(30)),
    //                 ),),
    //
    //                 Container(
    //                   padding: EdgeInsets.all(15.0),
    //
    //                   height: 100,
    //                   child: Card(
    //                   child: Column(
    //                   children: [
    // Container(
    // child: const Text("Aids"),
    //
    // ),
    // Container(
    //
    // child: const Text("45"),
    //
    // )
    //
    // ],
    //
    // )),
    //
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.all(Radius.circular(30)),
    //                 ),),
    //
    //                 Container(
    //                   height: 100,
    //                   decoration: BoxDecoration(
    //                     borderRadius: BorderRadius.all(Radius.circular(30)),
    //                 )
    //                 ),
    //
    //             ])),
    //           )
    // ]
    // ));


  //   }
  // }








