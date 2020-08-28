import 'package:flutter/material.dart';
import 'package:gafgaff/Views/splash.dart';
import 'package:provider/provider.dart';

import 'StateManagement/messageRequestState.dart';
import 'StateManagement/messageState.dart';
import 'StateManagement/notificationState.dart';
import 'StateManagement/uploadImage.dart';
import 'StateManagement/bodyPage.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MessageState>(
          create: (_) => MessageState(),
        ),
        ChangeNotifierProvider<NotificationState>(
          create: (_) => NotificationState(),
        ),
        ChangeNotifierProvider<MessageRequestState>(
          create: (_) => MessageRequestState(),
        ),
        ChangeNotifierProvider<UploadImage>(
          create: (_) => UploadImage(),
        ),
        ChangeNotifierProvider<BodyPage>(
          create: (_) => BodyPage(),
        ),
      ],
      child: MaterialApp(
        title: 'Gaf-Gaff',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashView(),
      ),
    );
  }
}
