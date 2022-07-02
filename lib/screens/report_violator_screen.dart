import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/auth/police.dart';
import 'package:traffic_police/screens/history_screen.dart';
import 'package:traffic_police/utils/get_image.dart';

class ReportViolatorScreen extends StatefulWidget {
  const ReportViolatorScreen({Key? key}) : super(key: key);

  @override
  _ReportViolatorScreenState createState() => _ReportViolatorScreenState();
}

class _ReportViolatorScreenState extends State<ReportViolatorScreen> {
  CollectionReference fineList =
      FirebaseFirestore.instance.collection('fineList');
  final TextEditingController _vehicleNumber = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _amount = TextEditingController();

  bool _loadImage = false;
  String imgUrl = '';

  GetImage _getImgRef = new GetImage();

  @override
  void initState() {
    // TODO: implement initState
    print(DateTime.now());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Report Violator'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 230,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                  ),
                  image: (_loadImage == false) && (imgUrl.isNotEmpty)
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black26, BlendMode.darken),
                          image: NetworkImage(imgUrl),
                        )
                      : DecorationImage(
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                              Colors.black26, BlendMode.darken),
                          image: AssetImage('assets/police.png'),
                        ),
                  color: Color(0xff1592ff),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: 170,
                      left: 300,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: _getImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  obscureText: false,
                  controller: _vehicleNumber,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Vehicle License number',
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: TextField(
                  controller: _description,
                  decoration: const InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(),
                    hintText: 'Description',
                  ),
                  maxLines: 3,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _amount,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Amount',
                  ),
                ),
              ),
              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Report'),
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.white,
                  ),
                  onPressed: _validateAndBook,
                ),
              ),
            ],
          ),
        ));
  }

  Future _getImage() async {
    _loadImage = true;
    var imageUrl = await _getImgRef.getImage();
    setState(() {
      imgUrl = imageUrl;
    });
    _loadImage = false;
  }

  void _validateAndBook() {
    final errorResult = _validate();
    if (errorResult['status']) {
      _addToFineList();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorResult['message'])));
    }
  }

  Future<void> _addToFineList() async {
    List fineItem = [];
    List<String> ids = [];
    fineItem.add(toMap());
    print(fineItem);
    await FirebaseFirestore.instance
        .collection('fineList')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        ids.add(doc.id);
      });
    });
    if (ids.contains(_vehicleNumber.text.trim())) {
      await fineList
          .doc(_vehicleNumber.text.trim())
          .update({'finedList': FieldValue.arrayUnion(fineItem)}).then((value) {
        print('Fine updated');
        // _addToBookDateList();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HistoryLogScreen()));
      }).catchError((error) {
        print("Failed to update fine: $error");
      });
    } else {
      await fineList
          .doc(_vehicleNumber.text.trim())
          .set({'finedList': FieldValue.arrayUnion(fineItem)}).then((value) {
        print('Fine created');

        // _addToBookDateList();
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HistoryLogScreen()));
      }).catchError((error) {
        print("Failed to create fine: $error");
      });
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'vehicleNumber': _vehicleNumber.text,
      'amount': _amount.text,
      'description': _description.text,
      'imgUrl': imgUrl,
      'fineId': 'sdkde2343df',
      'date': DateTime.now(),
      'status': false,
    };
  }

  _validate() {
    Map errorHandler = {'status': false, 'message': ''};
    if (_description.text.isEmpty || _description.text.length < 10) {
      errorHandler['message'] =
          'Description should not be empty or less than 10 characters';
      return errorHandler;
    } else if (imgUrl.isEmpty) {
      errorHandler['message'] = 'Image should not be empty';
      return errorHandler;
    } else if (_amount.text.isEmpty) {
      errorHandler['message'] = 'Amount of fine should not be empty';
      return errorHandler;
    } else if (_vehicleNumber.text.isEmpty || _vehicleNumber.text.length < 4) {
      errorHandler['message'] =
          'Please license number should not be empty and should be greater than 3 characters';
      return errorHandler;
    } else {
      errorHandler['status'] = true;
      return errorHandler;
    }
  }
}
