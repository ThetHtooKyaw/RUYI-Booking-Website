import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSlider extends StatefulWidget {
  final double indicaterLeft;
  const ImageSlider({super.key, required this.indicaterLeft});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int activeIndex = 0;
  final images = [
    'assets/images/env.jpg',
    'assets/images/room2.1.jpg',
    'assets/images/kitchen.jpg',
    'assets/images/display.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    double horizontalMargin = MediaQuery.of(context).size.width > 600 ? 40 : 30;
    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            final image = images[index];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            );
          },
          options: CarouselOptions(
              height: 300,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  activeIndex = index;
                });
              }),
        ),
        Positioned(
          bottom: 20,
          left: widget.indicaterLeft,
          child: AnimatedSmoothIndicator(
            activeIndex: activeIndex,
            count: images.length,
            effect: const ExpandingDotsEffect(
              dotWidth: 10,
              dotHeight: 10,
              activeDotColor: AppColors.appAccent,
            ),
          ),
        ),
      ],
    );
  }
}
