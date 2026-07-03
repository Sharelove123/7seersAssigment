import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'core/theme.dart';
import 'core/services/firebase_seeder.dart';
import 'features/home/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool firebaseReady = false;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firebaseReady = true;
    await FirebaseSeeder.seedIfNeeded();
  } catch (e) {
    debugPrint('Firebase init failed, running offline: $e');
  }

  runApp(ProviderScope(child: DallApp(isFirebaseInitialized: firebaseReady)));
}

class DallApp extends StatelessWidget {
  final bool isFirebaseInitialized;

  const DallApp({super.key, required this.isFirebaseInitialized});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dall',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const HomeScreen(),
    );
  }
}
