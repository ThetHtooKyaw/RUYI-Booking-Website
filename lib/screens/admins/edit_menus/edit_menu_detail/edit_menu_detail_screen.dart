import 'package:flutter/material.dart';
import 'package:ruyi_booking/widgets/cores/responsive_layout.dart';
import 'desktop_edit_menu_detail_screen.dart';
import 'mobile_edit_menu_detail_screen.dart';

class EditMenuDetailScreen extends StatelessWidget {
  final Map<String, dynamic> itemDetail;
  const EditMenuDetailScreen({
    super.key,
    required this.itemDetail,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
        mobileBody: MobileEditMenuDetailScreen(itemDetail: itemDetail),
        deskstopBody: DesktopEditMenuDetailScreen(itemDetail: itemDetail));
  }
}
