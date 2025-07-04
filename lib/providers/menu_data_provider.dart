import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  bool isClicked = false;

  void isClickedIcon() {
    isClicked = !isClicked;
    notifyListeners();
  }

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
    final id = int.tryParse(item['id']);
    if ((item['category'].toString().tr() == 'category2'.tr() &&
            item['id'] != '15') ||
        item['category'].toString().tr() == 'category4'.tr() ||
        item['category'].toString().tr() == 'category6'.tr() ||
        item['category'].toString().tr() == 'category10'.tr() ||
        [27, 136, 138].contains(id)) {
      return true;
    }
    return false;
  }

  String onGetPrice(Map<String, dynamic> item) {
    final itemID = item['id'];
    final unit = getPriceUnit(itemID);

    final typesMap =
        item['type'] is Map ? Map<String, dynamic>.from(item['type']) : {};
    final priceMap =
        item['price'] is Map ? Map<String, dynamic>.from(item['price']) : {};

    if (typesMap.isEmpty && priceMap.length == 1) {
      final firstValue = priceMap.entries.first.value;
      if (firstValue is int) return 'Ks. ${formatPrice(firstValue)} $unit';
      if (firstValue is String) return '${firstValue.tr()} $unit';
    }

    final selectedLabel = itemType[itemID]?.toString().tr();
    final defaultLabel =
        typesMap.isNotEmpty ? typesMap.values.first.toString().tr() : '';
    final effectiveLabel = selectedLabel ?? defaultLabel;

    String? matchKey;
    typesMap.forEach(
      (key, value) {
        if (value.toString().tr() == effectiveLabel) matchKey = key;
      },
    );
    if (matchKey != null && priceMap.containsKey(matchKey)) {
      final price = priceMap[matchKey];

      if (itemID == '46' || itemID == '47') {
        return matchKey == '0'
            ? 'Ks. ${formatPrice(price)} ${'price_unit6'.tr()}'
            : '${price.toString().tr()} ${'price_unit1'.tr()}';
      }

      return 'Ks. ${formatPrice(price)} $unit';
    }

    return 'N/A';
  }

  String onGetCartPrice(Map<String, dynamic> item) {
    final itemID = item['itemId'];
    final unit = getPriceUnit(itemID);
    final price = item['selectedPrice'];

    if (price is String) return '${price.tr()} $unit';
    if (item['selectedType'] == null || price is int) {
      return 'Ks. ${formatPrice(price)} $unit';
    }

    return 'N/A';
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
    final typesMap = item['type'];
    return itemType[item['id']] ?? typesMap?['0'];
  }

  dynamic priceKey(Map<String, dynamic> item) {
    final typesMap = item['type'];
    final priceMap = item['price'];

    if ((typesMap == null || typesMap.isEmpty) &&
        (priceMap != null && priceMap.isNotEmpty)) {
      final firstValue = priceMap.values.first;
      if (firstValue is String || firstValue is int) {
        return firstValue;
      }
    }

    final selectedType = itemType[item['id']] ?? typesMap?['0'];
    for (final key in typesMap.keys) {
      if (typesMap[key] == selectedType) {
        return priceMap[key];
      }
    }

    return 'N/A';
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

  Future<void> updateCartItemQty(
      Map<String, dynamic> bookingData, String uniqueKey, int newQty) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingData['id'])
          .update({
        FieldPath(['menu_list', uniqueKey, 'quantity']): newQty
      });

      if (bookingData['menu_list'] is Map<String, dynamic>) {
        bookingData['menu_list'][uniqueKey]['quantity'] = newQty;
      }

      debugPrint('Menu quantity updated successfully');
    } catch (e) {
      debugPrint('Error updating menu\'s quantity to Firestore: $e');
    }
    notifyListeners();
  }

  Future<void> removeCartItem(
      Map<String, dynamic> bookingData, String uniqueKey) async {
    try {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingData['id'])
          .update({
        FieldPath(['menu_list', uniqueKey]): FieldValue.delete(),
      });

      if (bookingData['menu_list'] is Map<String, dynamic>) {
        bookingData['menu_list'].remove(uniqueKey);
      }

      debugPrint('Menu item removed successfully');
    } catch (e) {
      debugPrint('Error removing menu item to Firestore: $e');
    }
    notifyListeners();
  }

  String calculateTotalPrice(dynamic items) {
    num totalPrice = 0;
    int marketPriceCount = 0;

    final stringPrice = 'string_price'.tr().toLowerCase();
    final stringPriceLabel = 'string_price1'.tr();

    for (var item in items.values) {
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

  void addToCart(
    String uniqueKey,
    Map<String, dynamic> item,
    dynamic itemPrice,
    String? itemType,
    int itemQTY,
  ) {
    if (itemQTY > 0) {
      cartedItems[uniqueKey] = {
        'itemId': item['id'],
        'itemImage': item['image'],
        'itemName': item['name'],
        'selectedPrice': itemPrice,
        'selectedType': itemType,
        'quantity': itemQTY,
      };
    } else {
      cartedItems.remove(uniqueKey);
    }
    notifyListeners();
  }

  void removeFromCart(String itemKey) {
    cartedItems.remove(itemKey);
    itemQty[itemKey] = 0;
    notifyListeners();
  }

  Future<void> saveFavItemsToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final currentTime = DateTime.now().millisecondsSinceEpoch;

    await prefs.setString('favItems', jsonEncode(favItems));
    await prefs.setInt('favItemsTimestamp', currentTime);
  }

  Future<void> loadFavItemToLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final favItemsString = prefs.getString('favItems');
    final savedTimestamp = prefs.getInt('favItemsTimestamp');

    if (favItemsString != null && savedTimestamp != null) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final difference = now - savedTimestamp;

      if (difference < 86400000) {
        favItems = Map<String, Map<String, dynamic>>.from(
            jsonDecode(favItemsString)
                .map((k, v) => MapEntry(k, Map<String, dynamic>.from(v))));

        clickedItems.clear();
        clickedItems.addAll(favItems.keys);
      } else {
        await prefs.remove('favItems');
        await prefs.remove('favItemsTimestamp');
        favItems.clear();
        clickedItems.clear();
      }
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
        'itemId': item['id'],
        'itemImage': item['image'],
        'itemName': item['name'],
        'selectedType': itemType,
        'selectedPrice': itemPrice,
      };
    }

    saveFavItemsToLocalStorage();
    notifyListeners();
  }

  void onFavItemRemove(String uniqueKey) {
    if (clickedItems.contains(uniqueKey)) {
      clickedItems.remove(uniqueKey);
      favItems.remove(uniqueKey);
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
