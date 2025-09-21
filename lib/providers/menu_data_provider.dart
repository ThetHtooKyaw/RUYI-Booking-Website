import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ruyi_booking/classes/category.dart';
import 'package:ruyi_booking/services/menu_data_service.dart';
import 'package:ruyi_booking/utils/asset_loader.dart';
import 'package:ruyi_booking/utils/menu_data.dart';
import 'package:ruyi_booking/widgets/extras/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuDataProvider extends ChangeNotifier {
  final MenuDataService _menuDataService = MenuDataService();

  final addMethodKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImageBytes;
  String? _selectedImagePath;

  final TextEditingController searchController = TextEditingController();
  late TextEditingController nameEnController = TextEditingController();
  late TextEditingController nameMyController = TextEditingController();
  late TextEditingController nameZhController = TextEditingController();

  late TextEditingController typeEnController = TextEditingController();
  late TextEditingController typeMyController = TextEditingController();
  late TextEditingController typeZhController = TextEditingController();

  late TextEditingController priceController = TextEditingController();
  late TextEditingController priceEnController = TextEditingController();
  late TextEditingController addPriceController = TextEditingController();
  late TextEditingController createPriceController = TextEditingController();

  late TextEditingController categoryEnController = TextEditingController();
  late TextEditingController categoryMyController = TextEditingController();
  late TextEditingController categoryZhController = TextEditingController();

  late TextEditingController methodKeyController = TextEditingController();
  late TextEditingController methodEnController = TextEditingController();
  late TextEditingController methodMyController = TextEditingController();
  late TextEditingController methodZhController = TextEditingController();

  Map<String, int> itemQty = {};
  Map<String, String> itemType = {};
  Map<String, Map<String, dynamic>> favItems = {};
  Map<String, Map<String, dynamic>> cartedItems = {};
  final Set<String> clickedItems = {};
  int? clickedIndex;

  bool isClicked = false;
  bool isMenuLangLoading = false;
  bool isMenuDetailLoading = false;
  bool isEditMethodLoading = false;
  bool isDialogLoading = false;
  bool isConfirmLoading = false;

  MenuDataProvider() {
    Future.microtask(() => loadFavItemToLocalStorage());
  }

  // Shared Menu

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

  void onOptionChanged(String itemID, String option) {
    itemType[itemID] = option;
    notifyListeners();
  }

  String? typeKey(Map<String, dynamic> item) {
    final options = item['options'] is Map
        ? Map<String, dynamic>.from(item['options'])
        : <String, dynamic>{};

    final storedType = itemType[item['id']];
    if (storedType != null) {
      return storedType;
    }
    final firstKey = options.keys.first;
    final firstOption = options[firstKey] as Map<String, dynamic>?;
    return firstOption?['type']?.toString();
  }

  dynamic priceKey(Map<String, dynamic> item) {
    final options = item['options'] is Map
        ? Map<String, dynamic>.from(item['options'])
        : <String, dynamic>{};

    final storedType = itemType[item['id']];
    if (storedType != null) {
      for (final key in options.keys) {
        final option = options[key] as Map<String, dynamic>?;
        if (option != null && option['type'] == storedType) {
          return option['price'];
        }
      }
    }

    final firstKey = options.keys.first;
    final firstOption = options[firstKey] as Map<String, dynamic>?;
    return firstOption?['price'] ?? 'N/A';
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

  String formatPrice(dynamic price) {
    if (price is int) {
      return NumberFormat('#,###').format(price);
    } else {
      return price.toString().tr();
    }
  }

  // Main Menu

  String onGetPrice(Map<String, dynamic> item) {
    final itemID = item['id'];
    final unit = getPriceUnit(itemID);

    final optionsMap = item['options'] is Map
        ? Map<String, dynamic>.from(item['options'])
        : <String, dynamic>{};

    if (optionsMap.isNotEmpty && optionsMap.isNotEmpty) {
      final selectedOptions = findSelectedOptionValues(item, optionsMap);

      if (selectedOptions != null) {
        final price = selectedOptions['price'];

        if (price is int) return 'Ks. ${formatPrice(price)} $unit';
        if (price is String) return '${price.tr()} $unit';
        return 'N/A';
      }
    }

    return 'N/A';
  }

  void onQuantityChanged(String itemID, int qty) {
    if (itemQty[itemID] != null) {
      itemQty[itemID] = qty;
      notifyListeners();
    }
  }

  // Cart Menu

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

  void onCartItemQuantityChanged(String itemKey, int newQty) {
    if (cartedItems[itemKey] != null) {
      cartedItems[itemKey]!['quantity'] = newQty;
      itemQty[itemKey] = newQty;
      notifyListeners();
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

  // Fav Menu

  bool isClickedItem(String uniqueKey) => clickedItems.contains(uniqueKey);

  void isClickedIcon() {
    isClicked = !isClicked;
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

  // Admin Menu

  void setClickedIndex(int index) {
    clickedIndex = index;
    notifyListeners();
  }

  // Getter for selected image bytes
  Uint8List? get selectedImageBytes => _selectedImageBytes;

  // Getter for selected image path
  String? get selectedImagePath => _selectedImagePath;

  Future<bool> changeImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final Uint8List imageBytes = await image.readAsBytes();
        _selectedImageBytes = imageBytes;
        _selectedImagePath = image.path;
        notifyListeners();
        return true; // Success
      }
      return false; // User cancelled
    } catch (e) {
      debugPrint('Error selecting image: $e');
      return false; // Error occurred
    }
  }

  void clearSelectedImage() {
    _selectedImageBytes = null;
    _selectedImagePath = null;
    notifyListeners();
  }

  Future<void> loadMenuData() async {
    try {
      isMenuDetailLoading = true;
      notifyListeners();

      menuItems = await _menuDataService.fetchMenuData();
      // return menuData;
    } catch (e) {
      debugPrint('Error loading menu data: $e');
      rethrow;
    } finally {
      isMenuDetailLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTranslations(Map<String, dynamic> itemDetail) async {
    try {
      isMenuLangLoading = true;
      notifyListeners();

      const loader = LocalAssetLoader();
      final nameKey = itemDetail['name'];
      final categoryKey = itemDetail['category'];

      final optionsMap = itemDetail['options'] is Map
          ? Map<String, dynamic>.from(itemDetail['options'])
          : <String, dynamic>{};

      String typeText = '';
      String priceText = '';
      String? priceTranslationKey;

      if (optionsMap.isNotEmpty && optionsMap.isNotEmpty) {
        final selectedOptions =
            findSelectedOptionValues(itemDetail, optionsMap);

        if (selectedOptions != null) {
          final type = selectedOptions['type'];
          final price = selectedOptions['price'];

          if (type != null) typeText = type.toString();
          if (price is int) priceText = price.toString();
          if (price is String) priceTranslationKey = price;
        }
      }

      final en = await loader.load('translations', const Locale('en'));
      final zh = await loader.load('translations', const Locale('zh'));
      final my = await loader.load('translations', const Locale('my'));

      nameEnController.text = en[nameKey] ?? 'Loading...';
      nameZhController.text = zh[nameKey] ?? 'Loading...';
      nameMyController.text = my[nameKey] ?? 'Loading...';

      typeEnController.text = en[typeText] ?? 'Loading...';
      typeZhController.text = zh[typeText] ?? 'Loading...';
      typeMyController.text = my[typeText] ?? 'Loading...';

      priceController.text = priceText;
      priceEnController.text = en[priceTranslationKey] ?? 'Loading...';

      categoryEnController.text = en[categoryKey] ?? 'Loading...';
      categoryZhController.text = zh[categoryKey] ?? 'Loading...';
      categoryMyController.text = my[categoryKey] ?? 'Loading...';
    } catch (e) {
      debugPrint("Error loading language files: $e");
    } finally {
      isMenuLangLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateMenuData(
      BuildContext context, Map<String, dynamic> itemDetail) async {
    try {
      isEditMethodLoading = true;
      notifyListeners();

      final optionsMap = itemDetail['options'] as Map<String, dynamic>?;
      String selectedOptionsKeys = '';
      String typeID = '';

      if (optionsMap != null && optionsMap.isNotEmpty) {
        final selectedOptions =
            findSelectedOptionValues(itemDetail, optionsMap);
        if (selectedOptions != null) {
          typeID = selectedOptions['type'].toString();
          for (final key in optionsMap.keys) {
            final option = optionsMap[key] as Map<String, dynamic>?;
            if (option == selectedOptions) {
              selectedOptionsKeys = key;
              break;
            }
          }
        }

        if (selectedOptionsKeys.isEmpty) {
          selectedOptionsKeys = optionsMap.keys.first;
        }
      }

      // Update Menu Data Languages (Name, Type, Category)
      final List<Map<String, dynamic>> updatedMenuLang = [
        {
          'id': itemDetail['name'],
          'en': nameEnController.text.trim(),
          'zh': nameZhController.text.trim(),
          'my': nameMyController.text.trim(),
        },
        {
          'id': typeID,
          'en': typeEnController.text.trim(),
          'zh': typeZhController.text.trim(),
          'my': typeMyController.text.trim(),
        },
        {
          'id': itemDetail['category'],
          'en': categoryEnController.text.trim(),
          'zh': categoryZhController.text.trim(),
          'my': categoryMyController.text.trim(),
        }
      ];

      // Update Menu Data Price and Image
      Map<String, dynamic>? updatedMenuData;
      final priceText = priceController.text.trim();

      if (priceText.isNotEmpty &&
          selectedOptionsKeys.isNotEmpty &&
          optionsMap != null) {
        final updatedOptions = Map<String, dynamic>.from(optionsMap);

        updatedOptions.forEach((key, value) {
          if (key == selectedOptionsKeys) {
            final selectedOption =
                updatedOptions[selectedOptionsKeys] as Map<String, dynamic>;

            selectedOption['price'] = int.tryParse(priceText) ?? priceText;
            updatedOptions[key] = selectedOption;
          } else {
            updatedOptions[key] = value;
          }
        });

        updatedMenuData = {
          'id': itemDetail['id'],
          'options': updatedOptions,
        };
      }

      // Upload image to Firebase Storage if a new image was selected
      if (_selectedImageBytes != null) {
        final imageUrl = await _menuDataService.uploadImage(
            itemDetail['id'], _selectedImageBytes!);
        if (imageUrl != null) {
          updatedMenuData ??= {
            'id': itemDetail['id'],
          };
          updatedMenuData['image'] = imageUrl;
        } else {
          DialogUtils.showBookingConfirmationDialog(
            context,
            'UPLOAD FAILED!',
            'Failed to upload image. Please try again.',
            () {
              Navigator.pop(context);
            },
          );
          return;
        }
      }

      bool success = await _menuDataService.updateMenuData(
          updatedMenuLang, updatedMenuData!);

      if (success) {
        final message = _selectedImageBytes != null
            ? 'Menu Data and Image have been successfully updated!'
            : 'Menu Data has been successfully updated!';

        DialogUtils.showBookingConfirmationDialog(
          context,
          'UPDATE SUCCESSFUL!',
          message,
          () {
            Navigator.pop(context);
          },
        );

        // Clear selected image since it's now saved
        if (_selectedImageBytes != null) {
          clearSelectedImage();
        }
      }

      await loadMenuData();
    } catch (e) {
      debugPrint("Error updating menu data: $e");
    } finally {
      isEditMethodLoading = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> fetchMenuMethods() async {
    try {
      final menuMethods = await _menuDataService.fetchMenuMethods();
      return menuMethods;
    } catch (e) {
      debugPrint("Error fetching menu methods: $e");
      return [];
    }
  }

  Stream<List<Map<String, dynamic>>> fetchMenuMethodsStream() {
    try {
      final menuMehtod = _menuDataService.fetchMenuMethodsStream();
      return menuMehtod;
    } catch (e) {
      debugPrint("Error fetching menu methods: $e");
      return Stream.value([]);
    }
  }

  Stream<Map<String, dynamic>> fetchMenuOption(String menuName) {
    final menu = menuItems.firstWhere(
      (m) => m['name'] == menuName,
      orElse: () => {},
    );

    if (menu.isEmpty) return const Stream.empty();

    return _menuDataService.fetchMenuOption(menu['id']);
  }

  Future<void> createMenuMethod(
    BuildContext context,
    String menuName,
  ) async {
    try {
      isDialogLoading = true;
      notifyListeners();

      final menuMethods = await fetchMenuMethods();
      final methodKey = methodKeyController.text.trim();
      final existKey = menuMethods.any((m) => m['id'] == methodKey);

      final menu = menuItems.firstWhere(
        (m) => m['name'] == menuName,
        orElse: () => {},
      );

      if (menu.isEmpty) return;

      // Create Menu Method key and Languages

      if (existKey) {
        DialogUtils.showBookingConfirmationDialog(
          context,
          'DUPLICATE KEY!',
          'The method key "$methodKey" already exists. Please use another one.',
          () {
            Navigator.pop(context);
          },
        );
        return;
      }

      final newMenuMethod = {
        'id': methodKey,
        'en': methodEnController.text.trim(),
        'zh': methodZhController.text.trim(),
        'my': methodMyController.text.trim(),
      };

      // Add Menu Method Key

      final options = Map<String, dynamic>.from(menu['options'] ?? {});
      final firstIndexKey = options.keys.first;
      final exisitingOption =
          Map<String, dynamic>.from(options[firstIndexKey] ?? []);
      exisitingOption['type'] = methodKey;
      options[firstIndexKey] = exisitingOption;
      menu['options'] = options;

      bool success =
          await _menuDataService.createMenuMethod(newMenuMethod, menu);

      if (success) {
        DialogUtils.showBookingConfirmationDialog(
          context,
          'CREATION SUCCESSFUL!',
          'Menu method has been successfully Created!',
          () {
            Navigator.pop(context);
            Navigator.pop(context);
            methodKeyController.clear();
            methodEnController.clear();
            methodZhController.clear();
            methodMyController.clear();
          },
        );
      }
    } catch (e) {
      debugPrint("Error creating menu method: $e");
    } finally {
      isDialogLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMenuMethod(
    BuildContext context,
    String menuName,
    String methodName,
  ) async {
    try {
      isDialogLoading = true;
      notifyListeners();

      final menu = menuItems.firstWhere(
        (m) => m['name'] == menuName,
        orElse: () => {},
      );

      if (menu.isEmpty) return;

      final options = Map<String, dynamic>.from(menu['options'] ?? {});
      final firstIndexKey = options.keys.first;
      final exisitingOption =
          Map<String, dynamic>.from(options[firstIndexKey] ?? []);
      exisitingOption['type'] = methodName;
      options[firstIndexKey] = exisitingOption;
      menu['options'] = options;

      bool success = await _menuDataService.addMenuMethod(menu);

      if (success && context.mounted) {
        DialogUtils.showBookingConfirmationDialog(
          context,
          'ADDITION SUCCESSFUL!',
          'Menu method has been successfully Added!',
          () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      debugPrint("Error adding menu method: $e");
    } finally {
      isDialogLoading = false;
      notifyListeners();
    }
  }

  Future<void> createMenuOption(
    BuildContext context,
    String menuName,
  ) async {
    try {
      isDialogLoading = true;
      notifyListeners();

      final menuMethods = await fetchMenuMethods();
      final price = createPriceController.text.trim();
      final methodKey = methodKeyController.text.trim();
      final existKey = menuMethods.any((m) => m['id'] == methodKey);

      final menu = menuItems.firstWhere(
        (m) => m['name'] == menuName,
        orElse: () => {},
      );

      if (menu.isEmpty) return;

      // Create Menu Method key and Languages

      if (existKey) {
        DialogUtils.showBookingConfirmationDialog(
          context,
          'DUPLICATE KEY!',
          'The method key "$methodKey" already exists. Please use another one.',
          () {
            Navigator.pop(context);
          },
        );
        return;
      }

      final newMenuMethod = {
        'id': methodKey,
        'en': methodEnController.text.trim(),
        'zh': methodZhController.text.trim(),
        'my': methodMyController.text.trim(),
      };

      // Create Menu Method Price

      final options = Map<String, dynamic>.from(menu['options'] ?? {});
      final newIndex = options.length.toString();
      options[newIndex] = {'type': methodKey, 'price': int.tryParse(price)};
      menu['options'] = options;

      bool success =
          await _menuDataService.createMenuOption(newMenuMethod, menu);

      if (success) {
        DialogUtils.showBookingConfirmationDialog(
          context,
          'CREATION SUCCESSFUL!',
          'Menu Option has been successfully Created!',
          () {
            Navigator.pop(context);
            Navigator.pop(context);
            methodKeyController.clear();
            methodEnController.clear();
            methodZhController.clear();
            methodMyController.clear();
            createPriceController.clear();
          },
        );
      }
    } catch (e) {
      debugPrint("Error creating menu option: $e");
    } finally {
      isDialogLoading = false;
      notifyListeners();
    }
  }

  Future<void> addMenuOption(
    BuildContext context,
    String menuName,
    String methodName,
  ) async {
    if (addMethodKey.currentState != null &&
        addMethodKey.currentState!.validate()) {
      try {
        isDialogLoading = true;
        notifyListeners();

        final priceText = addPriceController.text.trim();

        final menu = menuItems.firstWhere(
          (m) => m['name'] == menuName,
          orElse: () => {},
        );

        if (menu.isEmpty) return;

        final options = Map<String, dynamic>.from(menu['options'] ?? {});
        final newIndex = options.length.toString();
        options[newIndex] = {
          'type': methodName,
          'price': int.tryParse(priceText)
        };
        menu['options'] = options;

        bool success = await _menuDataService.addMenuOption(menu);

        if (success && context.mounted) {
          addPriceController.clear();
          clickedIndex = null;
          notifyListeners();

          DialogUtils.showBookingConfirmationDialog(
            context,
            'ADDITION SUCCESSFUL!',
            'Menu Option has been successfully Added!',
            () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        }
      } catch (e) {
        debugPrint("Error adding menu option: $e");
      } finally {
        isDialogLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> removeMenuOption(
    BuildContext context,
    String menuName,
    String optionKey,
  ) async {
    DialogUtils.showBookingConfirmationDialog(
      context,
      'CONFIRM REMOVAL!',
      'This will remove the menu option permanently.\nAre you sure?',
      () async {
        try {
          isConfirmLoading = true;
          notifyListeners();

          final menu = menuItems.firstWhere(
            (m) => m['name'] == menuName,
            orElse: () => {},
          );

          if (menu.isEmpty) return;

          final options = Map<String, dynamic>.from(menu['options'] ?? {});
          if (!options.containsKey(optionKey)) {
            debugPrint("Option $optionKey not found in ${menu['name']}");
            return;
          }

          options.remove(optionKey);
          menu['options'] = options;

          await _menuDataService.removeMenuOption(menu);
          Navigator.pop(context);
        } catch (e) {
          debugPrint("Error removing menu option: $e");
        } finally {
          isConfirmLoading = false;
          notifyListeners();
        }
      },
      isClickable: true,
    );
  }

  Future<void> removeMenuMethod(
    BuildContext context,
    String menuName,
    String methodKey,
  ) async {
    DialogUtils.showBookingConfirmationDialog(
      context,
      'CONFIRM REMOVAL!',
      'This will remove the menu method permanently.\nAre you sure?',
      () async {
        try {
          isConfirmLoading = true;
          notifyListeners();

          final menuMethods = await fetchMenuMethods();
          final existKey = menuMethods.any((m) => m['id'] == methodKey);

          if (!existKey) {
            DialogUtils.showBookingConfirmationDialog(
              context,
              'KEY DOESN\'T EXIST!',
              'The method key "$methodKey" does not exist. Please use another one.',
              () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            );
            return;
          }

          await _menuDataService.removeMenuMethod(methodKey);
          Navigator.pop(context);
          Navigator.pop(context);
        } catch (e) {
          debugPrint("Error removing menu methods: $e");
        } finally {
          isConfirmLoading = false;
          notifyListeners();
        }
      },
      isClickable: true,
    );
  }

  Map<String, dynamic>? findSelectedOptionValues(
      Map<String, dynamic> itemDetail, Map<String, dynamic> optionsMap) {
    if (optionsMap.length == 1) {
      return optionsMap.values.first;
    } else {
      final selectedType = itemType[itemDetail['id']]?.toString();

      if (selectedType == null) return optionsMap.values.first;

      for (final option in optionsMap.values) {
        if (option['type']?.toString() == selectedType) {
          return option;
        }
      }
    }

    return optionsMap.values.first;
  }

  bool onShowPriceString(Map<String, dynamic> item) {
    final optionsMap = item['options'] is Map
        ? Map<String, dynamic>.from(item['options'])
        : <String, dynamic>{};

    final selectedOptions = findSelectedOptionValues(optionsMap, optionsMap);

    final price = selectedOptions!['price'];

    if (price != null && price is String) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    searchController.dispose();

    nameEnController.dispose();
    nameMyController.dispose();
    nameZhController.dispose();

    typeEnController.dispose();
    typeMyController.dispose();
    typeZhController.dispose();

    priceController.dispose();
    priceEnController.dispose();
    addPriceController.dispose();
    createPriceController.dispose();

    categoryEnController.dispose();
    categoryMyController.dispose();
    categoryZhController.dispose();

    methodKeyController.dispose();
    methodEnController.dispose();
    methodMyController.dispose();
    methodZhController.dispose();
    super.dispose();
  }
}
