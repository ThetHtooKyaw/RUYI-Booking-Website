import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imagePath;
  const CustomNetworkImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imagePath,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(
          color: AppColors.appAccent,
        ),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.broken_image,
        size: 50,
        color: Colors.grey,
      ),
    );
  }
}
