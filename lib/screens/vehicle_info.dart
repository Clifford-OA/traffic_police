import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:traffic_police/widgets/challan_card.dart';

class VehicleInformationScreen extends StatefulWidget {
  final vehicleNumber;
  const VehicleInformationScreen(this.vehicleNumber, {Key? key})
      : super(key: key);

  @override
  State<VehicleInformationScreen> createState() =>
      _VehicleInformationScreenState();
}

class _VehicleInformationScreenState extends State<VehicleInformationScreen> {
  Future<Widget> _displayVehicleInfo(
      BuildContext context, String vehicleNumber) async {
    List<Widget> list = [
      SizedBox(height: 0.0),
    ];
    await FirebaseFirestore.instance
        .collection('fineList')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (data['vehicleNumber'] == vehicleNumber) {
          list.add(ChallanCard(data));
        }
      });
    });
    return list.length > 1
        ? Column(
            children: list,
          )
        : Center(
            child: Text('Your history list is empty'),
          );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Vehicle Information'),
        elevation: 0,
      ),
      body: Container(
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: size.height * 0.3),
                      height: size.height / 1.7,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(15),
                            topRight: Radius.circular(15),
                          )),
                      child: ListView(
                        children: [
                          FutureBuilder<Widget>(
                              future: _displayVehicleInfo(
                                  context, widget.vehicleNumber),
                              builder: (BuildContext context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  if (snapshot.hasData) {
                                    return snapshot.data as Widget;
                                  }
                                }
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: 15, left: 15, bottom: 10, right: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: 30),
                            child: Column(
                              children: [
                                Text(
                                  'Vehicle number',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  widget.vehicleNumber,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'Last Updated',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text('3 June 2016',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                          Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(24)),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/gh_police.jpg',
                                  fit: BoxFit.fill,
                                ),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
