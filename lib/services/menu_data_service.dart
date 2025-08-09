import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class MenuDataService {
  Future<List<Map<String, dynamic>>> fetchMenuData() async {
    try {
      final storageRef =
          FirebaseStorage.instance.ref().child("menu/menu_data_v2.json");
      final bytes = await storageRef.getData(5 * 1024 * 1024); // 5 MB Limit

      if (bytes == null) throw Exception("menu_data_V2.json is empty");
      final jsonString = utf8.decode(bytes);

      return (json.decode(jsonString) as List).cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error fetching data from Firebase Storage: $e');
      final localJson =
          await rootBundle.loadString('assets/menu/menu_data_v2.json');
      return (json.decode(localJson) as List).cast<Map<String, dynamic>>();
    }
  }

  // Future<void> updateMenuData() async {
  //   final storageRef = FirebaseStorage.instance.ref().child('');
  // }
}
