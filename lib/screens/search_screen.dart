import 'package:flutter/material.dart';
import 'package:traffic_police/screens/vehicle_info.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _vehicleNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Search vehicle'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 200,
              padding: EdgeInsets.only(top: 20),
              child: Image.asset('assets/police.png'),
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Welcome to Ghana Traffic Police, Challan system',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
            ),
            Text(
              'the supervision of road users compliance, with the traffic legislation, and punishment for non-compliance.',
              style: TextStyle(
                fontSize: 17,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Please insert Vehicle no. below',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.blue),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _vehicleNumberController,
                          // keyboardType: TextInputType.,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            // border: OutlineInputBorder(),
                            hintText: 'GJ01XXX1234',
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      VehicleInformationScreen(
                                          _vehicleNumberController.text
                                              .trim())));
                        },
                        child: Text('Go!'),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white)),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
