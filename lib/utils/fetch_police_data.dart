import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/auth/auth.dart';
import 'package:traffic_police/auth/police.dart';

class FetchPoliceData {
  void loadUserData(BuildContext context) async {
    CollectionReference stylist =
        FirebaseFirestore.instance.collection('police');
    final authClass = Provider.of<AuthClass>(context, listen: false);
    final policeClass = Provider.of<Police>(context, listen: false);
    String tid = authClass.auth.currentUser!.uid;

    await stylist.doc(tid).get().then((query) {
      Map<String, dynamic> data = query.data() as Map<String, dynamic>;
      policeClass.policeRef = data;
    });
  }
}

