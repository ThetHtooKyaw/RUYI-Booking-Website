import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ruyi_booking/providers/bookingDataProvider.dart';

class GuestCounter extends StatefulWidget {
  final double width;
  final double height;
  final void Function(int) onGuestNumberChanged;

  const GuestCounter({
    super.key,
    required this.onGuestNumberChanged,
    required this.width,
    required this.height,
  });

  @override
  State<GuestCounter> createState() => _GuestCounterState();
}

class _GuestCounterState extends State<GuestCounter> {
  @override
  Widget build(BuildContext context) {
    var bookingData = Provider.of<BookingDataProvider>(context);
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButton(context, Icons.remove_rounded, () {
            if (bookingData.guestCounter > 1) {
              setState(() {
                bookingData.guestCounter--;
              });
              widget.onGuestNumberChanged(bookingData.guestCounter);
            }
          }),
          Text(
            '${bookingData.guestCounter} Guest${bookingData.guestCounter != 1 ? 's' : ''}',
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(fontSize: 18),
          ),
          _buildButton(context, Icons.add, () {
            if (bookingData.guestCounter < 20) {
              setState(() {
                bookingData.guestCounter++;
              });
              widget.onGuestNumberChanged(bookingData.guestCounter);
            }
          }),
        ],
      ),
    );
  }

  Container _buildButton(
      BuildContext context, IconData icon, VoidCallback onPressed) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          size: 25,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
  }
}
