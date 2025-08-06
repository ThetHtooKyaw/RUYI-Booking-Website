import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/booking_data_provider.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatelessWidget {
  final DateTime selectedDate;
  final void Function(DateTime) onDateChanged;
  const Calendar(
      {super.key, required this.selectedDate, required this.onDateChanged});

  @override
  Widget build(BuildContext context) {
    var bookingData = Provider.of<BookingDataProvider>(context);
    return Container(
      width: 550,
      height: 550,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
      child: TableCalendar(
        focusedDay: selectedDate,
        firstDay: DateTime.utc(2024, 1, 1),
        lastDay: DateTime.utc(2040, 1, 1),
        selectedDayPredicate: (day) => isSameDay(day, selectedDate),
        enabledDayPredicate: (day) {
          return !bookingData.disabledDates.contains(day);
        },
        onDaySelected: (day, _) {
          onDateChanged(day);
        },
        daysOfWeekHeight: 60,
        rowHeight: 60,
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            fontSize: MediaQuery.of(context).size.width < 430 ? 20 : 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          dowTextFormatter: (date, locale) =>
              DateFormat.E(locale).format(date).toUpperCase(),
          weekdayStyle: const TextStyle(fontWeight: FontWeight.bold),
          weekendStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
        calendarStyle: CalendarStyle(
          cellMargin: EdgeInsets.zero,
          outsideDaysVisible: false,
          defaultDecoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 0.5,
            ),
          ),
          weekendDecoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Colors.black,
              width: 0.5,
            ),
          ),
          weekendTextStyle: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.normal),
          todayDecoration: BoxDecoration(
            color: AppColors.hoverColor,
            border: Border.all(
              color: Colors.black,
              width: 0.5,
            ),
          ),
          selectedDecoration: BoxDecoration(
            color: AppColors.appAccent,
            border: Border.all(
              color: Colors.black,
              width: 0.5,
            ),
          ),
          disabledDecoration: BoxDecoration(
            color: Colors.grey,
            border: Border.all(
              color: Colors.black,
              width: 0.5,
            ),
          ),
        ),
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, date, _) {
            if (bookingData.isDisabledDate(date)) {
              return Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      border: Border.all(
                        color: Colors.black,
                        width: 0.5,
                      ),
                    ),
                    child: Text(
                      '${date.day}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const Positioned(
                      top: 0,
                      child: Icon(
                        Icons.disabled_by_default,
                        color: Colors.grey,
                      )),
                ],
              );
            }
            return null;
          },
        ),
      ),
    );
  }
}
