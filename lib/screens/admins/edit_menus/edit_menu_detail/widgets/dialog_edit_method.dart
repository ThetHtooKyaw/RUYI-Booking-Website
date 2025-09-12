import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/menu_data_provider.dart';
import 'package:ruyi_booking/screens/admins/edit_menus/edit_menu_detail/widgets/dialog_add_method.dart';
import 'package:ruyi_booking/screens/admins/edit_menus/edit_menu_options/widgets/edit_text_form_field.dart';
import 'package:ruyi_booking/screens/admins/edit_menus/widgets/lang_text_field.dart';
import 'package:ruyi_booking/widgets/extras/custom_buttons.dart';
import '../../../../../utils/constants.dart';

enum BuildEditMethodType { mobileScreen, desktopScreen }

Future<dynamic> buildEditMethod(
    {required BuildContext context,
    required Map<String, dynamic> itemDetail,
    type = BuildEditMethodType.mobileScreen}) {
  return showDialog(
    context: context,
    builder: (context) {
      final createMethodKey = GlobalKey<FormState>();

      return StatefulBuilder(
        builder: (context, setState) {
          return Consumer<MenuDataProvider>(builder: (context, menuData, _) {
            return Dialog(
              backgroundColor: AppColors.appBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
              ),
              child: SizedBox(
                width: type == BuildEditMethodType.mobileScreen
                    ? MediaQuery.of(context).size.width * 0.90
                    : MediaQuery.of(context).size.width * 0.40,
                child: Stack(
                  children: [
                    Form(
                      key: createMethodKey,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSize.cardPadding),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildCreateMethodSection(context, menuData),
                            const SizedBox(height: 20),
                            Center(
                              child: ButtonUtils.forwardButton(
                                context: context,
                                width: type == BuildEditMethodType.mobileScreen
                                    ? 220
                                    : 400,
                                label: 'Create Method',
                                fontSize: 17,
                                onPressed: () {
                                  if (createMethodKey.currentState != null &&
                                      createMethodKey.currentState!
                                          .validate()) {
                                    menuData.createMenuMethod(
                                        context, itemDetail['name']);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: Text(
                                'OR',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: AppColors.appAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Center(
                              child: ButtonUtils.forwardButton(
                                context: context,
                                width: type == BuildEditMethodType.mobileScreen
                                    ? 220
                                    : 400,
                                label: 'Add Method',
                                fontSize: 17,
                                onPressed: () => buildAddMethod(
                                  context: context,
                                  menuName: itemDetail['name'],
                                  type: type == BuildEditMethodType.mobileScreen
                                      ? BuildAddMethodType.mobileScreen
                                      : BuildAddMethodType.desktopScreen,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (menuData.isDialogLoading)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black.withOpacity(0.3),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          });
        },
      );
    },
  );
}

Widget _buildCreateMethodSection(
    BuildContext context, MenuDataProvider menuData) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            'Method Key:  ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.appAccent,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: EditTextFormField(
              controller: menuData.methodKeyController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Method key is required';
                } else if (!value.startsWith('method')) {
                  return 'Key must start with "method"';
                }

                return null;
              },
              hintText: 'Enter method key (e.g. method1)',
              bgColor: Colors.white,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Text(
            'Method Name:  ',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.appAccent,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: LangTextFromField(
              controller: menuData.methodEnController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }

                return null;
              },
              labelText: "English",
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: LangTextFromField(
              controller: menuData.methodZhController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }

                return null;
              },
              labelText: "Chinese",
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: LangTextFromField(
              controller: menuData.methodMyController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Required';
                }

                return null;
              },
              labelText: "Myanmar",
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Text(
        'Noted: Mehtod key is require for language translation!',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.appAccent,
            ),
      ),
    ],
  );
}
