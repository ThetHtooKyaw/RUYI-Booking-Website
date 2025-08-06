import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';

class ItemCounter extends StatelessWidget {
  final int quantity;
  final void Function(int) onQuantityChanged;
  final VoidCallback? onZeroQuantityReached;

  const ItemCounter({
    super.key,
    required this.quantity,
    required this.onQuantityChanged,
    this.onZeroQuantityReached,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildButton(Icons.remove_rounded, () {
            if (quantity < 2) {
              onZeroQuantityReached?.call();
            } else if (quantity > 0) {
              onQuantityChanged(quantity - 1);
            }
          }),
          Flexible(
            child: Text(
              quantity.toString(),
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: MediaQuery.of(context).size.width < 430 ? 14 : 18),
            ),
          ),
          _buildButton(Icons.add, () {
            onQuantityChanged(quantity + 1);
          }),
        ],
      ),
    );
  }

  Widget _buildButton(IconData icon, VoidCallback onPressed) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: AppColors.appAccent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: onPressed,
        icon: Icon(icon, size: 25, color: Colors.white),
      ),
    );
  }
}
