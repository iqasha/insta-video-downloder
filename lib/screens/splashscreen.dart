import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:insta/screens/homepage.dart';
import 'package:insta/screens/adds/appopen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _waited = false;
  final AppOpenAdManager _adManager = AppOpenAdManager();

  @override
  void initState() {
    super.initState();
    _adManager.loadAd();
    _wait();
  }

  Future<void> _wait() async {
    await Future.delayed(const Duration(seconds: 6));
    if (!mounted) return;
    setState(() {
      _waited = true;
      _adManager.showAdIfAvailable(); // Show the ad after waiting
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _waited
            ? StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                    return const MyHomePage();
                },
              )
            : 
                  Image.asset('assets/images/splash.png'),
      ),
    );
  }
}