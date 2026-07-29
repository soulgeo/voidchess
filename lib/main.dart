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
        backgroundColor: const Color.fromARGB(255, 198, 223, 255),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 100),
                child: Center(
                  child: Text(
                    "Void Chess",
                    style: TextStyle (
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 41, 43, 44),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 150),
                child: TextButton(
                  style: ButtonStyle(
                    textStyle: WidgetStateProperty.all<TextStyle>(const TextStyle(fontSize: 15)), 
                    fixedSize: WidgetStateProperty.all<Size>(const Size(200, 50)),
                    foregroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 179, 212, 255)),
                    backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 18, 65, 136)),
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {                   
                          return const Color.fromARGB(255, 50, 134, 202).withValues(alpha: 0.12);
                        }
                        if (states.contains(WidgetState.focused) || states.contains(WidgetState.pressed)) {
                          return Colors.blue.withValues(alpha: 0.12);
                        }
                        return null; // Defer to the widget's default.
                      },
                    ),
                  ),
                  onPressed: () { },
                  child: Text('Play')
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: TextButton(
                  style: ButtonStyle(
                    fixedSize: WidgetStateProperty.all<Size>(const Size(200, 50)),
                    foregroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 179, 212, 255)),
                    backgroundColor: WidgetStateProperty.all<Color>(const Color.fromARGB(255, 18, 65, 136)),
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.hovered)) {                   
                          return const Color.fromARGB(255, 50, 134, 202).withValues(alpha: 0.12);
                        }
                        if (states.contains(WidgetState.focused) || states.contains(WidgetState.pressed)) {
                          return Colors.blue.withValues(alpha: 0.12);
                        }
                        return null; // Defer to the widget's default.
                      },
                    ),
                  ),
                  onPressed: () { },
                  child: Text('Settings')
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}