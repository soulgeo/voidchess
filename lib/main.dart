import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoidChess',
      theme: ThemeData(
        textTheme: GoogleFonts.cinzelTextTheme(),
      ),
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 196, 214, 224),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(
                  child: Text(
                    "Void Chess",
                    style: TextStyle (
                      fontSize: 55,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 121, 219),
                    ),
                  ),
                ),
              ),
          // Rest of your widgets here
            ],
          ),
        ),
      ),
    );
  }
}