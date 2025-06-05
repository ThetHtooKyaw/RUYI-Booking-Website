import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int activeIndex = 0;
  final images = [
    'assets/images/env.jpg',
    'assets/images/room1.jpg',
    'assets/images/room2.1.jpg',
    'assets/images/kitchen.jpg',
    'assets/images/display.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final maxWidth =
        MediaQuery.of(context).size.width > 900 ? 800.0 : double.infinity;

    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            itemCount: images.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                width: maxWidth,
                child: Image.asset(
                  images[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 300,
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
      ),
    );
  }
}
