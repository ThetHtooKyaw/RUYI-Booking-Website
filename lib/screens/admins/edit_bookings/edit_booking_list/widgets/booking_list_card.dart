import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ruyi_booking/screens/admins/edit_bookings/edit_booking_detail/edit_booking_detial.dart';
import 'package:ruyi_booking/services/booking_service.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:ruyi_booking/widgets/extras/custom_dialog.dart';

enum BookingListCardType { mobileSize, desktopSize }

class BookingListCard extends StatefulWidget {
  final BookingService bookingService;
  final Map<String, dynamic> bookingData;
  final String bookingIndex;
  final BookingListCardType type;
  const BookingListCard({
    super.key,
    required this.bookingService,
    required this.bookingData,
    required this.bookingIndex,
    this.type = BookingListCardType.mobileSize,
  });

  @override
  State<BookingListCard> createState() => _BookingListCardState();
}

class _BookingListCardState extends State<BookingListCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EditBookingDetial(
            bookingData: widget.bookingData,
          );
        }));
      },
      child: Container(
        padding: const EdgeInsets.all(AppSize.cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppSize.cardBorderRadius),
        ),
        child: Row(
          children: [
            FaIcon(
              (widget.bookingData['status'] == 'Pending')
                  ? Icons.pending_actions_rounded
                  : (widget.bookingData['status'] == 'Confirmed' ||
                          widget.bookingData['status'] == 'Completed')
                      ? FontAwesomeIcons.calendarCheck
                      : FontAwesomeIcons.calendarXmark,
              size: widget.type == BookingListCardType.mobileSize ? 35 : 45,
              color: Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking User: ${widget.bookingData['username'] ?? 'Unknown'}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Status: ${widget.bookingData['status']}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[500]),
                ),
                Text(
                  'Booking Date & Time: ${widget.bookingData['date']}, ${widget.bookingData['time']}',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.grey[500]),
                ),
              ],
            ),
            const Spacer(),
            PopupMenuButton<int>(
              onSelected: (value) async {
                if (value == 0 && widget.bookingData['status'] == 'Pending') {
                  DialogUtils.showBookingConfirmationDialog(
                    context,
                    'Confirm Booking',
                    'Are you sure you want to confirm this booking?',
                    () async {
                      await widget.bookingService.updateBookingStatus(
                          widget.bookingIndex, "Confirmed");

                      Navigator.pop(context);
                      if (mounted) {
                        setState(() {
                          widget.bookingService.refershBookingList();
                        });
                      }
                    },
                    isClickable: true,
                  );
                } else if (value == 1 &&
                    widget.bookingData['status'] == 'Confirmed') {
                  DialogUtils.showBookingConfirmationDialog(
                    context,
                    'Confirm Complete',
                    'Are you sure this booking is complete?\nOnce you click OK, you can\'t get the data back!',
                    () async {
                      await widget.bookingService.updateBookingStatus(
                          widget.bookingIndex, "Completed");

                      Navigator.pop(context);
                      if (mounted) {
                        setState(() {
                          widget.bookingService.refershBookingList();
                        });
                      }
                    },
                    isClickable: true,
                  );
                } else if (value == 2) {
                  DialogUtils.showBookingConfirmationDialog(
                    context,
                    'Confirm Delete',
                    'Are you sure you want to delete this booking?\nOnce you click OK, you can\'t get the data back!',
                    () async {
                      await widget.bookingService
                          .deleteBookingsData(widget.bookingIndex);
                      Navigator.pop(context);
                      if (mounted) {
                        setState(() {
                          widget.bookingService.refershBookingList();
                        });
                      }
                    },
                    isClickable: true,
                  );
                }
              },
              icon: Icon(
                Icons.more_vert_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  enabled: widget.bookingData['status'] == 'Pending',
                  child: Center(
                    child: Text(
                      'confirm'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: widget.bookingData['status'] == 'Pending'
                              ? AppColors.appBackground
                              : Colors.grey[500]),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 1,
                  enabled: widget.bookingData['status'] == 'Confirmed',
                  child: Center(
                    child: Text(
                      'complete'.tr(),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: widget.bookingData['status'] == 'Confirmed'
                              ? AppColors.appBackground
                              : Colors.grey[500]),
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Center(
                    child: Text(
                      'cancel'.tr(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(color: AppColors.appBackground),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
