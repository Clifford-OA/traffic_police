import 'package:flutter/material.dart';
import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
// import 'package:traffic_police/screens/search_screen.dart';
import 'package:traffic_police/screens/vehicle_info.dart';

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
              color: Color(0xFF363f93),
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
                    "Welcome Inspector Chromo",
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
              onItemTapCallback: (index) => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => VehicleInformationScreen())),
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
                    _buildCard(0, Icons.search, 'Search'),
                    _buildCard(1, Icons.report, 'Report Violator'),
                    _buildCard(2, Icons.info, 'Detail'),
                    _buildCard(3, Icons.menu, 'Search'),
                    _buildCard(4, Icons.menu, 'Search')
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
