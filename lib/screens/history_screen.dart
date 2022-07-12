import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/auth/auth.dart';
import 'package:traffic_police/screens/home_screen.dart';
import 'package:traffic_police/widgets/history_tile.dart';

class HistoryLogScreen extends StatefulWidget {
  const HistoryLogScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<HistoryLogScreen> createState() => _HistoryLogScreenState();
}

class _HistoryLogScreenState extends State<HistoryLogScreen> {
  double kDefaultPadding = 10.0;

  // Display booked list for you
  Future<Widget> _displayHistory(BuildContext context) async {
    final authClass = Provider.of<AuthClass>(context, listen: false);
    String userId = authClass.auth.currentUser!.uid;
    List<Widget> list = [
      SizedBox(height: 0.0),
    ];
    await FirebaseFirestore.instance
        .collection('fineList')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        List<dynamic> data = doc['finedList'];
        for (var i = 0; i < data.length; i++) {
          if (data[i]['tid'] == userId) {
            list.add(HistoryTile(data[i]));
          }
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
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()))),
          title: const Text('History'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              FutureBuilder<Widget>(
                  future: _displayHistory(context),
                  builder: (BuildContext context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return snapshot.data as Widget;
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
              // ListView.builder(
              //   scrollDirection: Axis.vertical,
              //   physics: const BouncingScrollPhysics(),
              //   itemBuilder: ((context, index) {
              //     return GestureDetector(
              //         child: ListTile(
              //           leading: Image.asset('assets/pol.jpeg'),
              //           title:
              //               const Text('Kumasi, Ayeduase \nStreet number 17'),
              //           subtitle: const Text('¢ 20.00'),
              //           trailing: const Text('status',
              //               style: TextStyle(fontSize: 20)),
              //         ),
              //         onTap: () {});
              //   }),
              //   itemCount: 3,
              //   shrinkWrap: true,
              // )
            ],
          ),
        ));
  }
}
