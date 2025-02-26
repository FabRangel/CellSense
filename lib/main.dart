import 'package:cellsense/screen/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CellSenseApp());
}

class CellSenseApp extends StatelessWidget {
  const CellSenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cell Sense',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}