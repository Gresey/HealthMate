// @dart=2.17
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:heathmate/firebase_options.dart';
import 'package:heathmate/screens/dashboard.dart';
import 'package:heathmate/screens/diet.dart';
import 'package:heathmate/screens/sleep.dart';
import 'package:heathmate/screens/splashscreen.dart';
import 'package:heathmate/screens/steps.dart';
import 'package:heathmate/screens/water.dart';
import 'package:heathmate/widgets/dietchart.dart';
import 'package:heathmate/widgets/stepschart.dart';

Future<void> main() async {
 
 await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);


    runApp(const MyApp());

  
 }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        
      ),
      debugShowCheckedModeBanner: false,
      home:const Splashscreen(),
    );
  }
}