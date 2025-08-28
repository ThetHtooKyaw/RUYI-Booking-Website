import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:universal_html/html.dart' as html;

class LanguagePicker extends StatefulWidget {
  final double offset;
  final Color color;
  const LanguagePicker({super.key, required this.offset, required this.color});

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  late Locale selectedLanguage = context.savedLocale ?? const Locale('en');
  final List<Locale> languageOptions = [
    const Locale('en'),
    const Locale('zh'),
    const Locale('my'),
  ];

  String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case "zh":
        return "中国";
      case "my":
        return "မြန်မာ";
      default:
        return "English";
    }
  }

  Future<void> _changeLanguage(BuildContext context, Locale language) async {
    final overlay = Overlay.of(context);

    final loader = OverlayEntry(
      builder: (_) => const ColoredBox(
        color: AppColors.appBackground,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
    overlay.insert(loader);

    try {
      setState(() => selectedLanguage = language);
      await context.setLocale(selectedLanguage);
      await Future.delayed(const Duration(milliseconds: 300));
      html.window.location.reload();
    } finally {
      loader.remove();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PopupMenuButton<Locale>(
          offset: Offset(widget.offset, kToolbarHeight),
          onSelected: (value) => _changeLanguage(context, value),
          itemBuilder: (context) {
            return languageOptions
                .map((lan) => PopupMenuItem<Locale>(
                      value: lan,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(minWidth: 100),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Center(child: Text(getLanguageName(lan))),
                        ),
                      ),
                    ))
                .toList();
          },
          child: TextButton(
            onPressed: null,
            child: Text(
              getLanguageName(selectedLanguage),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.color,
                fontSize: 16,
              ),
            ),
          ),
        ),
        Icon(
          Icons.arrow_downward_rounded,
          size: 18,
          color: Theme.of(context).iconTheme.color,
        ),
      ],
    );
  }
}
