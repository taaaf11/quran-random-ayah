// 🎯 Dart imports:
import 'dart:math';

// 🌎 Project imports:
import 'package:quran_random_ayah/constants.dart';

String getRandomVerseKey() {
  int chapterNumber = Random().nextInt(114) + 1;
  int verseNumber = Random().nextInt(surahData[chapterNumber]![0]) + 1;

  return '$chapterNumber:$verseNumber';
}

String removeMarkupTags(String htmlContent) {
  var markupAndNumbersRemoved =
      htmlContent.replaceAll(RegExp(r'<[^>]*>|&[^;]+;|\d+'), '');

  return markupAndNumbersRemoved;
}
