import 'package:flutter/material.dart';
import 'package:ruyi_booking/widgets/extras/custom_icon.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const InfoTile({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CustomIcon(
              iconImage: icon,
              size: 30,
              borderRadius: 20,
              thickness: 2,
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontFamily: 'PlayfairDisplay'),
            ),
          ],
        ),
        const Divider(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 15),
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
