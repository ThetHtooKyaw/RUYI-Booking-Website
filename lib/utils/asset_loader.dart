import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class LocalAssetLoader extends AssetLoader {
  const LocalAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) async {
    try {
      // Try loading from Firebase Storage first
      return await _loadFromFirebase(path, locale);
    } catch (e) {
      debugPrint('Error loading translations from Firebase: $e');
      // Fallback to local assets
      return await _loadFromLocalAssets(path, locale);
    }
  }

  Future<Map<String, dynamic>> _loadFromFirebase(
      String path, Locale locale) async {
    final storageRef = FirebaseStorage.instance.ref();

    // UI Translation
    final uiBytes = await storageRef
        .child('$path/${locale.toLanguageTag()}.json')
        .getData();
    final Map<String, dynamic> uiTranslations =
        json.decode(utf8.decode(uiBytes!));

    // Menu Item Translation
    final menuBytes = await storageRef.child('$path/menu_lang.json').getData();
    final List<dynamic> menuList = json.decode(utf8.decode(menuBytes!)) as List;

    final Map<String, dynamic> menuTranslations = {
      for (var item in menuList) item['id']: item[locale.toLanguageTag()] ?? ''
    };

    final mergedTranslations = {...uiTranslations, ...menuTranslations};
    return mergedTranslations;
  }

  Future<Map<String, dynamic>> _loadFromLocalAssets(
      String path, Locale locale) async {
    try {
      // Load UI translations from local assets
      final uiTranslationString = await rootBundle
          .loadString('assets/lang/${locale.toLanguageTag()}.json');
      final Map<String, dynamic> uiTranslations =
          json.decode(uiTranslationString);

      // Load menu translations from local assets
      final menuTranslationString =
          await rootBundle.loadString('assets/lang/menu_lang.json');
      final List<dynamic> menuList = json.decode(menuTranslationString) as List;

      final Map<String, dynamic> menuTranslations = {
        for (var item in menuList)
          item['id']: item[locale.toLanguageTag()] ?? ''
      };

      final mergedTranslations = {...uiTranslations, ...menuTranslations};
      return mergedTranslations;
    } catch (e) {
      debugPrint('Error loading translations from local assets: $e');
      return {};
    }
  }
}
