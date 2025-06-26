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

      return json.decode(utf8.decode((await storageRef
          .child('$path/${locale.toLanguageTag()}.json')
          .getData())!));
    } catch (e) {
      //Catch network exceptions
      return {};
    }
  }
}
