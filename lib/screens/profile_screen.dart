import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/auth/police.dart';
import 'package:traffic_police/screens/edit_profile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  double kDefaultPadding = 10.0;
  @override
  Widget build(BuildContext context) {
    final police = Provider.of<Police>(context, listen: false);
    Map<String, dynamic> _policeInfo = police.policeRef;
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: ((context) => EditUserProfile()))),
              icon: Icon(Icons.edit))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(30.0),
              child: CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage('assets/gh_police.jpg'),
              ),
            ),
            ListTile(leading: Text('Name:'), title: Text(_policeInfo['name'])),
            Divider(),
            ListTile(leading: Text('Tel:'), title: Text(_policeInfo['tel'])),
            Divider(),
            ListTile(
                leading: Text('Check Point:'),
                title: Text(_policeInfo['checkPoint'])),
            Divider(),
            ListTile(
                leading: Text('Email:'), title: Text(_policeInfo['email'])),
            Divider(),
            ListTile(
                leading: Text('Address:'), title: Text(_policeInfo['address'])),
            Divider()
          ],
        ),
      ),
    );
  }
}
