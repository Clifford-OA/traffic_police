import 'package:flutter/material.dart';

class ChallanCard extends StatelessWidget {
  final service;
  const ChallanCard(this.service,{Key? key}) : super(key: key);
  


  @override
  Widget build(BuildContext context) {
    String challanId = service['fineId'];
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(10),
      // height: MediaQuery.of(context).size.height / 4,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 7,
          )
        ],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              'Challan ID: #$challanId',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.all(15),
                  padding: EdgeInsets.only(right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Challan Date',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Text(
                        '19 Nov, 20',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Payment Date',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Text(
                        '19 Nov, 20',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Text(
                        service['status'] ? 'Paid' : 'Not Paid',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Amount',
                        style: TextStyle(color: Colors.grey.shade400),
                      ),
                      Text(
                        service['amount'],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
