import 'package:flutter/material.dart';
import 'package:traffic_police/utils/Icon_model.dart';

import 'package:traffic_police/screens/history_screen.dart';
import 'package:traffic_police/screens/profile_screen.dart';
import 'package:traffic_police/screens/report_violator_screen.dart';
import 'package:traffic_police/screens/search_screen.dart';

class HomeScreenitem extends StatelessWidget {
  final IconModel iconModel;
  const HomeScreenitem({Key? key, required this.iconModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(6),
            ),
            child: GestureDetector(
              onTap: (() {
                switch (iconModel.id) {
                  case 1:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchScreen()));
                    break;
                  case 2:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReportViolatorScreen()));
                    
                    break;
                  case 3:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HistoryLogScreen()));
                    
                    break;
                  case 4:
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileScreen()));
                    
                    break;
                  // default:
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //           builder: (context) => ProfileScreen()));
                    
                  //   break;
                }
              }),
              child: Card(
                margin: const EdgeInsets.all(10),
                child: Hero(
                  tag: "${iconModel.id}",
                  child: Image.asset(iconModel.image),
                ),
              ),
            ),
          ),
        ),
        Text(
          iconModel.title,
          style: const TextStyle(
              color: Color.fromARGB(255, 4, 2, 2), fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}
