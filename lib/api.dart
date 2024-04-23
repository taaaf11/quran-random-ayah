// 🎯 Dart imports:
import 'dart:convert';

// 🐦 Flutter imports:
import 'package:flutter/services.dart';

// 📦 Package imports:
import 'package:http/http.dart' as http;

// 🌎 Project imports:
import 'package:quran_random_ayah/model/ayah_v1_text_model.dart';
import 'package:quran_random_ayah/types.dart';
import 'package:quran_random_ayah/utils.dart';

class QuranApi {
  static var v1PagesLoaded = [];

  static Future<Map<String, dynamic>> _fetchAyahData(
      QuranTextType textType, String verseKey) async {
    String urlString = switch (textType) {
      QuranTextType.indopak =>
        'https://api.quran.com/api/v4/quran/verses/indopak?verse_key=$verseKey',
      QuranTextType.v1 =>
        'https://api.quran.com/api/v4/quran/verses/code_v1?verse_key=$verseKey'
    };

    final uri = Uri.parse(urlString);
    final response = await http.get(uri);
    final responseJson = jsonDecode(response.body);

    return responseJson;
  }

  static Future<void> loadFont(int pageNumber) async {
    if (v1PagesLoaded.contains(pageNumber)) {
      return;
    }

    var fontLoader = FontLoader(pageNumber.toString());

    fontLoader.addFont(fetchFont(pageNumber));
    v1PagesLoaded.add(pageNumber);

    await fontLoader.load();
  }

  static Future<AyahV1> fetchV1Ayah(String randomVerseKey) async {
    final data = await Future.wait([
      _fetchAyahData(QuranTextType.v1, randomVerseKey),
      fetchTranslation(randomVerseKey)
    ]);

    final ayahData = data[0] as Map<String, dynamic>;
    final translation = data[1] as String;

    await loadFont(ayahData['verses'][0]['v1_page']);

    return AyahV1(
      pageNumber: ayahData['verses'][0]['v1_page'],
      verseKey: ayahData['verses'][0]['verse_key'],
      verseText: ayahData['verses'][0]['code_v1'],
      translation: translation,
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
