import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class BookingService {
  var db = FirebaseFirestore.instance;
  List<Map<String, dynamic>> bookings = [];
  Future<List<Map<String, dynamic>>>? bookingListFuture;

  Future<void> savingBookingData(
      {required String name,
      required String phNo,
      required String email,
      required String date,
      required String time,
      required int guests,
      required String roomType,
      required String roomName,
      required Map<String, Map<String, dynamic>> menuList}) async {
    try {
      await db.collection('bookings').add({
        "username": name,
        "ph_number": phNo,
        "email": email,
        "date": date,
        "time": time,
        "guest": guests,
        "room_type": roomType,
        "room_name": roomName,
        "menu_list": menuList,
        "status": "Pending",
        "timestamp": FieldValue.serverTimestamp(),
      });
      debugPrint('Booking added successfully!');
    } catch (e) {
      debugPrint('Error adding booking to Firestore: $e');
    }
  }

  Future<void> updateBookingStatus(String bookingId, String newStatus) async {
    try {
      if (bookingId.isEmpty) throw Exception("Error: Booking ID is empty!");

      await db
          .collection('bookings')
          .doc(bookingId)
          .update({"status": newStatus});

      if (newStatus == 'Confirmed') {
        await sendEmail(bookingId);
      }

      debugPrint('Booking updated successfully!');
    } catch (e) {
      debugPrint('Error updating booking to Firestore: $e');
    }
  }

  Future<void> sendEmail(String bookingId) async {
    try {
      DocumentSnapshot bookingSnapshot =
          await db.collection('bookings').doc(bookingId).get();

      if (!bookingSnapshot.exists) throw Exception('Error: Booking not found!');

      await db.collection("emails").add({
        "from": {
          "email": "admin@ruyi-restaurant.xyz",
        },
        "to": [
          {
            "email": bookingSnapshot['email'],
          }
        ],
        "subject": "Table Booking Confirmation",
        "text": "Your booking with ID: $bookingId has been confirmed.",
        "html": """<p>Dear <strong>${bookingSnapshot['username']}</strong>,<p>
        <p>Thank you for booking a table at <strong>The RUYI Chinese Cuisine</strong>! Here are your booking details:
        </p><p><strong>Booking ID:</strong> $bookingId</p>
        <p><strong>Name:</strong> ${bookingSnapshot['username']}</p>
        <p><strong>Phone:</strong> ${bookingSnapshot['ph_number']}</p>
        <p><strong>Email:</strong> ${bookingSnapshot['email']}</p>
        <p><strong>Date:</strong> ${bookingSnapshot['date']}</p>
        <p><strong>Time:</strong> ${bookingSnapshot['time']}</p>
        <p><strong>Number of Guests:</strong> ${bookingSnapshot['guest']}</p>
        <p><strong>Room Type:</strong> ${bookingSnapshot['room_type']}</p>
        <p><strong>Room Name:</strong> ${bookingSnapshot['room_name']}</p>
        <p><strong>Menu List:</strong> ${bookingSnapshot['menu_list'].length}</p>

        <p>If you need to modify or cancel your reservation, please contact us at these phone number <strong>09-986619999, 09-986629999</strong>.</p>
        <p>We look forward to serving you!</p>

        <p>Best regards,<br>
        <strong>The RUYI Chinese Cuisine</strong><br>
        """,
      });
      debugPrint('Email successfully sent to user!');
    } catch (e) {
      debugPrint('Error sending email to user: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchBookingList() async {
    try {
      await deletePastBookings();

      QuerySnapshot bookingSnapshot = await db
          .collection('bookings')
          .orderBy('timestamp', descending: false)
          .get();

      bookings = bookingSnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id;
        return data;
      }).toList();

      if (bookings.isNotEmpty) {
        sortBookingList();
      }

      return bookings;
    } catch (e) {
      debugPrint('Error fetching booking list from Firestore: $e');
      return [];
    }
  }

  void refershBookingList() {
    bookingListFuture = fetchBookingList();
  }

  Future<List<Map<String, dynamic>>> fetchBookedTableNo(String date) async {
    try {
      final bookedSnapshot = await db
          .collection('bookings')
          .where('date', isEqualTo: date)
          .where('room_type', isEqualTo: 'General Dining Room')
          .get();

      return bookedSnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Error fetching booked table number from Firestore: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchBookedVipRooms(String date) async {
    try {
      final bookedSnapshot = await db
          .collection('bookings')
          .where('date', isEqualTo: date)
          .where('room_type', isEqualTo: 'Private VIP Room')
          .get();

      return bookedSnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Error fetching booked VIP rooms from Firestore: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> fetchBookedVipBigRooms(String date) async {
    try {
      final bookedSnapshot = await db
          .collection('bookings')
          .where('date', isEqualTo: date)
          .where('room_type', isEqualTo: 'Private VIP Big Room')
          .get();

      return bookedSnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint('Error fetching booked VIP Big rooms from Firestore: $e');
      return [];
    }
  }

  Future<void> addDisabledDate(String dateFormatted) async {
    try {
      await db
          .collection('disabled_dates')
          .doc(dateFormatted)
          .set({'date': dateFormatted});
    } catch (e) {
      debugPrint('Error adding disabled date to Firestore: $e');
    }
  }

  Future<List<DateTime>> fetchDisabledDate() async {
    try {
      var fetchedDates = await db.collection('disabled_dates').get();
      return fetchedDates.docs.map((doc) {
        return DateFormat('MM-dd-yyyy').parse(doc.id);
      }).toList();
    } catch (e) {
      debugPrint('Error fetchinng disabled date from Firestore: $e');
      return [];
    }
  }

  Future<void> removeDisabledDate(String dateFormatted) async {
    try {
      await db.collection('disabled_dates').doc(dateFormatted).delete();
    } catch (e) {
      debugPrint('Error removing disabled date from Firestore: $e');
    }
  }

  Future<void> deletePastBookings() async {
    try {
      QuerySnapshot bookingSnapshot = await db
          .collection('bookings')
          .orderBy('timestamp', descending: false)
          .get();

      for (var doc in bookingSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String date = data['date'] ?? '';
        String time = data['time'] ?? '00:00 AM';
        DateTime bookingDateTime = parseTimeToDateTime(date, time);

        if (bookingDateTime.isBefore(DateTime.now())) {
          await db.collection('bookings').doc(doc.id).delete();
        }
      }
    } catch (e) {
      debugPrint('Error deleting past bookings from Firestore: $e');
    }
  }

  Future<void> deleteBookingsData(String bookingIndex) async {
    try {
      DocumentSnapshot docShnapshot =
          await db.collection('bookings').doc(bookingIndex).get();

      if (!docShnapshot.exists)
        throw Exception('Error: Booking document does not exist!');

      await db.collection('bookings').doc(bookingIndex).delete();
    } catch (e) {
      debugPrint('Error deleting booking data from Firestore: $e');
    }
  }

  void sortBookingList() {
    try {
      bookings.sort((a, b) {
        String dateA = a['date'] ?? '';
        String timeA = a['time'] ?? '00:00 AM';
        String dateB = b['date'] ?? '';
        String timeB = b['time'] ?? '00:00 AM';

        DateTime dateTimeA = parseTimeToDateTime(dateA, timeA);
        DateTime dateTimeB = parseTimeToDateTime(dateB, timeB);

        return dateTimeA.compareTo(dateTimeB);
      });
    } catch (e) {
      debugPrint('Error sorting bookings from Firestore: $e');
    }
  }

  DateTime parseTimeToDateTime(String dateString, String timeString) {
    try {
      List<String> dateParts = dateString.split('-');
      if (dateParts.length != 3) return DateTime.now();

      int month = int.parse(dateParts[0]);
      int day = int.parse(dateParts[1]);
      int year = int.parse(dateParts[2]);

      DateTime format12Hour = DateFormat.jm().parse(timeString);
      String format24Hour = DateFormat.Hm().format(format12Hour);
      List<String> timeParts = format24Hour.split(':');

      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1]);
      return DateTime(year, month, day, hour, minute);
    } catch (e) {
      debugPrint('Error parsing time from Firestore: $e');
      return DateTime.now();
    }
  }

  Map<String, List<Map<String, dynamic>>> groupBookingListByDay() {
    Map<String, List<Map<String, dynamic>>> groupedBookings = {};

    for (var booking in bookings) {
      String bookingDate = booking['date'] ?? '';
      if (groupedBookings.containsKey(bookingDate)) {
        groupedBookings[bookingDate]!.add(booking);
      } else {
        groupedBookings[bookingDate] = [booking];
      }
    }

    return groupedBookings;
  }

  String getformattedDateTitle(String dateString) {
    try {
      List<String> dateParts = dateString.split('-');
      if (dateParts.length == 3) {
        String formattedDate =
            "${dateParts[2]}-${dateParts[0]}-${dateParts[1]}";
        DateTime parseDate = DateTime.parse(formattedDate);
        return DateFormat('MMMM dd, yyyy').format(parseDate);
      }
    } catch (e) {
      return 'Invalid Date';
    }
    return 'Invalid Date';
  }
}
