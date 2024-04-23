// 🐦 Flutter imports:
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_random_ayah/notifiers/quran_text_type_notifier.dart';
import 'package:quran_random_ayah/types.dart';

class QuranicTextTypeSelectionDropdown extends StatelessWidget {
  const QuranicTextTypeSelectionDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    var quranTextTypeState = Provider.of<QuranTextTypeNotifier>(context);
    return DropdownMenu<String>(
      dropdownMenuEntries: [
        DropdownMenuEntry(value: 'indopak', label: 'Indopak'),
        DropdownMenuEntry(value: 'v1', label: 'King Fahad Complex V1'),
      ],
      onSelected: (String? value) {
        switch (value) {
          case 'indopak':
            quranTextTypeState.change(QuranTextType.indopak);
          case 'v1':
            quranTextTypeState.change(QuranTextType.v1);
        }
      },
    );
  }
}
