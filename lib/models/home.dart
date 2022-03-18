import 'dart:ffi';

import 'package:flutter/material.dart';

class HomeModel {
  String? uid;
   String? title;
   String? info;
   String? phone;
   double? lat;
   double? long;
  int? followers;
  String? location;
  Map<String ,int>? stats;
  int? adults;
  int?  aids;
  int? blind;
  int? children;
  int? deaf;
  int? dumb;
  int? orphans;
  int? others;
  int? teenagers;




  HomeModel({uid, title, info, phone,lat,long,followers,loc,stats, adults, aids, blind, children, deaf, dumb, orphans, teenagers, others});

  // receiving data from server
  factory HomeModel.fromMap(map) {
    return HomeModel(
      uid: map['uid'],
      title: map['title'],
      info: map['info'],
      phone: map['phone'],
      lat: map['lat'],
      long: map['long'],
      followers: map['followers'],
      loc:map['loc'],
        stats:map (
            adults: map["stats"]["adults"],
            aids:map["stats"]["aids"],
            blind:map["stats"]["blind"],
            children:map["stats"]["children"],
            deaf:map["stats"]["deaf"],
            dumb:map["stats"]["dumb"],
            orphans:map["stats"]["orphans"],
            others:map["stats"]["others"],
            teenagers:map["stats"]["teenagers"],

        )


    );
  }
  factory HomeModel.fromObject(object) {
    return HomeModel(
      uid: object.uid,
      title: object.title,
      info: object.info,
      phone: object.phone,
      lat: object.lat,
      long: object.long,
      followers: object.followers,
      loc: object.loc,
        stats:object.stats,
      adults: object.stats.adults,
      aids:object.stats.aids,
      blind:object.stats.blind,
      children:object.stats.children,
      deaf:object.stats.deaf,
      dumb:object.stats.dumb,
      orphans:object.stats.orphans,
      others:object.stats.others,
      teenagers:object.stats.teenagers,

    );
  }
  // sending data to our server
   Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'title': title,
      'info': info,
      'phone': phone,
      "lat": lat,
      "long":long,
      "followers":followers,
      "loc":location,
      "stats":{
        "adults":adults,
        "aids":aids,
        "blind":blind,
        "children":children,
        "deaf":deaf,
        "dumb":dumb,
        "orphans":orphans,
        "others":others,
        "teenagers":teenagers,
      }
    };
  }
}