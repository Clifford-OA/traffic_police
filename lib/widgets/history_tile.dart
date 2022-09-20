import 'package:flutter/material.dart';

class HistoryTile extends StatelessWidget {
  final service;
  HistoryTile(this.service);

  @override
  Widget build(BuildContext context) {
    String amount = service['fineId'];
    return Container(
      margin: EdgeInsets.only(bottom: 30),
      child: GestureDetector(
          child: ListTile(
            leading: Image.network(service['imgUrl']),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service['vehicleNumber'],
                  overflow: TextOverflow.ellipsis,
                ),
                 Text(
                  service['description'],
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            subtitle: Text('$amount', style: TextStyle(color: Colors.purple)),
            trailing: service['status']
                ? Text('Paid',
                    style: TextStyle(fontSize: 20, color: Colors.green))
                : Text('Not Paid',
                    style: TextStyle(fontSize: 20, color: Colors.red)),
          ),
          onTap: () {}),
    );
  }
}
