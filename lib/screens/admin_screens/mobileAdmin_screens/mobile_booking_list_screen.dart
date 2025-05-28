import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ruyi_booking/screens/admin_screens/mobileAdmin_screens/mobile_booking_data_screen.dart';
import 'package:ruyi_booking/services/booking_service.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:ruyi_booking/widgets/extras/custom_dialog.dart';

class MobileBookingListScreen extends StatefulWidget {
  const MobileBookingListScreen({super.key});

  @override
  State<MobileBookingListScreen> createState() =>
      _MobileBookingListScreenState();
}

class _MobileBookingListScreenState extends State<MobileBookingListScreen> {
  BookingService bookingService = BookingService();

  @override
  void initState() {
    super.initState();
    bookingService.refershBookingList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: bookingService.bookingListFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Text(
            'No Bookings Found!',
            style: Theme.of(context).textTheme.bodyMedium,
          ));
        } else {
          var groupBookings = bookingService.groupBookingListByDay();
          return ListView.builder(
            itemCount: groupBookings.keys.length,
            itemBuilder: (context, index) {
              String dateKey = groupBookings.keys.elementAt(index);
              List<Map<String, dynamic>> dateBookings = groupBookings[dateKey]!;

              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookingService.getformattedDateTitle(dateKey),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.appAccent,
                          fontSize: 20,
                          fontFamily: 'PlayfairDisplay'),
                    ),
                    const SizedBox(height: 10),
                    ...dateBookings.map(
                      (bookingData) {
                        String bookingIndex = bookingData['id'].toString();
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: _buildListTile(
                                context, bookingData, bookingIndex),
                          ),
                        );
                      },
                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }

  ListTile _buildListTile(BuildContext context,
      Map<String, dynamic> bookingData, String bookingIndex) {
    return ListTile(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return MobileBookingDataScreen(
            bookingData: bookingData,
          );
        }));
      },
      leading: FaIcon(
        (bookingData['status'] == 'Pending')
            ? Icons.pending_actions_rounded
            : (bookingData['status'] == 'Confirmed' ||
                    bookingData['status'] == 'Completed')
                ? FontAwesomeIcons.calendarCheck
                : FontAwesomeIcons.calendarXmark,
        size: 35,
        color: Theme.of(context).iconTheme.color,
      ),
      title: Text(
        'Booking User: ${bookingData['username'] ?? 'Unknown'}',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 15),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status: ${bookingData['status']}',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[500]),
          ),
          Text(
            'Booking Date & Time: ${bookingData['date']}, ${bookingData['time']}',
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(color: Colors.grey[500]),
          ),
        ],
      ),
      trailing: PopupMenuButton<int>(
        onSelected: (value) async {
          if (value == 0 && bookingData['status'] == 'Pending') {
            DialogUtils.showBookingConfirmationDialog(
              context,
              'Confirm Booking',
              'Are you sure you want to confirm this booking?',
              () async {
                await bookingService.updateBookingStatus(
                    bookingIndex, "Confirmed");

                Navigator.pop(context);
                if (mounted) {
                  setState(() {
                    bookingService.refershBookingList();
                  });
                }
              },
              isClickable: true,
            );
          } else if (value == 1 && bookingData['status'] == 'Confirmed') {
            DialogUtils.showBookingConfirmationDialog(
              context,
              'Confirm Complete',
              'Are you sure this booking is complete?\nOnce you click OK, you can\'t get the data back!',
              () async {
                await bookingService.updateBookingStatus(
                    bookingIndex, "Completed");

                Navigator.pop(context);
                if (mounted) {
                  setState(() {
                    bookingService.refershBookingList();
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
                await bookingService.deleteBookingsData(bookingIndex);
                Navigator.pop(context);
                if (mounted) {
                  setState(() {
                    bookingService.refershBookingList();
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
            enabled: bookingData['status'] == 'Pending',
            child: Center(
              child: Text(
                'confirm'.tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: bookingData['status'] == 'Pending'
                        ? AppColors.appBackground
                        : Colors.grey[500]),
              ),
            ),
          ),
          PopupMenuItem(
            value: 1,
            enabled: bookingData['status'] == 'Confirmed',
            child: Center(
              child: Text(
                'complete'.tr(),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: bookingData['status'] == 'Confirmed'
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
    );
  }
}
