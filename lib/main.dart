import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:voidchess/route_generator.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Void Chess',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

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
                padding: EdgeInsets.only(top: 150),
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
                        return null; 
                      },
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/second',
                      arguments: 'Hello there from the first page!',
                    );
                   },
                  child: Text(
                    'Play',
                    style: TextStyle(
                      fontSize: 16,  
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 80),
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
                        return null; 
                      },
                    ),
                  ),
                  onPressed: () { },
                  child: Text(
                    'Settings',
                    style: TextStyle(
                      fontSize: 16,  
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {

  const SecondPage({
    super.key,
    required this.data,
    });

  final String data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Void Chess'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Second Page',
              style: TextStyle(fontSize: 50),
            ),
            Text(
              data,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}