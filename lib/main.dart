import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'phone_login_page.dart';

void main() async {
  // CRITICAL: This line prevents the "Isolate" crash
  WidgetsFlutterBinding.ensureInitialized(); 

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Melaka Water Taxi',
      theme: ThemeData(primarySwatch: Colors.blue),
      // Set the PhoneLoginPage as the starting screen
      home: const PhoneLoginPage(), 
    );
  }
}