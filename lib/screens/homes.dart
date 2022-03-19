import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:fooddrop2/constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:fooddrop2/screens/homedetail.dart';
import 'package:url_launcher/url_launcher.dart';

class Homes extends StatefulWidget {
  final List? datas;

  const Homes({Key? key, @required this.datas}) : super(key: key);

  @override
  _HomesState createState() => _HomesState();
}

class _HomesState extends State<Homes> {
  // late List? data;

  int getId(int index) {
    return widget.datas![index]["uid"];
  }

  String getName(int index) {
    return widget.datas![index]["title"];
  }

  String getInfo(int index) {
    return widget.datas![index]["info"];
  }

  String getPhone(int index) {
    return widget.datas![index]["phone"];
  }

  int? getLength() {
    return widget.datas?.length;
  }

  var cardImage =
      NetworkImage('https://source.unsplash.com/random/800x600?house');
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Scaffold(
        appBar:
            AppBar(title: Text("Homes", style: TextStyle(color: Colors.white))),
        backgroundColor: fBackgroundColor,
        body: ListView.builder(
          padding: const EdgeInsets.all(4.5),
          itemCount: this.getLength(),
          itemBuilder: _itemBuilder,
        ),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
        margin: EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(getName(index)),
              subtitle: Text(getPhone(index)),
              trailing: Icon(Icons.favorite_outline),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              padding: EdgeInsets.all(10),
              height: 100.0,
              child: Ink.image(
                image: cardImage,
                fit: BoxFit.fill,
              ),
            ),
            Container(
              padding: EdgeInsets.all(5.0),
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Text(getName(index)),
            ),
            ButtonBar(
              children: [
                TextButton(
                  child: const Text('CONTACT AGENT'),
                  onPressed: () {
                    launch('tel:${getPhone(index)}');
                  },
                ),
                TextButton(
                  child: const Text('LEARN MORE'),
                  onPressed: () {
                    print("data is " + widget.datas![index].toString());
                    HomeModel a = new HomeModel();

                    a.uid = widget.datas![index]["uid"].toString();
                    a.title = widget.datas![index]["title"];
                    a.info = widget.datas![index]["info"];
                    a.phone = widget.datas![index]["phone"];
                    a.lat = widget.datas![index]["lat"];
                    a.long = widget.datas![index]["long"];
                    a.adults = widget.datas![index]["stats"]["adults"];
                    a.aids = widget.datas![index]["stats"]["aids"];
                    a.blind = widget.datas![index]["stats"]["blind"];
                    a.children = widget.datas![index]["stats"]["children"];
                    a.deaf = widget.datas![index]["stats"]["deaf"];
                    a.dumb = widget.datas![index]["stats"]["dumb"];
                    a.orphans = widget.datas![index]["stats"]["orphans"];
                    a.others = widget.datas![index]["stats"]["others"];
                    a.teenagers = widget.datas![index]["stats"]["teenagers"];
                    print("dat1 is ${a.toMap()}");
                    Map<String, dynamic> as = a.toMap();
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HomeDetail(datas: a)));
                  },
                )
              ],
            )
          ],
        ));
  }
  //return InkWell(
  // child: Card(
  //   child: Center(
  //     child: Text(
  //       "${this.getName(index)}",
  //       style: TextStyle(
  //         fontWeight: FontWeight.w500,
  //         color: Colors.orange,
  //       ),
  //     ),
  //   ),
  // ),
  //onTap: () => MaterialPageRoute(
  // builder: (context) =>
  //SecondRoute(id: _data.getId(index), name: _data.getName(index))),
  // );
  // }
}
