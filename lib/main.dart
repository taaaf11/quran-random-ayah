// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:quran_random_ayah/components/v1_text.dart';
import 'package:quran_random_ayah/notifiers/quran_text_type_notifier.dart';
import 'package:quran_random_ayah/types.dart';

// 📦 Package imports:
import 'package:url_launcher/url_launcher_string.dart';
import 'package:provider/provider.dart';

// 🌎 Project imports:
import 'package:quran_random_ayah/components/indopak_text.dart';
import 'package:quran_random_ayah/pages/settings_page.dart';
import 'shared_prefs_provider.dart';
import 'package:quran_random_ayah/utils.dart';

void main() async {
  await SharedPreferencesProvider.initialize();

  QuranTextType? quranTextTypePref = switch (
      SharedPreferencesProvider.instance.getString('quran_text_type')) {
    'indopak' => QuranTextType.indopak,
    'v1' => QuranTextType.v1,
    _ => null
  };

  runApp(MyApp(
    quranTextType: quranTextTypePref ?? QuranTextType.indopak,
  ));
}

class MyApp extends StatelessWidget {
  final QuranTextType quranTextType;

  const MyApp({super.key, required this.quranTextType});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => QuranTextTypeNotifier(quranTextType),
      child: MaterialApp(
        title: 'Quran Random Ayah',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Quran Random Ayah'),
      ),
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
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => setState(
              () {
                _randomVerseKey = getRandomVerseKey();
              },
            ),
            icon: const Icon(Icons.sync),
          ),
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                    child: TextButton(
                  child: const Text('Settings'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()),
                    );
                  },
                ))
              ];
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Consumer(
              builder: (_, QuranTextTypeNotifier state, child) {
                switch (state.quranTextType) {
                  case QuranTextType.indopak:
                    return IndopakTextWidget(verseKey: _randomVerseKey);
                  case QuranTextType.v1:
                    return V1TextWidget(verseKey: _randomVerseKey);
                }
              },
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
                  child: const Text(
                    '',
                    style: TextStyle(
                      fontFamily: 'Symbols-NF',
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
