import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:narrata/core/widgets/storage_image.dart';
import 'package:narrata/features/stories/domain/models/story.dart';

class StoryTile extends StatelessWidget {
  final Story story;

  const StoryTile({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        context.push('/story-read', extra: story);
      },
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image thumbnail
        AspectRatio(
          aspectRatio: 1.0,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Transform.scale(
              scale: 1.05,
              child: StorageImage(
                path: story.thumbnailPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          story.title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          '${story.readingTime} mins',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
      ),
    );
  }
}

class StoryHorizontalCard extends StatelessWidget {
  final Story story;

  const StoryHorizontalCard({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: () {
        context.push('/story-read', extra: story);
      },
      child: Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Image thumbnail
          AspectRatio(
            aspectRatio: 1.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: StorageImage(
                path: story.thumbnailPath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  story.title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '${story.readingTime} mins',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}
