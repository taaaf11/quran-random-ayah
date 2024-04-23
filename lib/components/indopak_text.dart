// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:google_fonts/google_fonts.dart';

// 🌎 Project imports:
import 'package:quran_random_ayah/api.dart';
import 'package:quran_random_ayah/constants.dart';
import 'package:quran_random_ayah/utils.dart';

class IndopakTextWidget extends StatefulWidget {
  final String verseKey;
  final TextStyle? style;

  const IndopakTextWidget({
    super.key,
    required this.verseKey,
    this.style,
  });

  @override
  State<IndopakTextWidget> createState() => _IndopakTextWidgetState();
}

class _IndopakTextWidgetState extends State<IndopakTextWidget> {
  // String _oldVerseKey = widget.verseKey;
  @override
  Widget build(BuildContext context) {
    String randomVerseKey = widget.verseKey;

    return FutureBuilder<String>(
      // key: UniqueKey(),
      key: ValueKey(randomVerseKey),
      future: QuranApi.fetchTranslation(randomVerseKey),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
        }

        final animation = Tween<double>(
          begin: 0,
          end: 1,
        );

        return TweenAnimationBuilder(
          duration: const Duration(milliseconds: 300),
          tween: animation,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 100,
            ),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Text(
                      indopakAyah[randomVerseKey]!,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 35,
                        fontFamily: 'Indopak_WBW',
                        letterSpacing: -.1,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    child: Divider(
                      indent: 20,
                      endIndent: 20,
                    ),
                  ),
                  Text(
                    removeMarkupTags(snapshot.data!),
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(fontSize: 17),
                  ),
                  SizedBox(height: 18),
                  Builder(builder: (context) {
                    final List<String> verseKeySplit =
                        randomVerseKey.split(':');
                    int surahNumber = int.parse(verseKeySplit[0]);
                    int ayahNumber = int.parse(verseKeySplit[1]);

                    String surahName = surahData[surahNumber]![1];

                    return Opacity(
                      opacity: 0.7,
                      child: Text(
                        '$surahName . $ayahNumber',
                        style: GoogleFonts.roboto(fontWeight: FontWeight.w700),
                      ),
                    );
                  })
                ],
              ),
            ),
          ),
          builder: (context, value, child) {
            return AnimatedOpacity(
              opacity: value,
              duration: const Duration(milliseconds: 60),
              child: child,
            );
          },
        );
      },
    );
  }
}
