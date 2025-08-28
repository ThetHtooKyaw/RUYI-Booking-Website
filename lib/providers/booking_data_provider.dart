import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/screens/bookings/booking_detail/booking_detail_screen.dart';
import 'package:ruyi_booking/screens/home/home_screen.dart';
import 'package:ruyi_booking/services/booking_service.dart';
import 'package:ruyi_booking/widgets/extras/custom_dialog.dart';

class BookingDataProvider extends ChangeNotifier {
  final BookingService _bookingService = BookingService();

  final formKey = GlobalKey<FormState>();
  DateTime selectedDate = DateTime.now();
  String formattedDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
  Set<DateTime> disabledDates = {};
  String? dateErrorText;
  String selectedTime = DateFormat('h:mm a').format(DateTime.now());
  int guestCounter = 1;
  String? selectedRoomtype;
  String? selectedRoomName;

  final List<String> _tableNo = [
    'Table 1',
    'Table 2',
    'Table 3',
    'Table 4',
    'Table 5',
    'Table 6',
    'Table 7',
    'Table 8',
    'Table 9',
    'Table 10',
    'Table 11'
  ];

  final List<String> _vipRooms = [
    'VIP 1',
    'VIP 2',
    'VIP 3',
    'VIP 5',
    'VIP 6',
    'VIP 8',
    'VIP 9',
    'VIP 10',
    'VIP 11',
    'VIP 12'
  ];

  final List<String> _vipBigRooms = ['VIP 888', 'VIP 999'];

  List<Map<String, dynamic>> bookedTableNo = [];
  List<Map<String, dynamic>> bookedVipRooms = [];
  List<Map<String, dynamic>> bookedVipBigRooms = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController phNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  BookingDataProvider() {
    fetchDisabledDate();
  }

  bool isDateInPast(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(date.year, date.month, date.day);
    return selected.isBefore(today);
  }

  bool isDisabledDate(DateTime date) {
    return disabledDates.any((d) =>
        d.year == date.year && d.month == date.month && d.day == date.day);
  }

  Future<void> addDisabledDate(DateTime date) async {
    try {
      DateTime normalizedDate = DateTime(date.year, date.month, date.day);
      disabledDates.add(normalizedDate);

      String dateFormatted = DateFormat('MM-dd-yyyy').format(normalizedDate);
      await _bookingService.addDisabledDate(dateFormatted);
    } catch (e) {
      debugPrint('Error adding disabled date: $e');
    }
    notifyListeners();
  }

  Future<void> fetchDisabledDate() async {
    try {
      List<DateTime> fetchedDates = await _bookingService.fetchDisabledDate();

      disabledDates.clear();
      for (var date in fetchedDates) {
        disabledDates.add(DateTime(date.year, date.month, date.day));
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetchinng disabled date: $e');
    }
  }

  Future<void> removeDisabledDate(DateTime date) async {
    try {
      disabledDates.removeWhere((d) =>
          d.year == date.year && d.month == date.month && d.day == date.day);
      debugPrint('Updated Disabled Dates: $disabledDates');
      String dateFormatted = DateFormat('MM-dd-yyyy').format(date);
      await _bookingService.removeDisabledDate(dateFormatted);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing disabled date: $e');
    }
  }

  void onSelectedDate(DateTime date) {
    if (isDateInPast(date)) {
      dateErrorText = 'Please select a valid date!';
    } else if (isDisabledDate(date)) {
      dateErrorText = 'This date is unavailable for booking!';
    } else {
      selectedDate = date;
      formattedDate = DateFormat('MM-dd-yyyy').format(date);
      dateErrorText = null;

      fetchBookedRoomsAndTable();
    }
    notifyListeners();
  }

  void onTimeChanged(String time) {
    selectedTime = time.isNotEmpty ? time : selectedTime;
    notifyListeners();
  }

  void onGuestCounterChanged(int counter) {
    guestCounter = counter;
    notifyListeners();
  }

  bool isTableNoAvailable() => _tableNo.any(
      (room) => !bookedTableNo.any((booked) => booked['room_name'] == room));

  bool isVipRoomAvailable() => _vipRooms.any(
      (room) => !bookedVipRooms.any((booked) => booked['room_name'] == room));

  bool isVipBigRoomAvailable() => _vipBigRooms.any((room) =>
      !bookedVipBigRooms.any((booked) => booked['room_name'] == room));

  void onRoomTypeChange(String? roomType) {
    if (roomType == 'Private VIP Room' && isVipRoomAvailable()) {
      final availableRoom = _vipRooms.firstWhere(
        (room) => !bookedVipRooms.any((booked) => booked['room_name'] == room),
        orElse: () => '',
      );
      if (availableRoom.isNotEmpty) {
        selectedRoomtype = roomType;
        selectedRoomName = availableRoom;
      }
    } else if (roomType == 'Private VIP Big Room' && isVipBigRoomAvailable()) {
      final availableRoom = _vipBigRooms.firstWhere(
        (room) =>
            !bookedVipBigRooms.any((booked) => booked['room_name'] == room),
        orElse: () => '',
      );
      if (availableRoom.isNotEmpty) {
        selectedRoomtype = roomType;
        selectedRoomName = availableRoom;
      }
    } else {
      final availableRoom = _tableNo.firstWhere(
        (room) => !bookedTableNo.any((booked) => booked['room_name'] == room),
        orElse: () => '',
      );
      if (availableRoom.isNotEmpty) {
        selectedRoomtype = roomType;
        selectedRoomName = availableRoom;
      }
    }
    notifyListeners();
  }

  Future<void> fetchBookedRoomsAndTable() async {
    try {
      bookedTableNo = await _bookingService.fetchBookedTableNo(formattedDate);
      bookedVipRooms = await _bookingService.fetchBookedVipRooms(formattedDate);
      bookedVipBigRooms =
          await _bookingService.fetchBookedVipBigRooms(formattedDate);
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching booked VIP rooms: $e');
    }
  }

  void resetForm(
      BuildContext context, Map<String, Map<String, dynamic>> menuData) {
    selectedDate = DateTime.now();
    formattedDate = DateFormat('MM-dd-yyyy').format(DateTime.now());
    dateErrorText = null;
    selectedTime = DateFormat('h:mm a').format(DateTime.now());
    guestCounter = 1;
    selectedRoomtype = null;
    selectedRoomName = null;
    nameController.clear();
    phNoController.clear();
    emailController.clear();
    menuData.clear();
    notifyListeners();
    Navigator.pop(context);
  }

  void continueBooking(BuildContext context) {
    if (formKey.currentState != null && formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BookingDetailScreen()),
      );
    }
  }

  Future<void> savingBooking(
      BuildContext context, Map<String, Map<String, dynamic>> menuList) async {
    try {
      await _bookingService.savingBookingData(
        name: nameController.text.trim(),
        phNo: phNoController.text.trim(),
        email: emailController.text.trim(),
        date: formattedDate,
        time: selectedTime,
        guests: guestCounter,
        roomType: selectedRoomtype ?? '',
        roomName: selectedRoomName ?? '',
        menuList: menuList,
      );
      DialogUtils.showBookingConfirmationDialog(
        context,
        'Booking Successful',
        'Your booking is currently pending confirmation.\nWe will notify you once it\'s confirmed!',
        () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          });
          resetForm(context, menuList);
        },
        isClickable: false,
      );
    } catch (e) {
      DialogUtils.showErrorDialog(context, e.toString());
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phNoController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
