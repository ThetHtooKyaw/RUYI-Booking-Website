import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/asset_loader.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/cores/menu_type_picker.dart';

class MobileMenuDetail extends StatefulWidget {
  final Map<String, dynamic> itemDetail;
  const MobileMenuDetail({super.key, required this.itemDetail});

  @override
  State<MobileMenuDetail> createState() => _MobileMenuDetailState();
}

class _MobileMenuDetailState extends State<MobileMenuDetail> {
  late TextEditingController nameEnController;
  late TextEditingController nameMyController;
  late TextEditingController nameZhController;

  late TextEditingController typeEnController;
  late TextEditingController typeMyController;
  late TextEditingController typeZhController;

  late TextEditingController categoryEnController;
  late TextEditingController categoryMyController;
  late TextEditingController categoryZhController;
  bool isLoading = true;

  Future<void> loadTranslations() async {
    try {
      final itemDetail = widget.itemDetail;
      const loader = LocalAssetLoader();
      final nameKey = itemDetail['name'];
      final typeMap = Map<String, dynamic>.from(itemDetail['type'] ?? {});
      final firstMethodKey = typeMap['0'] ?? '';
      final categoryKey = itemDetail['category'];

      final en = await loader.load('translations', const Locale('en'));
      final zh = await loader.load('translations', const Locale('zh'));
      final my = await loader.load('translations', const Locale('my'));

      nameEnController = TextEditingController(text: en[nameKey] ?? '');
      nameZhController = TextEditingController(text: zh[nameKey] ?? '');
      nameMyController = TextEditingController(text: my[nameKey] ?? '');

      typeEnController = TextEditingController(text: en[firstMethodKey] ?? '');
      typeZhController = TextEditingController(text: zh[firstMethodKey] ?? '');
      typeMyController = TextEditingController(text: my[firstMethodKey] ?? '');

      categoryEnController = TextEditingController(text: en[categoryKey] ?? '');
      categoryZhController = TextEditingController(text: zh[categoryKey] ?? '');
      categoryMyController = TextEditingController(text: my[categoryKey] ?? '');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading language files: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    loadTranslations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                buildHeadImage(context),
                buildNameAndCategory(context, "Menu Name:", nameEnController,
                    nameZhController, nameMyController),
                buildDivider(),
                // buildCategoryAndPrice(context),
                buildDivider(),
                buildNameAndCategory(
                    context,
                    "Menu Category:",
                    categoryEnController,
                    categoryZhController,
                    categoryMyController),
              ],
            ),
    );
  }

  Padding buildCategoryAndPrice(BuildContext context) {
    final item = widget.itemDetail;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Menu Type",
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 18),
          ),
          Row(
            children: [
              MenuTypePicker(
                itemId: item['id'],
                itemType: item['type'],
                key: ObjectKey(item['id']),
              ),
              const SizedBox(width: 10),
              buildTextField(
                controller: typeEnController,
                labelText: "English",
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField(
                  controller: typeZhController,
                  labelText: "Chinese",
                ),
                const SizedBox(width: 10),
                buildTextField(
                  controller: typeMyController,
                  labelText: "Myanmar",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Divider(
        thickness: 2,
      ),
    );
  }

  Widget buildNameAndCategory(
      BuildContext context,
      String textName,
      TextEditingController enController,
      TextEditingController zhController,
      TextEditingController myController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              children: [
                Text(
                  textName,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(fontSize: 18),
                ),
                const SizedBox(width: 10),
                buildTextField(
                  controller: enController,
                  labelText: "English",
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField(
                  controller: zhController,
                  labelText: "Chinese",
                ),
                const SizedBox(width: 10),
                buildTextField(
                  controller: myController,
                  labelText: "Myanmar",
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Expanded(
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.name,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            color: AppColors.appAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget buildHeadImage(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          child: SizedBox(
            width: double.infinity,
            height: 400,
            child: Hero(
              tag: 'hero-image-${widget.itemDetail['image']}',
              child: Image.asset(
                widget.itemDetail['image'],
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.keyboard_arrow_left_rounded,
              size: 60,
              color: AppColors.appAccent,
            ),
          ),
        )
      ],
    );
  }
}
