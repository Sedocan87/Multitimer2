import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_blocks/screens/dashboard_screen.dart';
import 'package:time_blocks/services/timer_service.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TimerService(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Time Blocks',
      theme: ThemeData.dark(),
      home: const DashboardScreen(),
    );
  }
}
