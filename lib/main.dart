import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:the_counsellor/controller/commons.dart';
import 'package:the_counsellor/controller/constants.dart';
import 'package:the_counsellor/routes/route.dart';
import 'package:the_counsellor/screens/complaints/all_complaints.dart';
import 'package:the_counsellor/screens/getting_started/getting_started.dart';

final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp().then((value) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
//
//  CallerService _callerService = CallerService();

  @override
  void initState() {
    super.initState();
    notificationHandler();
  }

  void notificationHandler() async {
//    RemoteMessage initialMessage =
//        await FirebaseMessaging.instance.getInitialMessage();

//    // Also handle any interaction when the app is in the background via a
//    // Stream listener
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('On message Opened app');
      Commons.clearMessageCounter();
      navigatorKey.currentState.pushNamed(AllComplaints.id);
    });

    FirebaseMessaging.onBackgroundMessage((RemoteMessage message) async {
//      Map<String, dynamic> data = message.data;
      Commons.incrementMessageCounter();
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) async {
//      Map<String, dynamic> data = remoteMessage.data;
      Commons.incrementMessageCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    //For setting build context in the CallerService class
//    _callerService..context = context;

    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'The Counsellor',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Kumbh Sans',
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: kPrimaryColor,
        ),
      ),
      initialRoute: SignUp.id,
      routes: Routes.myRoutes(),
    );
  }
}
