class DonationModel {
  String? uid;
  String? from;
  String? tophone;
  String? touid;
  String? item;
  bool? status;

  DonationModel({this.uid, this.from, this.tophone,this.touid,this.item,this.status});

  // receiving data from server
  factory DonationModel.fromMap(map) {
    return DonationModel(
      uid: map['uid'],
      from: map['from'],
      tophone: map['tophone'],
      touid: map['touid'],
      item: map['item'],
      status:map['status'],


    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'from': from,
      'tophone': tophone,
      'touid': touid,
      'item':item,
      'status':status,

    };
  }
}