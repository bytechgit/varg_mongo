import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moj_majstor/AppState.dart';
import 'package:moj_majstor/InsertLocation.dart';
import 'package:moj_majstor/InternetConnection.dart';
import 'package:moj_majstor/Login.dart';
import 'package:moj_majstor/filter.dart';
import 'package:moj_majstor/home.dart';
import 'package:moj_majstor/messageControler.dart';
import 'package:moj_majstor/proba.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:provider/provider.dart';
import 'package:moj_majstor/Notification.dart' as FCM;
import 'Authentication.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final filterController = Get.put(Filter());
  final messageController = Get.put(messageControler());
  final FCM.Notification _notification = FCM.Notification();
  final InternetConnection _connection = InternetConnection();
  //AppState as = AppState();
  //await as.ProcitajMajstori();
  //await as.ProcitajMajstori();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => UserAuthentication()),
    ChangeNotifierProvider(create: (context) => AppState()),
    // Provider(create: (context) => SomeOtherClass()),
  ], child: const Home()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        home: const MyHomePage(
          title: 'Moj majstor',
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Drawer Header'),
            ),
            ListTile(
              title: const Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const Login();
                  }),
                );
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: const Text('Item 2'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const proba();
                }));
              },
            ),
            ListTile(
              title: const Text('lokacija 2'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return InsertLocation(
                    callback: (val) {},
                  );
                }));
              },
            ),
            ListTile(
              title: const Text('Push Notification'),
              onTap: () {},
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => {},
          )
        ],
      ),
      body: Center(),
    );
  }
}
