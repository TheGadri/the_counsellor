import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_counsellor/controller/commons.dart';
import 'package:the_counsellor/screens/complaints/components/compliant_tile.dart';

class ComplaintDetail extends StatelessWidget {
  static const String id = 'complaint_detail';

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    Map args = ModalRoute.of(context).settings.arguments;

    QueryDocumentSnapshot data = args['data'];


    return Scaffold(
      appBar: AppBar(
        title: Text('Whisper Detail'),
        actions: [
          data.data()['status'] == 'Resolved'
              ? IconButton(
                  icon: Icon(Icons.call),
                  onPressed: () {
                    Commons.makePhoneCall(
                        'tel:${data.data()['counsellorPhone']}');
                  },
                )
              : SizedBox.shrink(),
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ComplaintTile(
              data: data,
              isOnTap: false,
            ),
//            Text.rich(
//              TextSpan(
//                text: 'Subject: ',
//                style:
//                    textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
//                children: [
//                  TextSpan(text: data.data()['subject'] ?? ''),
//                ],
//              ),
//            ),
//            SizedBox(height: deviceHeight * 0.01),
//            Text.rich(
//              TextSpan(
//                text: 'Priority: ',
//                style:
//                    textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
//                children: [
//                  TextSpan(text: data.data()['priority'] ?? ''),
//                ],
//              ),
//            ),
//            SizedBox(height: deviceHeight * 0.01),
//            Text.rich(
//              TextSpan(
//                text: 'Status: ',
//                style:
//                    textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
//                children: [
//                  TextSpan(text: data.data()['status'] ?? ''),
//                ],
//              ),
//            ),
//            SizedBox(height: deviceHeight * 0.01),
//            Text.rich(
//              TextSpan(
//                text: 'Date: ',
//                style:
//                    textTheme.subtitle1.copyWith(fontWeight: FontWeight.bold),
//                children: [
//                  TextSpan(text: messageCreatedAt.toString() ?? ''),
//                ],
//              ),
//            ),
//            SizedBox(height: deviceHeight * 0.03),
//            Text(data.data()['message'] ?? ''),
            SizedBox(height: deviceHeight * 0.03),
            data.data()['status'] == 'Resolved'
//                ? Container(
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.start,
//                      children: [
//                        Text(
//                          'From the Guardian',
//                          style: textTheme.subtitle1.copyWith(
//                            fontWeight: FontWeight.bold,
//                          ),
//                        ),
//                        SizedBox(height: deviceHeight * 0.01),
//                        Text(data.data()['resolveMessage'] ?? ''),
//                      ],
//                    ),
//                  )
//                : SizedBox.shrink()
                ? ResponseTile(
                    response: data.data()['resolveMessage'] ?? '',
                  )
                : SizedBox.shrink()
          ],
        ),
      ),
    );
  }
}
