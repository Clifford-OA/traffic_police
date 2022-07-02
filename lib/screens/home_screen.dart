import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:provider/provider.dart';
import 'package:traffic_police/auth/auth.dart';
import 'package:traffic_police/auth/police.dart';
import 'package:traffic_police/screens/create_user_screen.dart';
import 'package:traffic_police/screens/history_screen.dart';
import 'package:traffic_police/screens/profile_screen.dart';
import 'package:traffic_police/screens/report_violator_screen.dart';
import 'package:traffic_police/screens/search_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late FixedExtentScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final police = Provider.of<Police>(context, listen: false);
    bool _admin = police.admin;
    String _name = police.name;
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 230,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50),
              ),
              color: Color(0xff1592ff),
            ),
            child: Stack(
              children: [
                Positioned(
                  top: 80,
                  left: 0,
                  child: Container(
                    height: 100,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 115,
                  left: 20,
                  child: Text(
                    "Hi $_name",
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF363f93),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: height * 0.05,
          ),
          Expanded(
            child: ClickableListWheelScrollView(
              scrollController: _controller,
              itemHeight: 200,
              itemCount: 5,
              onItemTapCallback: (index) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => index == 0
                          ? SearchScreen()
                          : index == 1
                              ? ReportViolatorScreen()
                              : index == 2
                                  ? HistoryLogScreen()
                                  : index == 3
                                      ? ProfileScreen()
                                      : CreateUserScreen())),
              child: ListWheelScrollView(
                  controller: _controller,
                  itemExtent: 200,
                  diameterRatio: 1.5,
                  physics: FixedExtentScrollPhysics(),
                  overAndUnderCenterOpacity: 0.5,
                  perspective: 0.002,
                  onSelectedItemChanged: (index) {
                    print("onSelectedItemChanged index: $index");
                  },
                  children: [
                    _buildCard(0, FontAwesomeIcons.searchengin, 'Search'),
                    _buildCard(
                        1, FontAwesomeIcons.addressCard, 'Report Violator'),
                    _buildCard(2, FontAwesomeIcons.clockRotateLeft, 'History'),
                    _buildCard(3, FontAwesomeIcons.user, 'Profile'),
                    _admin
                        ? _buildCard(4, FontAwesomeIcons.userPlus, 'Add User')
                        : Center(),
                  ]
                  // childDelegate: ListWheelChildBuilderDelegate(
                  //   builder: (context, index) => _buildCard(index: index),
                  //   childCount: 5,
                  // ),
                  ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCard(index, icon, title) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        color: Color(0xff1592ff),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50.0,
              color: Colors.white,
            ),
            SizedBox(height: 10.0),
            Text(
              title,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
