import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:narrata/features/home/domain/models/story.dart';
import 'package:narrata/features/home/presentation/views/widgets/featured_story_card.dart';

class FeaturedStoryCarousel extends StatelessWidget {
  const FeaturedStoryCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 220,
        enlargeCenterPage: true,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        viewportFraction: 0.85,
      ),
      items: featuredStories.map((story) {
        return Builder(
          builder: (BuildContext context) {
            return FeaturedStoryCard(story: story);
          },
        );
      }).toList(),
    );
  }
}
