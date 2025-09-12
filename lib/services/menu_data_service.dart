import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

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

  Future<List<Map<String, dynamic>>> fetchMenuDataLanguage() async {
    try {
      final bytes =
          await storageMenuLangRef.getData(5 * 1024 * 1024); // 5 MB Limit

      if (bytes == null) throw Exception("Error: menu_lang.json is empty!");

      final jsonString = utf8.decode(bytes);
      return (json.decode(jsonString) as List).cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint(
          'Error fetching menu languages data from Firestore Storage: $e');
      final lcoalString =
          await rootBundle.loadString('assets/lang/menu_lang.json');
      return (json.decode(lcoalString) as List).cast<Map<String, dynamic>>();
    }
  }

  Future<bool> updateMenuData(List<Map<String, dynamic>> updatedMenuLang,
      Map<String, dynamic>? updatedMenuData) async {
    try {
      final menuData = await fetchMenuData();
      final menuLangData = await fetchMenuDataLanguage();

      // Menu Data Update

      if (updatedMenuData == null) {
        debugPrint('No menu data to update, only updating language data');
      } else {
        final menuIndex =
            menuData.indexWhere((item) => item['id'] == updatedMenuData['id']);
        if (menuIndex == -1) {
          throw Exception("Menu item not found: ${updatedMenuData['id']}");
        }

        if (updatedMenuData['options'] case final option as Map) {
          final existingOptions =
              Map<String, dynamic>.from(menuData[menuIndex]['options'] as Map);

          menuData[menuIndex]['options'] = {...existingOptions, ...option};
        }
      }

      // Menu Language Data Update

      for (final menuLang in updatedMenuLang) {
        final langIndex = menuLangData.indexWhere((l) {
          return l['id'] == menuLang['id'];
        });
        if (langIndex != -1) {
          final existingLang =
              Map<String, dynamic>.from(menuLangData[langIndex] as Map);

          menuLangData[langIndex] = {...existingLang, ...menuLang};
        }
      }

      await Future.wait([
        storageMenuRef.putData(utf8.encode(json.encode(menuData)),
            SettableMetadata(contentType: 'application/json')),
        storageMenuLangRef.putData(utf8.encode(json.encode(menuLangData)),
            SettableMetadata(contentType: 'application/json'))
      ]);
      debugPrint('Menu Data updated successfully!');
      return true;
    } catch (e) {
      debugPrint('Error updateing menu data to Firestore Storage: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchMenuMethods() async {
    try {
      final menuLangData = await fetchMenuDataLanguage();

      final menuMethods = menuLangData
          .where(
              (menu) => menu['id'] != null && menu['id'].startsWith('method'))
          .toList();

      return menuMethods;
    } catch (e) {
      debugPrint('Error fetching menu methods from Firestore Storage: $e');
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> fetchMenuMethodsStream() async* {
    try {
      final menuLangData = await fetchMenuDataLanguage();

      final menuMethods = menuLangData
          .where(
              (menu) => menu['id'] != null && menu['id'].startsWith('method'))
          .toList();

      yield menuMethods;
    } catch (e) {
      debugPrint('Error fetching menu methods from Firestore Storage: $e');
      yield [];
    }
  }

  Stream<Map<String, dynamic>> fetchMenuOption(String menuId) async* {
    try {
      while (true) {
        final menuData = await fetchMenuData();
        final menuIndex = menuData.indexWhere((index) => index['id'] == menuId);

        if (menuIndex != -1) {
          yield Map<String, dynamic>.from(menuData[menuIndex]['options'] ?? {});
        } else {
          yield {};
        }

        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (e) {
      debugPrint("Error fetching menu option from Firestore Storage: $e");
      yield {};
    }
  }

  Future<bool> createMenuMethod(Map<String, dynamic> newMenuMethod,
      Map<String, dynamic> newMenuOption) async {
    try {
      final menuData = await fetchMenuData();
      final menuLangData = await fetchMenuDataLanguage();

      // Create Menu Method key and Languages

      menuLangData.add(newMenuMethod);

      // Add Menu Method Key

      final menuIndex =
          menuData.indexWhere((item) => item['id'] == newMenuOption['id']);
      if (menuIndex == -1) {
        throw Exception("Menu item not found: ${newMenuOption['id']}");
      }

      if (newMenuOption['options'] case final option as Map) {
        final existingOptions =
            Map<String, dynamic>.from(menuData[menuIndex]['options'] as Map);

        menuData[menuIndex]['options'] = {...existingOptions, ...option};
      }

      await Future.wait([
        storageMenuRef.putData(utf8.encode(json.encode(menuData)),
            SettableMetadata(contentType: 'application/json')),
        storageMenuLangRef.putData(utf8.encode(json.encode(menuLangData)),
            SettableMetadata(contentType: 'application/json'))
      ]);
      debugPrint('Menu option created successfully!');
      return true;
    } catch (e) {
      debugPrint('Error creating menu option to Firestore Storage: $e');
      return false;
    }
  }

  Future<bool> addMenuMethod(Map<String, dynamic> menu) async {
    try {
      final menuData = await fetchMenuData();
      final menuIndex =
          menuData.indexWhere((index) => index['id'] == menu['id']);

      if (menuIndex == -1) {
        throw Exception("Menu item not found: ${menu['id']}");
      }

      if (menu['options'] case final Map<String, dynamic> option) {
        final existingOptions =
            Map<String, dynamic>.from(menuData[menuIndex]['options'] as Map);
        menuData[menuIndex]['options'] = {...existingOptions, ...option};
      }

      storageMenuRef.putData(utf8.encode(json.encode(menuData)),
          SettableMetadata(contentType: 'application/json'));
      return true;
    } catch (e) {
      debugPrint('Error adding menu option to Firestore Storage: $e');
      return false;
    }
  }

  Future<bool> createMenuOption(Map<String, dynamic> newMenuMethod,
      Map<String, dynamic> newMenuOption) async {
    try {
      final menuData = await fetchMenuData();
      final menuLangData = await fetchMenuDataLanguage();

      // Create Menu Method key and Languages

      menuLangData.add(newMenuMethod);

      // Create Menu Method Price

      final menuIndex =
          menuData.indexWhere((item) => item['id'] == newMenuOption['id']);
      if (menuIndex == -1) {
        throw Exception("Menu item not found: ${newMenuOption['id']}");
      }

      if (newMenuOption['options'] case final option as Map) {
        final existingOptions =
            Map<String, dynamic>.from(menuData[menuIndex]['options'] as Map);

        menuData[menuIndex]['options'] = {...existingOptions, ...option};
      }

      await Future.wait([
        storageMenuRef.putData(utf8.encode(json.encode(menuData)),
            SettableMetadata(contentType: 'application/json')),
        storageMenuLangRef.putData(utf8.encode(json.encode(menuLangData)),
            SettableMetadata(contentType: 'application/json'))
      ]);
      debugPrint('Menu option created successfully!');
      return true;
    } catch (e) {
      debugPrint('Error creating menu option to Firestore Storage: $e');
      return false;
    }
  }

  Future<bool> addMenuOption(Map<String, dynamic> menu) async {
    try {
      final menuData = await fetchMenuData();
      final menuIndex =
          menuData.indexWhere((index) => index['id'] == menu['id']);

      if (menuIndex == -1) {
        throw Exception("Menu item not found: ${menu['id']}");
      }

      if (menu['options'] case final Map<String, dynamic> option) {
        final existingOptions =
            Map<String, dynamic>.from(menuData[menuIndex]['options'] as Map);
        menuData[menuIndex]['options'] = {...existingOptions, ...option};
      }

      storageMenuRef.putData(utf8.encode(json.encode(menuData)),
          SettableMetadata(contentType: 'application/json'));
      return true;
    } catch (e) {
      debugPrint('Error adding menu option to Firestore Storage: $e');
      return false;
    }
  }

  Future<bool> removeMenuOption(Map<String, dynamic> menu) async {
    try {
      final menuData = await fetchMenuData();
      final menuIndex =
          menuData.indexWhere((index) => index['id'] == menu['id']);

      if (menuIndex == -1) {
        throw Exception("Menu item not found: ${menu['id']}");
      }

      if (menu['options'] case final Map<String, dynamic> option) {
        menuData[menuIndex]['options'] = option;
      }

      storageMenuRef.putData(utf8.encode(json.encode(menuData)),
          SettableMetadata(contentType: 'application/json'));
      return true;
    } catch (e) {
      debugPrint('Error removing menu option from Firestore Storage: $e');
      return false;
    }
  }

  Future<bool> removeMenuMethod(String methodKey) async {
    try {
      final menuLangData = await fetchMenuDataLanguage();
      menuLangData.removeWhere((m) => m['id'] == methodKey);

      storageMenuLangRef.putData(utf8.encode(json.encode(menuLangData)),
          SettableMetadata(contentType: 'application/json'));
      return true;
    } catch (e) {
      debugPrint('Error removing menu option from Firestore Storage: $e');
      return false;
    }
  }
}
