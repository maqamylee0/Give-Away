import 'dart:ffi';

class HomeModel {
  String? uid;
   String? title;
   String? info;
   String? phone;
   double? lat;
   double? long;



  HomeModel({uid, title, info, phone,lat,long});

  // receiving data from server
  factory HomeModel.fromMap(map) {
    return HomeModel(
      uid: map['uid'],
      title: map['title'],
      info: map['info'],
      phone: map['phone'],
      lat: map['lat'],
      long: map['long'],

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
      "long":long
    };
  }
}