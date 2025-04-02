import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LanguagePicker extends StatefulWidget {
  final double offset;
  final Color color;
  const LanguagePicker({super.key, required this.offset, required this.color});

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  String selectedLanguage = 'English';
  final List<String> languageOptions = ['English', '中国', 'မြန်မာ'];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        PopupMenuButton<String>(
          offset: Offset(widget.offset, kToolbarHeight),
          onSelected: (String value) {
            setState(() {
              selectedLanguage = value;
            });

            if (value == 'English') {
              context.setLocale(const Locale('en'));
            } else if (value == '中国') {
              context.setLocale(const Locale('zh'));
            } else if (value == 'မြန်မာ') {
              context.setLocale(const Locale('my'));
            }
          },
          itemBuilder: (context) {
            return languageOptions.map((String lan) {
              return PopupMenuItem<String>(
                value: lan,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minWidth: 100),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    child: Center(child: Text(lan)),
                  ),
                ),
              );
            }).toList();
          },
          child: TextButton(
            onPressed: null,
            child: Text(
              selectedLanguage,
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
