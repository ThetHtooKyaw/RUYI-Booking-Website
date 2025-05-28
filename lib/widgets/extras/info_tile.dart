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
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: ListTile(
            leading: CustomIcon(
              iconImage: icon,
              size: 30,
              borderRadius: 20,
              thickness: 2,
            ),
            title: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontFamily: 'PlayfairDisplay'),
            ),
          ),
        ),
        const Divider(
          indent: 30,
          endIndent: 30,
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 40, right: 20),
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}
