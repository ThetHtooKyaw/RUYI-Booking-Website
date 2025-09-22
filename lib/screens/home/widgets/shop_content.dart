import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/extras/custom_icon.dart';

enum ShopContentType { mobileSize, desktopSize }

class ShopContent extends StatelessWidget {
  final ShopContentType type;
  const ShopContent({super.key, this.type = ShopContentType.mobileSize});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: type == ShopContentType.mobileSize
          ? const EdgeInsets.symmetric(horizontal: AppSize.screenPadding)
          : const EdgeInsets.all(0),
      child: Column(
        mainAxisAlignment: type == ShopContentType.mobileSize
            ? MainAxisAlignment.center
            : MainAxisAlignment.start,
        children: [
          _buildInfoTile(
              context: context,
              icon: Icons.access_time_filled_rounded,
              title: 'open_hour'.tr(),
              content: 'Daily : 9 AM - 10 PM'),
          const SizedBox(height: 20),
          _buildInfoTile(
              context: context,
              icon: Icons.location_on_rounded,
              title: 'location'.tr(),
              content:
                  'Address : No.(1A/2B+2kha/2H), Mindama Street, (3)Ward Mayangone Township, Yangon'),
          const SizedBox(height: 20),
          _buildInfoTile(
              context: context,
              icon: Icons.phone,
              title: 'contact_us'.tr(),
              content:
                  'Phone Numberc: 09-986619999, 09-986629999\nEmail : yinli5027770@gmail.com'),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
  }) {
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
                  .titleSmall
                  ?.copyWith(fontFamily: 'PlayfairDisplay'),
            ),
          ],
        ),
        const Divider(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 15),
          child: Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
