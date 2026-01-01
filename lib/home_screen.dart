import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Melaka Water Taxi"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              
              if (!context.mounted) return; // Add this for StatelessWidget
              
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.waves, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            Text(
              "Welcome, Passenger!",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const Text("Your taxi is ready for booking."),
          ],
        ),
      ),
    );
  }
}