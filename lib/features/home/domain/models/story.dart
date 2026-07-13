import 'package:flutter/material.dart';
import 'package:narrata/features/stories/domain/models/story.dart';

class CategoryData {
  final String title;
  final List<Story> stories;

  CategoryData({required this.title, required this.stories});
}

class FeaturedStoryData {
  final String title;
  final IconData icon1;
  final IconData icon2;

  FeaturedStoryData(this.title, this.icon1, this.icon2);
}

final List<FeaturedStoryData> featuredStories = [
  FeaturedStoryData(
    'THE MOONLIT ADVENTURE\nOF OLIVER OWL',
    Icons.nightlight_round,
    Icons.forest,
  ),
  FeaturedStoryData(
    'THE BRAVE LITTLE\nSTAR EXPLORER',
    Icons.star,
    Icons.rocket_launch,
  ),
  FeaturedStoryData(
    'THE SECRET GARDEN\nBEYOND THE WALL',
    Icons.local_florist,
    Icons.eco,
  ),
  FeaturedStoryData(
    'THE SLEEPY DRAGON\nOF MOUNT PUFF',
    Icons.cloud,
    Icons.castle,
  ),
];
