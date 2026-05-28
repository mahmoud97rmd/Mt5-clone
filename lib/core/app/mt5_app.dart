// Path: lib/core/app/mt5_app.dart
// ============================================================
// MT5 Clone — Root Application Widget (minimal for debugging)
// ============================================================

import 'package:flutter/material.dart';

class Mt5App extends StatelessWidget {
  const Mt5App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MT5 Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const _SplashScreen(),
    );
  }
}

class _SplashScreen extends StatefulWidget {
  const _SplashScreen();
  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen> {
  String _status = 'Starting...';

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() => _status = 'Initializing...');
    // Add initialization steps here one by one
    setState(() => _status = 'Ready');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E14),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.show_chart,
                color: Color(0xFF00D4AA), size: 64),
            const SizedBox(height: 24),
            const Text(
              'MT5 Clone',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFFE6EDF3),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _status,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF7D8590),
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: Color(0xFF00D4AA),
            ),
          ],
        ),
      ),
    );
  }
}
