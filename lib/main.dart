import 'package:admin_peka/ui/pages/dashboard.dart';
import 'package:admin_peka/ui/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'common/navigation.dart';
import 'common/styles.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyBZYkq51Nx3zy_gVToj1zkD6COOs9Eu7kE",
        authDomain: "peka-af325.firebaseapp.com",
        projectId: "peka-af325",
        storageBucket: "peka-af325.appspot.com",
        messagingSenderId: "1083252737459",
        appId: "1:1083252737459:web:7ad70b451c73b9a556b7c6",
        measurementId: "G-KX6LYZSGRM",
      ),
    );
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Admin PEKA',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: kWhiteBgColor,
        ),
        builder: FlutterSmartDialog.init(),
        navigatorKey: navigatorKey,
        initialRoute: LoginPage.routeName,
        routes: {
          Dashboard.routeName: (_) => const Dashboard(),
          LoginPage.routeName: (_) => const LoginPage(),
        },
        home: const Dashboard());
  }
}
