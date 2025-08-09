import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'dart:convert';

class LocalAssetLoader extends AssetLoader {
  const LocalAssetLoader();
  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    try {
      final storageRef = FirebaseStorage.instance.ref();

      // UI Translation
      final uiBytes = await storageRef
          .child('$path/${locale.toLanguageTag()}.json')
          .getData();
      final Map<String, dynamic> uiTranslations =
          json.decode(utf8.decode(uiBytes!));

      // Menu Item Translation
      final menuBytes =
          await storageRef.child('$path/menu_lang.json').getData();
      final List<dynamic> menuList =
          json.decode(utf8.decode(menuBytes!)) as List;

      final Map<String, dynamic> menuTranslations = {
        for (var item in menuList)
          item['id']: item[locale.toLanguageTag()] ?? ''
      };
      final mergedTranslations = {...uiTranslations, ...menuTranslations};
      return mergedTranslations;
      // return json.decode(utf8.decode((await storageRef
      //     .child('$path/${locale.toLanguageTag()}.json')
      //     .getData())!));
    } catch (e) {
      debugPrint('Error loading translations: $e');
      return {};
    }
  }
}
