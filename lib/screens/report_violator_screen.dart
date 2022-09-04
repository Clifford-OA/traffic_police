import 'dart:io';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/utils/fetch_police_data.dart';
import 'package:traffic_police/utils/send_email.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';
import 'package:traffic_police/auth/auth.dart';
import 'package:traffic_police/auth/police.dart';
import 'package:traffic_police/screens/history_screen.dart';
import 'package:traffic_police/utils/get_image.dart';
import 'package:traffic_police/utils/validation.dart';
import 'package:traffic_police/utils/vehicleTextBox.dart';

class ReportViolatorScreen extends StatefulWidget {
  const ReportViolatorScreen({Key? key}) : super(key: key);

  @override
  _ReportViolatorScreenState createState() => _ReportViolatorScreenState();
}

class _ReportViolatorScreenState extends State<ReportViolatorScreen> {
  CollectionReference fineList =
      FirebaseFirestore.instance.collection('fineList');
  final GlobalKey<FormState> _vehicleNumberFormKey = GlobalKey();
  final TextEditingController _vehicleNumber = TextEditingController();
  final TextEditingController _vehicleRegion = TextEditingController();
  final TextEditingController _vehicleYear = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _amount = TextEditingController();

  late String _vehicleNumberText;

  var vehicleYearInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]')),
    FilteringTextInputFormatter.deny(RegExp('[]'))
  ];
  var vehicleRegionInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[A-Z]')),
  ];

  var vehicleNumberInputFormatter = [
    FilteringTextInputFormatter.allow(RegExp('[0-9]'))
  ];

  bool _loadImage = false;
  bool _isLoading = false;
  String imgUrl = '';

  GetImage _getImgRef = new GetImage();

  @override
  void initState() {
    // TODO: implement initState
    print(DateTime.now());
    setState(() {
      _vehicleRegion.clear();
      _vehicleNumber.clear();
      _vehicleYear.clear();
      _description.clear();
      _amount.clear();
    });
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
                child: _loadImage == false
                    ? Stack(
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
                      )
                    : Center(child: CircularProgressIndicator()),
              ),
              Form(
                  key: _vehicleNumberFormKey,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: SizedBox(
                                width: 100.0,
                                child: vehicleNumberformTextBox(
                                  Validation().regionValidation,
                                  null,
                                  TextInputType.text,
                                  _vehicleRegion,
                                  'Region\nCode',
                                  'AS',
                                  2,
                                  vehicleRegionInputFormatter,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
                              child: SizedBox(
                                width: 115.0,
                                child: vehicleNumberformTextBox(
                                  Validation().vehicleNumberValidation,
                                  null,
                                  TextInputType.number,
                                  _vehicleNumber,
                                  'Number',
                                  '1234',
                                  4,
                                  vehicleNumberInputFormatter,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                              child: SizedBox(
                                width: 100.0,
                                child: vehicleNumberformTextBox(
                                  Validation().yearValidation,
                                  null,
                                  TextInputType.number,
                                  _vehicleYear,
                                  'Year',
                                  '22',
                                  2,
                                  vehicleYearInputFormatter,
                                ),
                              ),
                            ),
                          ],
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
                        child: _isLoading == false
                            ? ElevatedButton(
                                child: const Text('Report'),
                                style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.white,
                                ),
                                onPressed: _validateAndBook,
                              )
                            : Center(
                                child: CircularProgressIndicator(),
                              ),
                      ),
                    ],
                  ))
            ],
          ),
        ));
  }

  Future _getImage() async {
    setState(() {
      _loadImage = true;
    });
    var imageUrl = await _getImgRef.getImage();
    setState(() {
      imgUrl = imageUrl;
    });
    setState(() {
      _loadImage = false;
    });
  }

  void _validateAndBook() {
    if (_vehicleNumberFormKey.currentState!.validate()) {
      _vehicleNumberText =
          '${_vehicleRegion.text}-${_vehicleNumber.text}-${_vehicleYear.text}';
      final errorResult = _validate();
      if (errorResult['status']) {
        setState(() {
          _isLoading = true;
        });
        _addToFineList();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(errorResult['message'])));
      }
    }
  }

  Future<void> _addToFineList() async {
    List fineItem = [];
    String vehiNumber = _vehicleNumberText.trim();
    final docId = '$vehiNumber';
    CollectionReference civilian =
        FirebaseFirestore.instance.collection('civilian');
    late Map<String, dynamic> returnData;
    await civilian.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> vehicles = data['vehicleNumber'];
        for (var i = 0; i < vehicles.length; i++) {
          if (vehicles[i] == vehiNumber) {
            returnData = data;
            break;
          }
        }
      });
    });
    List<String> ids = [];
    fineItem.add(toMap());
    await FirebaseFirestore.instance
        .collection('fineList')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        ids.add(doc.id);
      });
    });
    if (ids.contains(docId)) {
      await fineList
          .doc(docId)
          .update({'finedList': FieldValue.arrayUnion(fineItem)}).then((value) async {
        print('Fine updated');
        setState(() {
          _isLoading = false;
        });
        print(returnData);
        // _addToBookDateList();
        await SendEmailClass().sendEmail(
            toEmail: returnData['email'],
            description: _description.text,
            fineAmount: _amount.text,
            toName: returnData['name']);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HistoryLogScreen()));
      }).catchError((error) {
        print("Failed to update fine: $error");
      });
    } else {
      await fineList
          .doc(docId)
          .set({'finedList': FieldValue.arrayUnion(fineItem)}).then((value) {
        print('Fine created');
        setState(() {
          _isLoading = false;
        });
        // _addToBookDateList();
        SendEmailClass().sendEmail(
            toEmail: returnData['email'],
            description: _description.text,
            fineAmount: _amount.text,
            toName: returnData['name']);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HistoryLogScreen()));
      }).catchError((error) {
        print("Failed to create fine: $error");
      });
    }
  }

  Map<String, dynamic> toMap() {
    final authClass = Provider.of<AuthClass>(context, listen: false);
    final tid = authClass.auth.currentUser!.uid;
    var uuid = Uuid();

    return {
      'vehicleNumber': _vehicleNumber.text.toUpperCase(),
      'amount': _amount.text,
      'description': _description.text,
      'imgUrl': imgUrl,
      'fineId': uuid.v4(),
      'fine_date': DateTime.now(),
      'paid_date': '',
      'status': false,
      'tid': tid,
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
    } else if (_vehicleNumberText.isEmpty || _vehicleNumberText.length < 4) {
      errorHandler['message'] =
          'Please license number should not be empty and should be greater than 3 characters';
      return errorHandler;
    } else {
      errorHandler['status'] = true;
      return errorHandler;
    }
  }
}
