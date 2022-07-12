import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/auth/police.dart';
import 'package:traffic_police/widgets/edit_textfield.dart';
import 'package:traffic_police/widgets/rounded_button.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  String imgUrl = '';

  String name = '';
  String address = '';
  String checkPoint = '';
  String _tel = '';
  bool _loadImage = false;

  @override
  Widget build(BuildContext context) {
    final police = Provider.of<Police>(context, listen: true);
    Map<String, dynamic> _policeInfo = police.policeRef;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
        elevation: 0.0,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 35,
                          letterSpacing: 1.5,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(5.0),
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: _loadImage == false
                            ? FadeInImage.assetNetwork(
                                placeholder: 'assets/images/no_picture.jpg',
                                image: _policeInfo['imgUrl'],
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/no_picture.jpg',
                                  );
                                },
                                fit: BoxFit.cover,
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: 400,
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      textfield(
                          inputType: TextInputType.text,
                          formatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z]'))
                          ],
                          hintText: _policeInfo['name'],
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          }),
                      textfield(
                          inputType: TextInputType.text,
                          formatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z]'))
                          ],
                          hintText: _policeInfo['checkPoint'],
                          onChanged: (value) {
                            setState(() {
                              checkPoint = value;
                            });
                          }),
                      textfield(
                        inputType: TextInputType.text,
                        hintText: _policeInfo['email'],
                      ),
                      textfield(
                          inputType: TextInputType.number,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                          hintText: _policeInfo['tel'],
                          onChanged: (value) {
                            setState(() {
                              _tel = value;
                            });
                          }),
                      textfield(
                          inputType: TextInputType.number,
                          formatters: [FilteringTextInputFormatter.digitsOnly],
                          hintText: _policeInfo['address'],
                          onChanged: (value) {
                            setState(() {
                              address = value;
                            });
                          }),
                      RoundedButton(
                        buttonName: 'Update',
                        action: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 270, left: 184),
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
            )
          ],
        ),
      ),
    );
  }

  Future _getImage() async {
    final policeClass = Provider.of<Police>(context, listen: false);
    late File image;
    String tid = policeClass.tid;
    final XFile? img = await _picker.pickImage(source: ImageSource.gallery);
    _loadImage = true;
    File file = File(img!.path);
    setState(() {
      image = file;
    });
    var storeImage = FirebaseStorage.instance.ref().child(image.path);
    var task = await storeImage.putFile(image);
    imgUrl = await storeImage.getDownloadURL();
    print('downloadurl ' + imgUrl);
    await FirebaseFirestore.instance
        .collection('police')
        .doc(tid)
        .update({'imgUrl': imgUrl}).then((value) {
      policeClass.imgUrl = imgUrl;
      _loadImage = false;
    });
  }

// validate and update stylist info
  void _validateAndCreateService() async {
    CollectionReference stylist =
        FirebaseFirestore.instance.collection('stylists');
    final stylistClass = Provider.of<Police>(context, listen: false);
    String tid = stylistClass.tid;
    final errorResult = validateName();
    if (errorResult['status']) {
      await stylist.doc(tid).update({
        'name': name,
        'checkPoint': checkPoint,
        'tel': _tel,
        'address': address
      }).then((value) {
        _reloadUserData();
        Navigator.of(context).pop();
        print('created successfully');
      }).catchError((error) {
        print("Failed to book: $error");
      });
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(errorResult['message'])));
    }
  }

// reload user data for provider to get access
  void _reloadUserData() async {
    CollectionReference police =
        FirebaseFirestore.instance.collection('police');
    final policeClass = Provider.of<Police>(context, listen: false);
    String tid = policeClass.tid;

    await police.doc(tid).get().then((query) {
      Map<String, dynamic> data = query.data() as Map<String, dynamic>;
      policeClass.policeRef = data;
    });
  }

// validate all field
  validateName() {
    Map errorHandler = {'status': false, 'message': ''};

    if (name.isEmpty || address.isEmpty || _tel.isEmpty) {
      errorHandler['message'] = 'None of the field should be empty';
      return errorHandler;
    } else if (name.length < 4) {
      errorHandler['message'] =
          'stylist name should not be less than 4 characters';
      return errorHandler;
    } else if (address.length > 25) {
      errorHandler['message'] =
          'saloon name should not be more than 20 characters';
      return errorHandler;
    } else if (_tel.trim().length != 10) {
      errorHandler['message'] = 'tel field should be only 10 integers';
      return errorHandler;
    } else {
      errorHandler['status'] = true;
      return errorHandler;
    }
  }
}
