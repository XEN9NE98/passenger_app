import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:passenger_app/home_screen.dart';
import 'dart:developer' as developer;

class PhoneLoginPage extends StatefulWidget {
  const PhoneLoginPage({super.key});

  @override
  State<PhoneLoginPage> createState() => _PhoneLoginPageState();
}

class _PhoneLoginPageState extends State<PhoneLoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;
  
  get phoneNumber => "+60${_phoneController.text.trim()}";

  Future<void> _sendOTP() async {
    setState(() => _isLoading = true);
    
    // Always include the country code (+60 for Malaysia)
    String phoneNumber = "+60${_phoneController.text.trim()}";

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        // Android Auto-retrieval: Logs in automatically if SMS is detected
        await FirebaseAuth.instance.signInWithCredential(credential);
        _navigateToHome();
      },
      verificationFailed: (FirebaseAuthException e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() => _isLoading = false);
        // Navigate to the OTP verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OTPScreen(verificationId: verificationId),
          ),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void _navigateToHome() {
    // This will be your main dashboard after login
    developer.log("OTP Sent to $phoneNumber");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Melaka Water Taxi Login")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.directions_boat, size: 80, color: Colors.blue),
            const SizedBox(height: 20),
            const Text("Enter your phone number to continue"),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                prefixText: "+60 ",
                border: OutlineInputBorder(),
                hintText: "123456789",
              ),
            ),
            const SizedBox(height: 20),
            _isLoading 
              ? const CircularProgressIndicator()
              : SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _sendOTP, 
                    child: const Text("Send OTP Code"),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

// --- OTP Verification Screen ---

class OTPScreen extends StatefulWidget {
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  bool _isVerifying = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Code")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text("Enter the 6-digit code sent to your phone"),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, letterSpacing: 8),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            _isVerifying
              ? const CircularProgressIndicator()
              : ElevatedButton(
                onPressed: () async {
                  setState(() => _isVerifying = true);
                  try {
                    AuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: widget.verificationId,
                      smsCode: _otpController.text,
                    );
                    
                    await FirebaseAuth.instance.signInWithCredential(credential);

                    // 1. Check if the context is still valid after the 'await'
                    if (!context.mounted) return;

                    // 2. Clear the stack and go to the Home Screen
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                      (route) => false,
                    );
                  } catch (e) {
                    // 3. Check if still mounted before updating UI state
                    if (!mounted) return;
                    
                    setState(() => _isVerifying = false);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Invalid Code")),
                    );
                  }
                },
                  child: const Text("Verify & Log In"),
                ),
          ],
        ),
      ),
    );
  }
}