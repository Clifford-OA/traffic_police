import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Police extends ChangeNotifier {
  Police(this.admin, this.imgUrl, this.tid, this.name, this.tel,
      this.checkPoint, this.email, this.address);

  String name;
  String tid;
  String imgUrl;
  String tel;
  String address;
  bool admin;
  String checkPoint;
  String email;

  DocumentReference get firestoreRef =>
      FirebaseFirestore.instance.collection('police').doc('$tid');

  Police get policeData =>
      Police(admin, imgUrl, tid, name, tel, checkPoint, email, address);

  Future<void> saveInfo() async {
    await firestoreRef.set(toMap());
  }

  Map<String, dynamic> toMap() {
    return {
      'tid': tid,
      'name': name,
      'email': email,
      'admin': admin,
      'imgUrl': imgUrl,
      'tel': tel,
      'address': address,
      'checkPoint': checkPoint,
    };
  }

  set policeRef(Map<String, dynamic> data) {
    name = data['name'];
    imgUrl = data['imgUrl'];
    tid = data['tid'];
    checkPoint = data['checkPoint'];
    address = data['address'];
    email = data['email'];
    tel = data['tel'];
    admin = data['admin'];
    notifyListeners();
  }

  Map<String, dynamic> get policeRef {
    return {
      'tid': tid,
      'name': name,
      'email': email,
      'admin': admin,
      'checkPoint': checkPoint,
      'tel': tel,
      'address': address,
      'imgUrl': imgUrl
    };
  }
}


// class Service {
//   Service(this.duration, this.price, this.title);
//   String title;
//   double price;
//   String duration;
//   Map<String, dynamic> get serviceRef {
//     return {'price': price, 'title': title};
//   }
//   set serviceRef(dynamic data) {
//     title = data['title'];
//     price = data['price'].toDouble();
//     duration = data['duration'];
//   }
// }
