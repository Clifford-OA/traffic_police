import 'package:flutter/material.dart';
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
    final police = Provider.of<Police>(context, listen: true);
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
            // Container(
            //   padding: EdgeInsets.all(5.0),
            //   width: MediaQuery.of(context).size.width / 2,
            //   height: MediaQuery.of(context).size.width / 2,
            //   child: ClipRRect(
            //       borderRadius: BorderRadius.circular(100.0),
            //       child: FadeInImage.assetNetwork(
            //         placeholder: 'assets/no_picture.jpg',
            //         image: _policeInfo['imgUrl'],
            //         imageErrorBuilder: (context, error, stackTrace) {
            //           return Image.asset(
            //             'assets/no_picture.jpg',
            //           );
            //         },
            //         fit: BoxFit.cover,
            //       )),
            // ),
            SizedBox(
              height: 50,
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
