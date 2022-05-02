import 'package:flutter/material.dart';

class VehicleInformationScreen extends StatefulWidget {
  const VehicleInformationScreen({Key? key}) : super(key: key);

  @override
  State<VehicleInformationScreen> createState() =>
      _VehicleInformationScreenState();
}

class _VehicleInformationScreenState extends State<VehicleInformationScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text('Vehicle Information'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height,
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.3),
                    height: 450,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        )),
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
                                'Registration number',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'DL9cx8656',
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
                            borderRadius: BorderRadius.all(Radius.circular(24)),
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
            )
          ],
        ),
      ),
    );
  }
}
