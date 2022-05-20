import 'package:flutter/material.dart';

class ReportViolatorScreen extends StatefulWidget {
  const ReportViolatorScreen({Key? key}) : super(key: key);

  @override
  _ReportViolatorScreenState createState() => _ReportViolatorScreenState();
}

class _ReportViolatorScreenState extends State<ReportViolatorScreen> {
  final TextEditingController _vehicleNumber = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _amount = TextEditingController();

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
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    colorFilter:
                        ColorFilter.mode(Colors.black26, BlendMode.darken),
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
                          onPressed: () {},
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
                  obscureText: false,
                  controller: _description,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Description',
                  ),
                  maxLines: 5,
                  minLines: 1,
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
              // Row(
              //   children: <Widget>[
              //     Padding(
              //       padding: const EdgeInsets.all(10),
              //       child: SizedBox(
              //         width: 250.0,
              //         child: TextFormField(
              //           textCapitalization: TextCapitalization.characters,
              //           controller: _vehicleNumber,
              //           decoration: const InputDecoration(
              //             border: OutlineInputBorder(),
              //             labelText: 'Vehicle Number',
              //           ),
              //         ),
              //       ),
              //     ),
              //     InkWell(
              //       child: Container(
              //         decoration: BoxDecoration(
              //             shape: BoxShape.circle,
              //             border: Border.all(color: Colors.black)),
              //         child: const Icon(
              //           Icons.add,
              //           color: Colors.black,
              //         ),
              //       ),
              //     )
              //   ],
              // ),

              Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                    //Sign Up Button
                    child: const Text('Report'),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.white,
                    ),
                    onPressed: () {}),
              ),
            ],
          ),
        ));
  }
}
