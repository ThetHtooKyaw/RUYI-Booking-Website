import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';

class MobileEditMenuOptionsScreen extends StatefulWidget {
  final Map<String, dynamic> menuOption;
  const MobileEditMenuOptionsScreen({super.key, required this.menuOption});

  @override
  State<MobileEditMenuOptionsScreen> createState() =>
      _MobileEditMenuOptionsScreenState();
}

class _MobileEditMenuOptionsScreenState
    extends State<MobileEditMenuOptionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60,
        leadingWidth: 70,
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.keyboard_arrow_left_rounded,
            size: 40,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSize.screenPadding),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSize.listViewMargin),
                itemCount: widget.menuOption.length,
                itemBuilder: (context, index) {
                  final optionIndex = widget.menuOption['index'];
                  return Container(
                    padding: const EdgeInsets.all(AppSize.cardPadding),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(AppSize.cardBorderRadius)),
                    child: ListTile(
                      leading: Text(
                        'Menu Type: ${optionIndex}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
