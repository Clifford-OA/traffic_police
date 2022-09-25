import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FineDetailScreen extends StatefulWidget {
  final dynamic fineHistoryDetails;
  const FineDetailScreen({
    this.fineHistoryDetails,
    Key? key,
  }) : super(key: key);
  @override
  State<FineDetailScreen> createState() => _FineDetailScreenState();
}

class _FineDetailScreenState extends State<FineDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Timestamp timestamp = widget.fineHistoryDetails['fine_date'];
    final challanDate = timestamp.toDate();
    final fineDate = challanDate.toString().split(' ')[0];
    String paidDate = '';

    if (widget.fineHistoryDetails['paid_date'].toString().isNotEmpty) {
      Timestamp timestamp = widget.fineHistoryDetails['paid_date'];
      final challanPaidDate = timestamp.toDate();
      paidDate = challanPaidDate.toString().split(' ')[0];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Fine Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 50),
        child: SingleChildScrollView(
          child: Column(
            children: [
              fineDetailsCard('Fine ID:', widget.fineHistoryDetails['fineId']),
              fineDetailsCard('Vehicle Number:',
                  widget.fineHistoryDetails['vehicleNumber']),
              fineDetailsCard('Issued Date:', '$fineDate'),
              fineDetailsCard(
                'Payment Date:',
                paidDate.isNotEmpty ? '$paidDate' : '',
              ),
              fineDetailsCard('Amount: ', widget.fineHistoryDetails['amount']),
              Card(
                margin: const EdgeInsets.all(5),
                child: ListTile(
                  leading: Text('Payment Status'),
                  title: Text(
                    widget.fineHistoryDetails['status'] ? 'Paid' : 'Not Paid',
                    style: TextStyle(
                        color: widget.fineHistoryDetails['status']
                            ? Colors.green
                            : Colors.red,
                        fontSize: 20),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.all(15),
                child: Column(
                  children: [
                    const Center(
                      child: Text(
                        'Description',
                        style: TextStyle(color: Colors.black, fontSize: 24),
                      ),
                    ),
                    const Divider(thickness: 2),
                    Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(widget.fineHistoryDetails['description'],
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18))),
                  ],
                ),
              ),
              Card(
                margin: const EdgeInsets.all(15),
                child: FadeInImage.assetNetwork(
                    placeholder: 'assets/loading_icon.gif',
                    image: widget.fineHistoryDetails['imgUrl'],
                    imageErrorBuilder: ((context, error, stackTrace) =>
                        Image.asset('assets/loading_icon.gif'))),
              ),
              // fineDetailsCard('Officer ID:', widget.fineHistoryDetails['tid']),
            ],
          ),
        ),
      ),
    );
  }

  fineDetailsCard(title, value) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: ListTile(
        leading: Text(title),
        title: Text(
          value,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
