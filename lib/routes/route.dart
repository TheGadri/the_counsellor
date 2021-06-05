import 'package:flutter/material.dart';
import 'package:the_counsellor/screens/complaints/complaints.dart';
import 'package:the_counsellor/screens/getting_started/getting_started.dart';
import 'package:the_counsellor/screens/screens.dart';

class Routes {
  static Map<String, WidgetBuilder> myRoutes() {
    return {
      SignUp.id: (context) => SignUp(),
      HomePage.id: (context) => HomePage(),
      LogComplaints.id: (context) => LogComplaints(),
      AllComplaints.id: (context) => AllComplaints(),
      ComplaintDetail.id: (context) => ComplaintDetail(),
    };
  }
}
