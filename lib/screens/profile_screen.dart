import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: Icon(FontAwesomeIcons.pen),
              onTap: () => print('edit button clicked'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(30.0),
              child: CircleAvatar(
                radius: 90,
                backgroundImage: AssetImage('assets/police.png'),
              ),
            ),
            ListTile(leading: Text('Name:'), title: Text('Felix Gyabaa')),
            Divider(),
            ListTile(leading: Text('Tel:'), title: Text('0247336972')),
            Divider(),
            ListTile(leading: Text('Check Point:'), title: Text('Ayeduase')),
            Divider(),
            ListTile(
                leading: Text('Email:'),
                title: Text('gyabaafelix01@gmail.com')),
            Divider(),
            ListTile(
                leading: Text('Address:'),
                title: Text('ND 73/S New Dormaa, Sunyani')),
            Divider()
          ],
        ),
      ),
    );
  }
}
