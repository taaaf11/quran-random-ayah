import 'package:flutter/material.dart';
import 'package:quran_random_ayah/shared_prefs_provider.dart';
import 'package:quran_random_ayah/types.dart';

class QuranTextTypeNotifier with ChangeNotifier {
  QuranTextType _quranTextType = QuranTextType.indopak;

  QuranTextTypeNotifier(QuranTextType quranTextType) {
    _quranTextType = quranTextType;
  }

  void change(QuranTextType otherType) {
    _quranTextType = otherType;
    SharedPreferencesProvider.instance.setString(
        'quran_text_type',
        switch (otherType) {
          QuranTextType.indopak => 'indopak',
          QuranTextType.v1 => 'v1'
        });
    notifyListeners();
  }

  QuranTextType get quranTextType => _quranTextType;
}
