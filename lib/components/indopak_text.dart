import 'package:flutter/material.dart';
import 'package:quran_random_ayah/api.dart';
import 'package:quran_random_ayah/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quran_random_ayah/utils.dart';

class IndopakTextWidget extends StatefulWidget {
  final TextStyle? style;

  const IndopakTextWidget({
    super.key,
    this.style,
  });

  @override
  State<IndopakTextWidget> createState() => _IndopakTextWidgetState();
}

class _IndopakTextWidgetState extends State<IndopakTextWidget> {
  @override
  Widget build(BuildContext context) {
    String randomVerseKey = getRandomVerseKey();

    return FutureBuilder<String>(
      key: UniqueKey(),
      future: QuranApi.fetchTranslation(randomVerseKey),
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          debugPrint(snapshot.error.toString());
        }

        var animation = Tween<double>(
          begin: 0,
          end: 1,
        );

        return TweenAnimationBuilder(
          // animation: animation,
          duration: const Duration(milliseconds: 300),
          tween: animation,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.primary),
              borderRadius: BorderRadius.circular(12),
            ),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 100),
            padding: const EdgeInsets.all(20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0.0),
                    child: Text(indopakAyah[randomVerseKey]!,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontSize: 30, fontFamily: 'Indopak_WBW')
                        // style: Theme.of(context)
                        //     .textTheme
                        //     .displaySmall
                        //     ?.copyWith(fontFamily: 'Indopak_WBW', height: 1.3),
                        ),
                  ),
                  // AnimationController.unbounded(vsync: vsync),

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
            if (value == 1) {
              animation = Tween<double>(begin: 0, end: 1);
            }
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
