// 🎯 Dart imports:
import 'dart:math';
import 'dart:typed_data';

// 📦 Package imports:
import 'package:http/http.dart' as http;

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

Future<ByteData> fetchFont(int pageNumber) async {
  final response = await http.get(Uri.parse(
      'https://raw.githubusercontent.com/quran/quran.com-frontend-next/master/public/fonts/quran/hafs/v1/ttf/p$pageNumber.ttf'));

  if (response.statusCode == 200) {
    return ByteData.view(response.bodyBytes.buffer);
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load font');
  }
}
