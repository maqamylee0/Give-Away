import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'package:fooddrop2/constants.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fooddrop2/models/home.dart';
import 'package:fooddrop2/screens/homedetail.dart';
import 'package:google_fonts/google_fonts.dart';
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
  Icon customIcon = const Icon(Icons.search);
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


  @override
  initState() {
    results = widget.datas;


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
              titleTextStyle:GoogleFonts.lato(fontStyle: FontStyle.normal,fontWeight: FontWeight.bold,fontSize: 20),                          //fontWeight: FontWeight.bold,

              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: customIcon,
                  onPressed: () {
                    setState(() {               // Perform set of instructions.


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

                             onChanged:(value) => _runFilter(value),
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
                      } else {
                        customIcon = const Icon(Icons.search);
                        customSearchBar = const Text('Homes');

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
            // Container(
            //   height: 80,
            //   alignment: Alignment.centerLeft,
            //
            //       decoration: BoxDecoration(
            //           color: fBackgroundColor,
            //           borderRadius: BorderRadius.all(Radius.circular(20))),
            //       child: Image.asset("assets/home.png"),
            //
            // ),
            // Container(
            //   padding: EdgeInsets.all(5.0),
            //   alignment: Alignment.centerLeft,
            //   decoration: BoxDecoration(
            //       color: Colors.white,
            //       borderRadius: BorderRadius.all(Radius.circular(10))),
            //   child: Text(getName(index)),
            // ),
    Container(
      padding: EdgeInsets.fromLTRB(0, 0, 6, 0),
      decoration: BoxDecoration(
          color: fBackgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Row(
              children: <Widget>[
                Container(
               decoration: BoxDecoration(
               color: fBackgroundColor,
               borderRadius: BorderRadius.all(Radius.circular(20))),                  height: 100,
                  alignment: Alignment.centerLeft,
               child: Image.asset("assets/home.png"),
                  ),



          Flexible(


                        child: Text(getInfo(index),
                      style: //TextStyle(color: Colors.black,
                          GoogleFonts.lato(fontStyle: FontStyle.italic),                          //fontWeight: FontWeight.bold,
                        //  fontSize: 17.0),
                    )),
              ],
            ),
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
