// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:url_launcher/url_launcher_string.dart';

// 🌎 Project imports:
import 'package:quran_random_ayah/components/indopak_text.dart';
import 'package:quran_random_ayah/utils.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Random Ayah',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Quran Random Ayah'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _opacity = .5;
  String _randomVerseKey = getRandomVerseKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => setState(
              () {
                _randomVerseKey = getRandomVerseKey();
              },
            ),
            icon: Icon(Icons.sync),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IndopakTextWidget(
              verseKey: _randomVerseKey,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MouseRegion(
              onEnter: (value) {
                setState(
                  () {
                    _opacity = 1;
                  },
                );
              },
              onExit: (event) {
                setState(
                  () {
                    _opacity = .5;
                  },
                );
              },
              child: GestureDetector(
                onTap: () async {
                  await launchUrlString(
                      'https://www.github.com/taaaf11/quran-random-ayah');
                },
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 300),
                  child: Text('',
                      style: TextStyle(
                        fontFamily: 'Symbols-NF',
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
