import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_counsellor/controller/commons.dart';
import 'package:the_counsellor/controller/constants.dart';

class LogComplaints extends StatefulWidget {
  static const String id = 'log_complaints';

  @override
  _LogComplaintsState createState() => _LogComplaintsState();
}

class _LogComplaintsState extends State<LogComplaints> {
  CollectionReference complaints =
      FirebaseFirestore.instance.collection('complaints');

  List<QueryDocumentSnapshot> counsellors = [];

  bool _isLoading = false;

  QueryDocumentSnapshot user;

  String selectedCategory;
  bool isWaiting = true;
  String bodyText = '';
  String subjectText = '';
  List<String> priorityList = ['Low', 'Moderate', 'High'];

  final _formKey = GlobalKey<FormState>();

  final FocusNode fnOne = FocusNode();
  final FocusNode fnTwo = FocusNode();

  DropdownButtonFormField<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String category in priorityList) {
      var newItem = DropdownMenuItem(
        child: Text(category),
        value: category,
      );

      dropDownItems.add(newItem);
    }

    return DropdownButtonFormField<String>(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 42,
        isExpanded: true,
        value: selectedCategory,
        items: dropDownItems,
        hint: Text('Select Priority'),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please select a priority';
          }
          return null;
        },
        onChanged: (value) {
          setState(() {
            selectedCategory = value;
            //  getData();
          });
        });
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String category in priorityList) {
      pickerItems.add(Text(category));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        selectedCategory = priorityList[selectedIndex];
      },
      children: pickerItems,
    );
  }

  final button = Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: Colors.blue.shade50,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: Offset(14, 5),
          blurRadius: 20,
          color: Color(0xffaaaaaa).withOpacity(0.15),
        )
      ],
    ),
    //
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Submit',
          style: TextStyle(color: kPrimaryColor),
        ),
        Icon(
          Icons.send_outlined,
          color: kPrimaryColor,
          size: 15,
        ),
      ],
    ),
  );

  Future<void> addComplaint(String uid, String token, String phone) async {
    return complaints.add({
      'subject': subjectText,
      'priority': selectedCategory,
      'message': bodyText,
      'createdAt': DateTime.now(),
      'phone': phone,
      'status': 'Pending',
      'uid': uid,
      'token': token
    }).then((value) {
      setState(() {
        _isLoading = false;
      });
      print("Complaint Added well well");
      Commons.showFeedBackCustomDialog(context, false);
    }).catchError((error) {
      setState(() {
        _isLoading = false;
      });
      Commons.showFeedBackCustomDialog(context, true);
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;
    TextTheme textTheme = Theme.of(context).textTheme;

    Map args = ModalRoute.of(context).settings.arguments;
    user = args['user'];

    return Scaffold(
      appBar: AppBar(
        title: FittedBox(
          child: Text(
            'Talk to us',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        actions: [
          InkWell(
            child: button,
            onTap: () async {
              String token = await FirebaseMessaging.instance.getToken();

              if (_formKey.currentState.validate()) {
                setState(() {
                  _isLoading = true;
                });
                addComplaint(user.data()['uid'], token, user.data()['phone']);

                for (QueryDocumentSnapshot counsel in counsellors) {
                  Commons.sendMessage(
                    counsel.data()['token'],
                    'A student has whispered',
                    '${FirebaseAuth.instance.currentUser.uid}',
                  );
                }
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
//              height: deviceHeight * 0.28,
              aspectRatio: 1.8,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/take_complaint.gif'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            SizedBox(height: deviceHeight * 0.02),
            !_isLoading
                ? Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          width: deviceWidth,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: Platform.isMacOS
                              ? iOSPicker()
                              : androidDropdown(),
                        ),
                        SizedBox(height: deviceHeight * 0.02),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please add a subject to this complaint';
                              }
                              return null;
                            },
                            focusNode: fnOne,
                            onFieldSubmitted: (term) {
                              fnOne.unfocus();
                              FocusScope.of(context).requestFocus(fnTwo);
                            },
                            minLines: 1,
                            maxLines: 2,
                            textInputAction: TextInputAction.next,
                            decoration: InputDecoration(
                              hintText: 'Enter Subject',
                              border: InputBorder.none,
                            ),
                            onChanged: (v) => subjectText = v,
                          ),
                        ),
                        SizedBox(height: deviceHeight * 0.02),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          child: TextFormField(
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please a subject to this complaint';
                              }
                              return null;
                            },
                            focusNode: fnTwo,
                            textInputAction: TextInputAction.done,
                            minLines: 10,
                            maxLines: 10,
                            decoration: InputDecoration(
                              hintText: 'Enter your complaint',
                              border: InputBorder.none,
                            ),
                            onChanged: (v) => bodyText = v,
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(
                    child: Text(
                      'Sending your whisper...\nPlease Wait!',
                      style: textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
            SizedBox(height: deviceHeight * 0.02),
          ],
        ),
      ),
    );
  }

  fetchData() {
    FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'counsellor')
        .get()
        .then((admin) {
      counsellors = admin.docs;
    });
  }
}
