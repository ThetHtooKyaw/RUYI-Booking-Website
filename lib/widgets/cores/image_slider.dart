import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:ruyi_booking/utils/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

enum ImageSliderType { mobileSize, desktopSize }

class ImageSlider extends StatefulWidget {
  final ImageSliderType type;
  const ImageSlider({super.key, this.type = ImageSliderType.mobileSize});

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
    return Center(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            itemCount: images.length,
            itemBuilder: (context, index, realIndex) {
              return Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: AppSize.cardPadding),
                height: 300,
                width: widget.type == ImageSliderType.mobileSize
                    ? double.infinity
                    : 800.0,
                decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(AppSize.cardBorderRadius)),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSize.cardBorderRadius),
                      child: Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 300,
                      ),
                    ),
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppSize.cardBorderRadius - 1),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.4),
                                width: 0.5),
                            borderRadius: BorderRadius.circular(
                                AppSize.cardBorderRadius - 1),
                          ),
                        ),
                      ),
                    ),
                  ],
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
