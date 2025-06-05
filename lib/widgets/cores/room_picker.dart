import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';

class RoomPicker extends StatelessWidget {
  final double width;
  final String? selectedRoomtype;
  final void Function(String?) onRoomTypeChange;
  final bool Function() isVipRoomAvailable;
  final bool Function() isVipBigRoomAvailable;
  final bool Function() isTableNoAvailable;
  const RoomPicker(
      {super.key,
      required this.width,
      required this.selectedRoomtype,
      required this.onRoomTypeChange,
      required this.isVipRoomAvailable,
      required this.isVipBigRoomAvailable,
      required this.isTableNoAvailable});

  static const List<String> _roomTypes = [
    'General Dining Room',
    'Private VIP Room',
    'Private VIP Big Room',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButtonFormField<String>(
            value: selectedRoomtype,
            onChanged: onRoomTypeChange,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a room type';
              } else if (value == 'General Dining Room' &&
                  !isTableNoAvailable()) {
                return 'No table available at the moment';
              } else if (value == 'Private VIP Room' && !isVipRoomAvailable()) {
                return 'No VIP rooms available at the moment';
              } else if (value == 'Private VIP Big Room' &&
                  !isVipBigRoomAvailable()) {
                return 'No VIP big rooms available at the moment';
              }

              return null;
            },
            items: _roomTypes.map((room) {
              return DropdownMenuItem<String>(
                value: room,
                child: Text(
                  room,
                  style: const TextStyle(color: AppColors.appBackground),
                ),
              );
            }).toList(),
            selectedItemBuilder: (context) {
              return _roomTypes.map((value) {
                return Text(
                  value,
                  style: const TextStyle(color: Colors.black),
                );
              }).toList();
            },
            dropdownColor: AppColors.appAccent,
            isDense: true,
            hint: Text(
              'Select room type',
              style: TextStyle(color: Colors.grey[500]),
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: -4),
              errorStyle: const TextStyle(
                fontSize: 15,
                color: AppColors.appAccent,
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: AppColors.appAccent),
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Theme.of(context).iconTheme.color,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
