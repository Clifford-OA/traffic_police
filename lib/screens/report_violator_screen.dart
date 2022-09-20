import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/auth/police.dart';
import 'package:traffic_police/utils/send_email.dart';
import 'package:traffic_police/widgets/rounded_button.dart';
import 'package:uuid/uuid.dart';
import 'package:traffic_police/auth/auth.dart';
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
  // final TextEditingController _amount = TextEditingController();

  late String _vehicleNumberText;
  late io.File imageFile;
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
  bool _isLoadingImage = false;
  String imgUrl = '';

  GetImage _getImgRef = new GetImage();
  String fine_code = '';
  String selectedAmount = '';
  String selectedFineTitle = 'select title';
  // List<String> _fineAmounts = [
  //   'select one',
  //   '100',
  //   '150',
  //   '200',
  //   '250',
  //   '300',
  // ];

  List<String> fineTitle = ['select title'];
  List<dynamic> fineInfo = [];

  @override
  void initState() {
    final policeClass = Provider.of<Police>(context, listen: false);
    fineInfo = policeClass.fineInfo;
    print(fineInfo);
    fineInfo.forEach((fine) => {fineTitle.add(fine['title'])});

    // TODO: implement initState
    print(DateTime.now());
    setState(() {
      _vehicleRegion.clear();
      _vehicleNumber.clear();
      _vehicleYear.clear();
      _description.clear();
      // _amount.clear();
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
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                    ),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      colorFilter:
                          ColorFilter.mode(Colors.black26, BlendMode.darken),
                      image: AssetImage('assets/police.png'),
                    ),
                    color: Color(0xff1592ff),
                  ),
                  child: _isLoadingImage == false
                      ? Stack(
                          children: [
                            Positioned(
                              top: 170,
                              left: 300,
                              child: CircleAvatar(
                                backgroundColor: Colors.black54,
                                child: IconButton(
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                  ),
                                  onPressed: _getImage,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Image.file(
                          imageFile,
                          fit: BoxFit.cover,
                        )),
              Form(
                  key: _vehicleNumberFormKey,
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
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
                      // Container(
                      //   padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      //   child: TextField(
                      //     controller: _description,
                      //     decoration: const InputDecoration(
                      //       filled: true,
                      //       border: OutlineInputBorder(),
                      //       hintText: 'Description',
                      //     ),
                      //     maxLines: 3,
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width - 50,
                      //   child: DropdownButton(
                      //     value: selectedAmount,
                      //     items: _fineAmounts.map((String workingDay) {
                      //       return DropdownMenuItem(
                      //         value: workingDay,
                      //         child: Text(workingDay),
                      //       );
                      //     }).toList(),
                      //     hint: Text('Choose amount'),
                      //     dropdownColor: Colors.white,
                      //     icon: Icon(Icons.arrow_drop_down),
                      //     iconSize: 25,
                      //     isExpanded: true,
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 22,
                      //     ),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         selectedAmount = newValue!;
                      //       });
                      //     },
                      //   ),
                      // ),

                      SizedBox(
                        height: 50,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Title(
                            color: Colors.black,
                            child: Text(
                              'Title of fine',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 16),
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width - 50,
                            child: DropdownButton(
                              value: selectedFineTitle,
                              items: fineTitle.map((String title) {
                                return DropdownMenuItem(
                                  value: title,
                                  child: Text(title,
                                      style: TextStyle(fontSize: 17)),
                                );
                              }).toList(),
                              hint: Text('Choose title'),
                              dropdownColor: Colors.white,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 25,
                              isExpanded: true,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 22,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedFineTitle = newValue!;
                                });
                                for (var i in fineInfo) {
                                  if (i['title'] == newValue!) {
                                    selectedAmount = i['charge'];
                                    fine_code = i['fine_code'];
                                    break;
                                  }
                                }

                                // fineInfo.map((data) => {

                                // });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width - 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Title(
                                color: Colors.blue,
                                child: Text(
                                  'Fine Amount',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.blueGrey),
                                )),
                            ListTile(
                              leading: Text(
                                'Ghc $selectedAmount',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.orangeAccent),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                        child: _isLoading == false
                            ? RoundedButton(
                                buttonName: 'Report',
                                action: _validateAndBook,
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
    // print(_loadImage);
    print(_isLoadingImage);
    dynamic imageUrl = await _getImgRef.getImage();

    setState(() {
      imageFile = imageUrl;
      _isLoadingImage = true;
      // imgUrl = imageUrl.toString().split("'")[1];
    });
    setState(() {
      _loadImage = false;
    });
    imgUrl = await _getImgRef.imageToFireStorage();
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
    var uuid = Uuid();

    // List fineItem = [];
    String vehiNumber = _vehicleNumberText;
    final docId = uuid.v4().split('-')[0];
    CollectionReference civilian =
        FirebaseFirestore.instance.collection('civilian');
    late Map<String, dynamic> violatorData;

    // loadImage url
    // imgUrl = await _getImgRef.imageToFireStorage();

    await civilian.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        List<dynamic> vehicles = data['vehicles'];
        for (var i = 0; i < vehicles.length; i++) {
          if (vehicles[i] == vehiNumber) {
            violatorData = data;
            break;
          }
        }
      });
    });

    // fineItem.add(toMap(docId));
    await fineList.doc(docId).set(toMap(docId, violatorData)).then((value) {
      print('Fine created');
      setState(() {
        _isLoading = false;
      });
      // SendEmailClass().sendMail(
      //     context: context,
      //     toEmail: violatorData['email'],
      //     description: selectedFineTitle,
      //     fineAmount: selectedAmount,
      //     fineId: docId,
          // toName: violatorData['name']);
      // _addToBookDateList();
      // SendEmailClass().sendEmail(
      //     toEmail: violatorData['email'],
      //     description: _description.text,
      //     fineAmount: selectedAmount,
      //     toName: violatorData['name']);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HistoryLogScreen()));
    }).catchError((error) {
      print("Failed to create fine: $error");
    });
  }

  Map<String, dynamic> toMap(String fineId, violatorDetail) {
    final authClass = Provider.of<AuthClass>(context, listen: false);
    final tid = authClass.auth.currentUser!.uid;

    return {
      'vehicleNumber': _vehicleNumberText,
      'amount': selectedAmount,
      'description': selectedFineTitle,
      'fine_code': fine_code,
      'imgUrl': imgUrl,
      'fineId': fineId,
      'fine_date': DateTime.now(),
      'paid_date': '',
      'violator_email': violatorDetail['email'],
      'violator_name': violatorDetail['name'],
      'violator_tel': violatorDetail['phone'],
      'status': false,
      'tid': tid,
    };
  }

  _validate() {
    Map errorHandler = {'status': false, 'message': ''};
    if (selectedFineTitle == 'select title') {
      errorHandler['message'] = 'Title of road violation';
      return errorHandler;
    } else if (!_isLoadingImage) {
      errorHandler['message'] = 'Image should not be empty';
      return errorHandler;
    } else if (selectedAmount == '') {
      errorHandler['message'] = 'Select fine amount';
      return errorHandler;
    } else {
      errorHandler['status'] = true;
      return errorHandler;
    }
  }
}
