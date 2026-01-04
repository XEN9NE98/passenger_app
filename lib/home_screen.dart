import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:passenger_app/payment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Passenger';
  String? _selectedOrigin;
  String? _selectedDestination;
  int _passengerCount = 1;

  // Predefined locations in Melaka
  final List<Map<String, dynamic>> _locations = [
    {'name': 'Jetty 1 - Melaka River Cruise', 'lat': 2.1953, 'lng': 102.2494},
    {'name': 'Jetty 2 - Taman Rempah', 'lat': 2.1989, 'lng': 102.2511},
    {'name': 'Jetty 3 - Kampung Morten', 'lat': 2.2012, 'lng': 102.2534},
    {'name': 'Jetty 4 - Banda Hilir', 'lat': 2.1876, 'lng': 102.2501},
    {'name': 'Jetty 5 - Portuguese Settlement', 'lat': 2.1845, 'lng': 102.2589},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (userDoc.exists && mounted) {
        setState(() {
          _userName = userDoc.data()?['name'] ?? 'Passenger';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = MediaQuery.of(context).padding.top;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: const Color(0xFF0066CC),
      ),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting Section
              SafeArea(
                top: false,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(24, topInset + 24, 24, 24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF0066CC),
                        const Color(0xFF0066CC).withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _userName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Where would you like to go today?",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Booking Form Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Origin Selection
                    const Text(
                      "Pick-up Location",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDDE5F0), width: 1.5),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedOrigin,
                        hint: const Text("Select pick-up jetty"),
                        underline: const SizedBox(),
                        items: _locations.map((location) {
                          return DropdownMenuItem<String>(
                            value: location['name'],
                            child: Row(
                              children: [
                                const Icon(Icons.location_on, color: Color(0xFF0066CC), size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    location['name'],
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedOrigin = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Destination Selection
                    const Text(
                      "Drop-off Location",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDDE5F0), width: 1.5),
                      ),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedDestination,
                        hint: const Text("Select drop-off jetty"),
                        underline: const SizedBox(),
                        items: _locations.map((location) {
                          return DropdownMenuItem<String>(
                            value: location['name'],
                            child: Row(
                              children: [
                                const Icon(Icons.flag, color: Color(0xFF0066CC), size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    location['name'],
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedDestination = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Number of Passengers
                    const Text(
                      "Number of Passengers",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFDDE5F0), width: 1.5),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.people, color: Color(0xFF0066CC)),
                              const SizedBox(width: 12),
                              Text(
                                '$_passengerCount ${_passengerCount == 1 ? 'Passenger' : 'Passengers'}',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove_circle_outline),
                                color: _passengerCount > 1 ? const Color(0xFF0066CC) : Colors.grey,
                                onPressed: _passengerCount > 1
                                    ? () {
                                        setState(() => _passengerCount--);
                                      }
                                    : null,
                              ),
                              IconButton(
                                icon: const Icon(Icons.add_circle_outline),
                                color: _passengerCount < 10 ? const Color(0xFF0066CC) : Colors.grey,
                                onPressed: _passengerCount < 10
                                    ? () {
                                        setState(() => _passengerCount++);
                                      }
                                    : null,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Book Now Button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: (_selectedOrigin != null && _selectedDestination != null)
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PaymentScreen(
                                      origin: _selectedOrigin!,
                                      destination: _selectedDestination!,
                                      passengerCount: _passengerCount,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        child: const Text(
                          "Book Water Taxi",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}