import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:narrata/core/widgets/bottom_nav_bar.dart';
import 'package:narrata/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:narrata/features/home/domain/models/story.dart';
import 'package:narrata/features/home/presentation/views/widgets/category_row.dart';
import 'package:narrata/features/home/presentation/views/widgets/featured_story_carousel.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── App Bar ──
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    // Logo icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: colorScheme.secondary.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.pets,
                        size: 22,
                        color: colorScheme.secondary,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'NARRATA',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                    ),
                    const Spacer(),
                    // Logout button
                    IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      onPressed: () {
                        ref.read(authViewModelProvider.notifier).signOut();
                      },
                    ),
                    const SizedBox(width: 8),
                    // Circular search button
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: Icon(
                          Icons.search,
                          color: colorScheme.onPrimary,
                          size: 20,
                        ),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Greeting ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Goodnight, Leo! 🌙',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6),

              // ── FEATURED STORIES ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'FEATURED STORIES',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Featured story carousel
              const FeaturedStoryCarousel(),
              const SizedBox(height: 28),

              // ── EXPLORE STORIES ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'EXPLORE STORIES',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Category: Bedtime Classics & Magical Animals (side-by-side)
              CategoryRow(
                categories: [
                  CategoryData(
                    title: 'Bedtime Classics',
                    stories: [StoryData("The Sleepy Bear's Picnic", '8 mins')],
                  ),
                  CategoryData(
                    title: 'Magical Animals',
                    stories: [
                      StoryData('Lily and the Starlight Deer', '8 mins'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Category: Fairy Tales & Nature Adventures
              CategoryRow(
                categories: [
                  CategoryData(
                    title: 'Fairy Tales',
                    stories: [StoryData('The Crystal Wand', '7 mins')],
                  ),
                  CategoryData(
                    title: 'Nature Adventures',
                    stories: [StoryData('Whispers in the Woods', '6 mins')],
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavBar(),
    );
  }
}
