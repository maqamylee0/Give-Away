import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeDetail extends StatefulWidget {
  final HomeModel datas;

  const HomeDetail({Key? key, required this.datas}) : super(key: key);
  @override
  _HomeDetailState createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {


  String? getId() {
    return widget.datas.uid;
  }

  String? getName() {
    return widget.datas.title;
  }
  String? getInfo() {
    return widget.datas.info;
  }
  String? getPhone() {
    return widget.datas.phone;
  }
  var cardImage = NetworkImage(
      'https://source.unsplash.com/random/800x600?house');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.datas.title!,style: TextStyle(color: Colors.white)
      )),
      body: Container(
      child: Card(
          elevation: 2.0,
          child: Column(
            children: [
              ListTile(
                title: Text(getName()!),
                subtitle: Text(getPhone()!),
                trailing: Icon(Icons.favorite_outline),
              ),
              Container(
                padding: EdgeInsets.only(right: 30, left:30),
                height: 100.0,
                child: Ink.image(
                  image: cardImage,
                  fit: BoxFit.fill,
                ),
              ),
              Container(
                padding: EdgeInsets.all(5.0),
                alignment: Alignment.centerLeft,
                child: Text(getName()!),
              ),
              ButtonBar(
                children: [
                  TextButton(
                    child: const Text('CONTACT AGENT'),
                    onPressed: () {
                      launch('tel:${getPhone()}');
                    },
                  ),
                  TextButton(
                    child: const Text('LEARN MORE'),
                    onPressed: () {
                      //Navigator.of(context).push(MaterialPageRoute(
                     //     builder: (context) => HomeDetail(datas: widget.datas![index])));
                    },
                  )
                ],
              )
            ],
          )),
        ));}
  }

