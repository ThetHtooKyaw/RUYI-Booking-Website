import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/admins/edit_bookings/edit_booking_list/widgets/booking_list_card.dart';
import 'package:ruyi_booking/services/booking_service.dart';
import 'package:ruyi_booking/utils/constants.dart';

class MobileEditBookingListScreen extends StatefulWidget {
  const MobileEditBookingListScreen({super.key});

  @override
  State<MobileEditBookingListScreen> createState() =>
      _MobileEditBookingListScreenState();
}

class _MobileEditBookingListScreenState
    extends State<MobileEditBookingListScreen> {
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
            style: Theme.of(context).textTheme.bodyLarge,
          ));
        } else {
          var groupBookings = bookingService.groupBookingListByDay();
          return ListView.separated(
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSize.listViewMargin),
            itemCount: groupBookings.keys.length,
            itemBuilder: (context, index) {
              String dateKey = groupBookings.keys.elementAt(index);
              List<Map<String, dynamic>> dateBookings = groupBookings[dateKey]!;

              return Padding(
                padding: const EdgeInsets.all(AppSize.screenPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bookingService.getformattedDateTitle(dateKey),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.appAccent,
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
                                borderRadius: BorderRadius.circular(
                                    AppSize.cardBorderRadius),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: BookingListCard(
                                bookingService: bookingService,
                                bookingData: bookingData,
                                bookingIndex: bookingIndex,
                              )),
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
}
