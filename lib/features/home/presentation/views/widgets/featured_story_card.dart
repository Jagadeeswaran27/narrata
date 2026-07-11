import 'package:flutter/material.dart';

import 'package:narrata/core/widgets/pill_button.dart';
import 'package:narrata/features/home/domain/models/story.dart';

class FeaturedStoryCard extends StatelessWidget {
  final FeaturedStoryData story;

  const FeaturedStoryCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [
          // Illustration placeholder
          Container(
            height: 220,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.3),
                  colorScheme.secondary.withValues(alpha: 0.4),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  story.icon1,
                  size: 56,
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                const SizedBox(height: 4),
                Icon(
                  story.icon2,
                  size: 36,
                  color: colorScheme.primary.withValues(alpha: 0.6),
                ),
                // Push icons up a bit so they aren't hidden by the overlay
                const SizedBox(height: 40),
              ],
            ),
          ),
          // Gradient overlay that blends from transparent to beige
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 60,
                bottom: 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.4, 1.0],
                  colors: [
                    colorScheme.secondary.withValues(alpha: 0.0),
                    colorScheme.secondary.withValues(alpha: 0.6),
                    colorScheme.secondary.withValues(alpha: 0.95),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    story.title,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: colorScheme.onSecondary,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PillButton(
                        icon: Icons.play_circle_filled,
                        label: 'Listen',
                      ),
                      SizedBox(width: 12),
                      PillButton(icon: Icons.menu_book, label: 'Read'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
