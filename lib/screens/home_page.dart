import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_counsellor/controller/commons.dart';
import 'package:the_counsellor/controller/constants.dart';
import 'package:the_counsellor/screens/complaints/complaints.dart';
import 'package:the_counsellor/screens/complaints/components/components.dart';

class HomePage extends StatefulWidget {
  static const String id = 'home_page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  QueryDocumentSnapshot user;
  List<QueryDocumentSnapshot> allComplaints;
  int messageCount;

  final List<String> imgList = [
    'https://wishesmessages.com/wp-content/uploads/2014/02/I-need-help-inspirational-quote-about-life.jpg',
    'https://www.wishesmsg.com/wp-content/uploads/motivational-quotes-for-students-studying.jpg',
    'https://www.wishesmsg.com/wp-content/uploads/encouraging-words-for-students-from-teachers.jpg',
    'https://www.wishesmsg.com/wp-content/uploads/motivational-quotes-for-students-success.jpg',
    'https://pbs.twimg.com/media/Evl-v5dXEAILHpk?format=jpg&name=large',
    'https://images.unsplash.com/photo-1494883759339-0b042055a4ee?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1567&q=80'
  ];

  @override
  void initState() {
    Commons.getMessageCount().then((value) {
      messageCount = value;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    TextTheme textTheme = Theme.of(context).textTheme;

    Map args = ModalRoute.of(context).settings.arguments;
    user = args['user'];

    Stream collectionStream = FirebaseFirestore.instance
        .collection('complaints')
        .where('uid', isEqualTo: user?.data()['uid'] ?? '')
        .orderBy('createdAt', descending: true)
        .snapshots();

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.network(
                          item,
                          fit: BoxFit.cover,
                          width: deviceWidth,
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(200, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                          ),
                        ),
                      ],
                    )),
              ),
            ))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('The Counsellor'),
//        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
            icon: Stack(
              children: [
                Icon(Icons.notifications),
                messageCount != 0
                    ? Positioned(
                        right: 0,
                        top: 5,
                        child: Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.redAccent),
                        ),
                      )
                    : SizedBox.shrink()
              ],
            ),
            onPressed: () {
              Commons.clearMessageCounter();
              Navigator.pushNamed(
                context,
                AllComplaints.id,
                arguments: args,
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
//              Text('Hello! ${user != null ? user.data()['name'] : ''}'),
              SizedBox(height: deviceHeight * 0.01),
              Text(
                'Hello,',
                style: textTheme.subtitle1,
              ),
              SizedBox(height: deviceHeight * 0.01),
              Text.rich(
                TextSpan(text: '', style: textTheme.subtitle1, children: [
                  TextSpan(
                    text: '${user != null ? user.data()['name'] : ''}',
                    style: textTheme.headline4.copyWith(
                      color: Color(0xff3a3a3a),
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ]),
              ),
              SizedBox(height: deviceHeight * 0.03),
              Container(
                width: deviceWidth,
                alignment: Alignment.center,
                child: FlatButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      LogComplaints.id,
                      arguments: {'user': user},
                    );
                  },
                  child: Text(
                    'Create new complaint',
                    style: textTheme.subtitle1.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  color: kAccentColor,
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth * 0.158,
                      vertical: deviceHeight * 0.018),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              SizedBox(height: deviceHeight * 0.03),
              AspectRatio(
                  aspectRatio: 1.6,
//                child: Container(
//                  decoration: BoxDecoration(
//                      color: Colors.grey,
//                      borderRadius: BorderRadius.circular(20)),
//                ),
                  child: CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: true,
                      aspectRatio: 2.0,
                      enlargeCenterPage: true,
                    ),
                    items: imageSliders,
                  )),

//              Container(
//                decoration: BoxDecoration(
//                    color: Colors.blue.shade100,
//                    borderRadius: BorderRadius.circular(10)),
//                padding: const EdgeInsets.symmetric(vertical: 10),
//                child: ListTile(
//                  onTap: () {
//                    Navigator.pushNamed(
//                      context,
//                      LogComplaints.id,
//                      arguments: {'user': user},
//                    );
//                  },
//                  title: Text('What\'s on your mind?\nWe are glad to help'),
//                  trailing: Container(
//                      decoration: BoxDecoration(
//                        shape: BoxShape.circle,
//                        color: Colors.blue,
//                      ),
//                      padding: const EdgeInsets.all(8),
//                      child: Icon(
//                        Icons.edit,
//                        color: Colors.white,
//                      )),
//                ),
//              ),
              SizedBox(height: deviceHeight * 0.03),

              StreamBuilder<QuerySnapshot>(
                stream: collectionStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return AspectRatio(
                      aspectRatio: 2,
                      child: Center(
                          child: Text(
                        'Something went wrong... Please Try Again',
                      )),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return AspectRatio(
                        aspectRatio: 2,
                        child: Text("Preparing your data... Please Wait"));
                  }

                  allComplaints = snapshot.data.docs;


                  if (allComplaints.isNotEmpty)
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Recent Whispers',
                              style: textTheme.subtitle1.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            OutlineButton(
                                onPressed: () {
//                                  Navigator.pushNamed(
//                                    context,
//                                    AllComplaints.id,
//                                    arguments: {'complaints': allComplaints},
//                                  );
                                  Navigator.pushNamed(
                                    context,
                                    AllComplaints.id,
                                    arguments: args,
                                  );
                                },
                                child: Text(
                                  'See All >>',
                                  style: TextStyle(color: kPrimaryColor),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                borderSide:
                                    BorderSide(color: kPrimaryColor, width: 1))
                          ],
                        ),
                        SizedBox(height: deviceHeight * 0.01),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: allComplaints.length > 5
                              ? 5
                              : allComplaints.length,
                          itemBuilder: (context, index) {
                            return ComplaintTile(
                              data: allComplaints[index],
                            );
                          },
                        ),
                      ],
                    );
                  else
                    return AspectRatio(
                      aspectRatio: 2,
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          'You have no complaints',
                          style: textTheme.headline6.copyWith(
                            color: Color(0xFF3a3a3a),
                          ),
                        ),
                      ),
                    );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
