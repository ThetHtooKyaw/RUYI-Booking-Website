import 'package:flutter/material.dart';
import '../../widgets/lang_text_field.dart';

class EditNameCategorySection extends StatelessWidget {
  final String textName;
  final TextEditingController enController;
  final TextEditingController zhController;
  final TextEditingController myController;
  const EditNameCategorySection({
    super.key,
    required this.textName,
    required this.enController,
    required this.zhController,
    required this.myController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Text(textName, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(width: 10),
            Expanded(
              child: LangTextField(
                controller: enController,
                labelText: "English",
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LangTextField(
                controller: zhController,
                labelText: "Chinese",
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: LangTextField(
                controller: myController,
                labelText: "Myanmar",
              ),
            ),
          ],
        )
      ],
    );
  }
}
