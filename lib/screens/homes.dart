import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:fooddrop2/constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:fooddrop2/screens/homedetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login.dart';

class Homes extends StatefulWidget {
  final List? datas;

  const Homes({Key? key, @required this.datas}) : super(key: key);

  @override
  _HomesState createState() => _HomesState();
}

class _HomesState extends State<Homes> {
  // late List? data;
  Icon customIcon = const Icon(Icons.logout);
  Widget customSearchBar = const Text('Homes');
  List? _foundHomes = [];
  List? results = [];
  String hintText = 'enter location';

  FocusNode focusNode = FocusNode();

  TextEditingController editingController = TextEditingController();

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
  initState() {
    results = widget.datas;
    // focusNode.addListener(() {
    //   if (focusNode.hasFocus) {
    //     hintText = '';
    //   } else {
    //     hintText = 'Enter location';
    //   }});
    // setState(() {});

    // at the beginning, all users are shown
    _foundHomes = widget.datas;
    super.initState();
  }
  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = widget.datas;
    } else {
      results = widget.datas!
          .where((home) =>
          home["loc"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();

      print("results are $results");
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundHomes = results;
      print(" results are $results");
    });
  }
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
                    setState(() async {
                      if (customIcon.icon == Icons.logout) {
                        // Perform set of instructions.
                        final prefs = await SharedPreferences.getInstance();
                        prefs.remove('useruid');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Login()));

                      }

                      });

                  },
                ),
              ],),
        backgroundColor: fBackgroundColor,
        body:

        Container(
         child: results!.isNotEmpty?

        ListView.builder(
            padding: const EdgeInsets.all(4.5),
            itemCount: results?.length,
            itemBuilder: _itemBuilder,
          ):
         Container(
           child: Center(
             child:const Text(
               'No results found',
               style: TextStyle(fontSize: 24),
             ),
           )

         )


         )
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Container(
      height: 250,
        margin: EdgeInsets.all(5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: EdgeInsets.all(5),
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
              padding: EdgeInsets.all(5),
              height: 70.0,
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

}
