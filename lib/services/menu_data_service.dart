import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MenuDataService {
  final storageMenuRef =
      FirebaseStorage.instance.ref().child("menu/menu_data_v3.json");
  final storageMenuLangRef =
      FirebaseStorage.instance.ref().child("translations/menu_lang.json");

  Future<List<Map<String, dynamic>>> fetchMenuData(
      {bool forceRefresh = false}) async {
    try {
      final bytes = await storageMenuRef.getData(5 * 1024 * 1024); // 5 MB Limit

      if (bytes == null) throw Exception("Error: menu_data_V3.json is empty!");

      final jsonString = utf8.decode(bytes);
      return (json.decode(jsonString) as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('Error fetching menu data from Firebase Storage: $e');
      final localJson =
          await rootBundle.loadString('assets/menu/menu_data_v3.json');
      return (json.decode(localJson) as List).cast<Map<String, dynamic>>();
    }
  }

  Future<List<Map<String, String>>> fetchMenuDataLanguage() async {
    try {
      final bytes =
          await storageMenuLangRef.getData(5 * 1024 * 1024); // 5 MB Limit

      if (bytes == null) throw Exception("Error: menu_lang.json is empty!");

      final jsonString = utf8.decode(bytes);
      return (json.decode(jsonString) as List).cast<Map<String, String>>();
    } catch (e) {
      debugPrint(
          'Error fetching menu languages data from Firestore Storage: $e');
      final lcoalString =
          await rootBundle.loadString('assets/lang/menu_lang.json');
      return (json.decode(lcoalString) as List).cast<Map<String, String>>();
    }
  }

  Future<void> updateMenuData(List<Map<String, dynamic>> updatedMenuLang,
      Map<String, dynamic> updatedMenuData) async {
    try {
      final menuData = await fetchMenuData();
      final menuLangData = await fetchMenuDataLanguage();

      final menuIndex =
          menuData.indexWhere((item) => item['id'] == updatedMenuData['id']);
      if (menuIndex == -1)
        throw Exception("Menu item not found: ${updatedMenuData['id']}");

      // Menu Data Update
      if (updatedMenuData['price'] case final price as Map<String, dynamic>) {
        menuData[menuIndex]
            ['price'] = {...menuData[menuIndex]['price'], ...price};
      }

      // Menu Language Data Update
      for (final menuLang in updatedMenuLang) {
        final lang = menuLangData.indexWhere((l) => l['id'] == menuLang['id']);
        if (lang != -1) {
          menuLangData[lang] = {...menuLangData[lang], ...menuLang};
        }
      }

      await Future.wait([
        storageMenuRef.putData(utf8.encode(json.encode(menuData)),
            SettableMetadata(contentType: 'application/json')),
        storageMenuLangRef.putData(utf8.encode(json.encode(menuLangData)),
            SettableMetadata(contentType: 'application/json'))
      ]);

      debugPrint('Menu Data updated successfully!');
    } catch (e) {
      debugPrint('Error updateing menu data to Firestore Storage: $e');
    }
  }
}
