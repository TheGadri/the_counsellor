import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_counsellor/screens/complaints/components/components.dart';

class AllComplaints extends StatelessWidget {
  static const String id = 'all_complaints';

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    QueryDocumentSnapshot user = args['user'];

    Stream collectionStream = FirebaseFirestore.instance
        .collection('complaints')
        .where('uid', isEqualTo: user.data()['uid'])
        .orderBy('createdAt', descending: true)
        .snapshots();

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
//          backgroundColor: kPrimaryColor,
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'LOW'),
              Tab(text: 'MODERATE'),
              Tab(text: 'HIGH'),
              Tab(text: 'RESOLVED'),
            ],
          ),
          title: Text('Whispers'),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: collectionStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                  child: Text(
                'Something went wrong... Please Try Again',
              ));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Preparing your data... Please Wait");
            }

            List<QueryDocumentSnapshot> allComplaints;
            allComplaints = snapshot.data.docs;
            // allComplaints = args['complaints'];

            List<QueryDocumentSnapshot> lowComplaints = allComplaints
                .where((element) =>
                    element.data()['priority'] == 'Low' &&
                    element.data()['status'] == 'Pending')
                .toList();

            List<QueryDocumentSnapshot> moderateComplaints = allComplaints
                .where((element) => element.data()['priority'] == 'Moderate' &&
                    element.data()['status'] == 'Pending')
                .toList();

            List<QueryDocumentSnapshot> highComplaints = allComplaints
                .where((element) => element.data()['priority'] == 'High' &&
                    element.data()['status'] == 'Pending')
                .toList();

            List<QueryDocumentSnapshot> resolvedComplaints = allComplaints
                .where((element) => element.data()['status'] == 'Resolved')
                .toList();
            return TabBarView(
              children: [
                Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: lowComplaints.length,
                    itemBuilder: (context, index) {
                      return ComplaintTile(
                        data: lowComplaints[index],
                      );
                    },
                  ),
                ),
                Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: moderateComplaints.length,
                    itemBuilder: (context, index) {
                      return ComplaintTile(
                        data: moderateComplaints[index],
                      );
                    },
                  ),
                ),
                Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: highComplaints.length,
                    itemBuilder: (context, index) {
                      return ComplaintTile(
                        data: highComplaints[index],
                      );
                    },
                  ),
                ),
                Container(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: resolvedComplaints.length,
                    itemBuilder: (context, index) {
                      return ComplaintTile(
                        data: resolvedComplaints[index],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

//
//TabBarView(
//children: [
//Container(
//child: ListView.builder(
//padding: const EdgeInsets.all(15),
//shrinkWrap: true,
//physics: NeverScrollableScrollPhysics(),
//itemCount: lowComplaints.length,
//itemBuilder: (context, index) {
//return ComplaintTile(
//data: lowComplaints[index],
//);
//},
//),
//),
//Container(
//child: ListView.builder(
//padding: const EdgeInsets.all(15),
//shrinkWrap: true,
//physics: NeverScrollableScrollPhysics(),
//itemCount: moderateComplaints.length,
//itemBuilder: (context, index) {
//return ComplaintTile(
//data: moderateComplaints[index],
//);
//},
//),
//),
//Container(
//child: ListView.builder(
//padding: const EdgeInsets.all(15),
//shrinkWrap: true,
//physics: NeverScrollableScrollPhysics(),
//itemCount: highComplaints.length,
//itemBuilder: (context, index) {
//return ComplaintTile(
//data: highComplaints[index],
//);
//},
//),
//),
//Container(
//child: ListView.builder(
//padding: const EdgeInsets.all(15),
//shrinkWrap: true,
//physics: NeverScrollableScrollPhysics(),
//itemCount: resolvedComplaints.length,
//itemBuilder: (context, index) {
//return ComplaintTile(
//data: resolvedComplaints[index],
//);
//},
//),
//),
//],
//),
