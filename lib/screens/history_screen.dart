import 'package:flutter/material.dart';
import 'package:traffic_police/screens/home_screen.dart';

class HistoryLogScreen extends StatefulWidget {
  const HistoryLogScreen({
    Key? key,
  }) : super(key: key);
  @override
  State<HistoryLogScreen> createState() => _HistoryLogScreenState();
}

class _HistoryLogScreenState extends State<HistoryLogScreen> {
  double kDefaultPadding = 10.0;
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
              ListView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemBuilder: ((context, index) {
                  return GestureDetector(
                      child: ListTile(
                        leading: Image.asset('assets/pol.jpeg'),
                        title:
                            const Text('Kumasi, Ayeduase \nStreet number 17'),
                        subtitle: const Text('Tap for more'),
                        trailing: const Text('¢ 20.00',
                            style: TextStyle(fontSize: 20)),
                      ),
                      onTap: () {});
                }),
                itemCount: 3,
                shrinkWrap: true,
              )
            ],
          ),
        ));
  }
}
