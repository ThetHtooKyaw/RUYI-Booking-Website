import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/classes/category.dart';
import 'package:ruyi_booking/utils/menu_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuDataProvider extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  Map<String, int> itemQty = {};
  Map<String, String> itemType = {};
  Map<String, Map<String, dynamic>> favItems = {};
  Map<String, Map<String, dynamic>> cartedItems = {};
  final Set<String> clickedItems = {};

  MenuDataProvider() {
    Future.microtask(() => loadFavItemToLocalStorage());
  }

  bool isClickedItem(String uniqueKey) => clickedItems.contains(uniqueKey);

  void refreshOnLanguageChange() {
    notifyListeners();
  }

  void setSearchQuery(String value) {
    notifyListeners();
  }

  List<Map<String, dynamic>> getFilteredItems(int selectedCategory) {
    final searchText = searchController.text.toLowerCase();

    return menuItems.where((item) {
      final name = item['name'].toString().tr().toLowerCase();
      final searchMatches = name.contains(searchText);

      if (searchText.isNotEmpty) {
        return searchMatches;
      }

      final categoryMatches = (selectedCategory == 0 ||
          item['category'] == categories[selectedCategory].name);

      return categoryMatches;
    }).toList();
  }

  bool onShowPicker(Map<String, dynamic> item) {
    if ((item['category'].toString().tr() == 'category2'.tr() &&
            item['id'] != '15') ||
        item['category'].toString().tr() == 'category4'.tr() ||
        item['category'].toString().tr() == 'category6'.tr() ||
        item['category'].toString().tr() == 'category10'.tr() ||
        item['id'] == '136') {
      return true;
    }
    return false;
  }

  String onGetPrice(Map<String, dynamic> item) {
    final itemID = item['id'];
    final unit = getPriceUnit(itemID);
    final itemPrice = item['price'];

    if (itemPrice is String) return '${itemPrice.tr()} $unit';
    if (item['type'] == null || itemPrice is int) {
      return 'Ks. ${formatPrice(itemPrice)} $unit';
    }
    final selectedOption = itemType[itemID]?.toString().tr();
    final Map typesMap = item['type'] as Map;
    final Map priceMap = itemPrice as Map;

    final effectiveType = selectedOption ?? typesMap['0'].toString().tr();
    String? matchKey;

    typesMap.forEach(
      (key, value) {
        if (value.toString().tr() == effectiveType) matchKey = key;
      },
    );
    if (matchKey != null && priceMap.containsKey(matchKey)) {
      final price = priceMap[matchKey];

      if (itemID == '46' || itemID == '47') {
        return matchKey == '0'
            ? 'Ks. ${formatPrice(price)} ${'price_unit6'.tr()}'
            : '${price.toString().tr()} ${'price_unit1'.tr()}';
      }

      return 'Ks. ${formatPrice(priceMap[matchKey])} $unit';
    }

    return '';
  }

  String onGetCartPrice(Map<String, dynamic> item) {
    final itemID = item['selectedItemId'];
    final unit = getPriceUnit(itemID);
    final price = item['selectedPrice'];

    if (price is String) '${price.tr()} $unit';
    if (item['type'] == null || price is int) {
      return 'Ks. ${formatPrice(price)} $unit';
    }

    return '';
  }

  String formatPrice(dynamic price) {
    if (price is int) {
      return NumberFormat('#,###').format(price);
    } else {
      return price.toString().tr();
    }
  }

  String getPriceUnit(String itemID) {
    final id = int.tryParse(itemID);
    if (id == null) return '';

    if ((id >= 1 && id <= 5) || [124, 125, 126].contains(id)) {
      return 'price_unit'.tr();
    }
    if ((id >= 6 && id <= 11) || [13, 16, 18, 19, 20, 135].contains(id)) {
      return 'price_unit1'.tr();
    }
    if ([12, 22].contains(id)) return 'price_unit2'.tr();
    if ([14, 15, 17].contains(id)) return 'price_unit3'.tr();
    if (id == 25) return 'price_unit4'.tr();
    if (id == 86) return 'price_unit5'.tr();
    // if ((id >= 113 && id <= 117) || (id >= 145 && id <= 150)) {
    //   return 'Kyat';
    // }
    if ((id == 21 ||
        id == 23 ||
        id == 24 ||
        (id >= 26 && id <= 85) ||
        (id >= 87 && id <= 112) ||
        (id >= 118 && id <= 123) ||
        (id >= 127 && id <= 134) ||
        (id >= 136 && id <= 144))) {
      return 'price_unit6'.tr();
    }

    return '';
  }

  String? typeKey(Map<String, dynamic> item) {
    if (item['type'] == null) {
      return null;
    }
    return itemType[item['id']] ?? item['type']['0'];
  }

  dynamic priceKey(Map<String, dynamic> item) {
    if (item['price'] is String ||
        item['price'] is int ||
        item['type'] == null) {
      return item['price'];
    }

    final ty = itemType[item['id']] ?? item['type']['0'];
    for (var key in item['type'].keys) {
      if (item['type'][key] == ty) {
        return item['price'][key];
      }
    }

    return '';
  }

  void onOptionChanged(String itemID, String option) {
    itemType[itemID] = option;
    notifyListeners();
  }

  void onQuantityChanged(String itemID, int qty) {
    if (itemQty[itemID] != null) {
      itemQty[itemID] = qty;
      notifyListeners();
    }
  }

  void onCartItemQuantityChanged(String itemKey, int newQty) {
    if (cartedItems[itemKey] != null) {
      cartedItems[itemKey]!['quantity'] = newQty;
      itemQty[itemKey] = newQty;
      notifyListeners();
    }
  }

  String calculateTotalPrice() {
    num totalPrice = 0;
    int marketPriceCount = 0;

    final stringPrice = 'string_price'.tr().toLowerCase();
    final stringPriceLabel = 'string_price1'.tr();

    for (var item in cartedItems.values) {
      final rawPrice = item['selectedPrice'];
      num quantity = item['quantity'] ?? 1;

      if (rawPrice is String) {
        final price = rawPrice.tr().toLowerCase();
        if (price.contains(stringPrice)) {
          marketPriceCount += quantity.toInt();
        }
      } else if (rawPrice is int) {
        totalPrice += rawPrice * quantity;
      }
    }

    if (totalPrice == 0 && marketPriceCount > 0) {
      return '$marketPriceCount $stringPriceLabel';
    } else if (marketPriceCount > 0) {
      return 'Ks. ${formatPrice(totalPrice)} + $marketPriceCount $stringPriceLabel';
    } else {
      return 'Ks. ${formatPrice(totalPrice)}';
    }
  }

  void removeFromCart(String itemKey) {
    cartedItems.remove(itemKey);
    itemQty[itemKey] = 0;
    notifyListeners();
  }

  void addToCart(String uniqueKey, Map<String, dynamic> item, dynamic itemPrice,
      String? itemType, int itemQTY) {
    if (itemQTY > 0) {
      cartedItems[uniqueKey] = {
        'selectedItemId': item['id'],
        'selectedPrice': itemPrice,
        'selectedType': itemType,
        'quantity': itemQTY,
      };
    } else {
      cartedItems.remove(uniqueKey);
    }
    notifyListeners();
  }

  Future<void> saveFavItemsToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('favItems', jsonEncode(favItems));
  }

  Future<void> loadFavItemToLocalStorage() async {
    final pref = await SharedPreferences.getInstance();
    final favItemsString = pref.getString('favItems');
    if (favItemsString != null) {
      favItems = Map<String, Map<String, dynamic>>.from(
          jsonDecode(favItemsString)
              .map((k, v) => MapEntry(k, Map<String, dynamic>.from(v))));

      clickedItems.clear();
      clickedItems.addAll(favItems.keys);
    }
    notifyListeners();
  }

  void onFavItemAdd(String uniqueKey, Map<String, dynamic> item,
      dynamic itemPrice, String? itemType) {
    if (clickedItems.contains(uniqueKey)) {
      clickedItems.remove(uniqueKey);
      favItems.remove(uniqueKey);
    } else {
      clickedItems.add(uniqueKey);
      favItems[uniqueKey] = {
        'selectedItemId': item['id'],
        'selectedPrice': itemPrice,
        'selectedType': itemType,
      };
      print(favItems);
    }
    saveFavItemsToLocalStorage();
    notifyListeners();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
