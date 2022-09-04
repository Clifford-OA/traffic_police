import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/auth/auth.dart';
import 'package:traffic_police/auth/police.dart';
import 'package:traffic_police/screens/login_screen.dart';
import 'package:traffic_police/utils/dialog_box.dart';

import 'package:traffic_police/widgets/home_screen_item.dart';
import '../utils/Icon_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<IconModel> homeIcons = [
    IconModel(id: 1, image: "assets/search.png", title: "Search"),
    IconModel(id: 2, image: "assets/report.png", title: "Report Violator"),
    IconModel(id: 3, image: "assets/history.png", title: "History"),
    IconModel(id: 4, image: "assets/info.png", title: "Profile"),
    IconModel(id: 5, image: "assets/add_user.png", title: "Create User")
  ];

  @override
  Widget build(BuildContext context) {
    final police = Provider.of<Police>(context, listen: false);
    bool _admin = police.admin;
    String _name = police.name;
    print(_name + " name");
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 250,
        leading: Image.asset(
          "assets/police.png",
        ),
        toolbarHeight: 150,
        elevation: 10,
        titleTextStyle: const TextStyle(
          color: Color.fromARGB(255, 248, 248, 248),
          fontSize: 24,
          fontStyle: FontStyle.italic,
        ),
        title: Text("Welcome\n$_name"),
      ),
      body: Padding(
          padding:
              const EdgeInsets.only(top: 30.0, bottom: 50, left: 10, right: 10),
          child: GridView.builder(
            itemCount: homeIcons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 50,
              crossAxisSpacing: 10,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, index) => HomeScreenitem(
              iconModel: homeIcons[index],
            ),
          )),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(70, 0, 70, 5),
          child: ElevatedButton(
            child: const Text('Sign Out'),
            onPressed: () {
              DialogBox().showLogOutDialogBox(context).then((value) => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => LoginScreen())))
                  });
              // AuthClass().signOut();
            },
          ),
        ),
      ),
    );
  }

  // Widget _buildCard(index, icon, title) {
  //   return Container(
  //     width: 200,
  //     decoration: BoxDecoration(
  //       borderRadius: BorderRadius.all(
  //         Radius.circular(50),
  //       ),
  //       color: Color(0xff1592ff),
  //     ),
  //     child: Center(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.center,
  //         children: [
  //           Icon(
  //             icon,
  //             size: 50.0,
  //             color: Colors.white,
  //           ),
  //           SizedBox(height: 10.0),
  //           Text(
  //             title,
  //             style: TextStyle(
  //               fontSize: 15,
  //               color: Colors.white70,
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

}
