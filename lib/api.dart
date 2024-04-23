// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:http/http.dart' as http;

// 🌎 Project imports:
import 'package:quran_random_ayah/model/ayah_v1_text_model.dart';
import 'package:quran_random_ayah/types.dart';
import 'package:quran_random_ayah/utils.dart';

class QuranApi {
  static Future<Map<String, dynamic>> _fetchAyahData(
      QuranTextType textType) async {
    final String randomVerseKey = getRandomVerseKey();

    String urlString = switch (textType) {
      QuranTextType.indopak =>
        'https://api.quran.com/api/v4/quran/verses/indopak?verse_key=$randomVerseKey',
      QuranTextType.v1 =>
        'https://api.quran.com/api/v4/quran/verses/indopak?code_v1=$randomVerseKey'
    };

    final uri = Uri.parse(urlString);
    final response = await http.get(uri);
    final responseJson = jsonDecode(response.body);

    return responseJson;
  }

  // static Future<IndopakText> fetchIndopakRandom() async {
  //   final ayahData = await _fetchAyahData(QuranTextType.indopak);

  //   return IndopakText(
  //     verseKey: ayahData['verses']![0]['verse_key'],
  //     verseText: ayahData['verses']![0]['text_indopak'],
  //   );
  // }

  static Future<AyahV1> fetchV1AyahRandom() async {
    final ayahData = await _fetchAyahData(QuranTextType.v1);

    return AyahV1(
      pageNumber: ayahData['verses'][0]['v1_page'],
      verseKey: ayahData['verses'][0]['verse_key'],
      verseText: ayahData['verses'][0]['text_indopak'],
    );
  }

  static Future<String> fetchTranslation(String verseKey) async {
    final uri = Uri.parse(
        'https://api.quran.com/api/v4/verses/by_key/$verseKey?translations=20');
    final response = await http.get(uri);
    final responseJson = jsonDecode(response.body);

    return responseJson['verse']['translations'][0]['text'];
  }

  // static Future<QuranText> fetchRandomAyah(String verseKey) async {
  //   final uri = Uri.parse(
  //       'https://api.quran.com/api/v4/verses/by_key/$verseKey?words=true&fields=text_indopak&word_fields=?translations=20');
  //   final response = await http.get(uri);
  //   final responseJson = jsonDecode(response.body);
  // }
}
