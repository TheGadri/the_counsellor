import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:the_counsellor/controller/constants.dart';
import 'package:the_counsellor/screens/complaints/complaint_detail.dart';

class ComplaintTile extends StatelessWidget {
  final QueryDocumentSnapshot data;
  final bool isOnTap;

  const ComplaintTile({
    Key key,
    this.data,
    this.isOnTap = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final DateTime messageCreatedAt = Timestamp(
            data.data()['createdAt'].seconds,
            data.data()['createdAt'].nanoseconds)
        .toDate();

    String time = DateFormat.MMMEd().format(messageCreatedAt);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: isOnTap
            ? () {
                Navigator.pushNamed(context, ComplaintDetail.id,
                    arguments: {'data': data});
              }
            : null,
        title: Text(
          data.data()['subject'] ?? '',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        isThreeLine: !isOnTap,
        subtitle: isOnTap
            ? Text(
                data.data()['message'] ?? '',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            : Text.rich(
                TextSpan(
                    text: '\n${data.data()['message'] ?? ''}\n\n',
                    children: [
                      TextSpan(
                        text: 'Priority: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: '${data.data()['priority'] ?? ''}\n'),
                        ],
                      ),
                      TextSpan(
                        text: 'Status: ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                        children: [
                          TextSpan(text: data.data()['status'] ?? ''),
                        ],
                      ),
                    ]),
              ),
        trailing: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                ),
              ),
              SizedBox(
                width: 50,
                height: 22,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Image.asset(
                        setPriority(data.data()['priority']),
                        height: 22,
                        width: 22,
                      ),
                    ),
                    Container(
                      child: Image.asset(
                        setPriority(data.data()['status']),
                        height: 22,
                        width: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String setPriority(String priority) {
    switch (priority) {
      case 'Low':
        return 'assets/images/low_priority.png';
      case 'Moderate':
        return 'assets/images/medium_priority.png';
      case 'High':
        return 'assets/images/high_priority.png';
      case 'Resolved':
        return 'assets/images/completed.png';
      default:
        return 'assets/images/pending.png';
    }
  }
}

class ResponseTile extends StatelessWidget {
  final String response;

  const ResponseTile({
    Key key,
    this.response = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        isThreeLine: true,
        trailing: Text(
          'From the Guardian',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(response),
      ),
    );
  }

  String setPriority(String priority) {
    switch (priority) {
      case 'Low':
        return 'assets/images/low_priority.png';
      case 'Moderate':
        return 'assets/images/medium_priority.png';
      case 'High':
        return 'assets/images/high_priority.png';
      case 'Resolved':
        return 'assets/images/completed.png';
      default:
        return 'assets/images/pending.png';
    }
  }
}
