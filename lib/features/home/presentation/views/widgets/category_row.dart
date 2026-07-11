import 'package:flutter/material.dart';

import 'package:narrata/features/home/domain/models/story.dart';

class CategoryRow extends StatelessWidget {
  final List<CategoryData> categories;

  const CategoryRow({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (int i = 0; i < categories.length; i++) ...[
            if (i > 0) const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categories[i].title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 10),
                  for (final story in categories[i].stories)
                    _StoryTile(story: story),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StoryTile extends StatelessWidget {
  final StoryData story;

  const _StoryTile({required this.story});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image placeholder
        AspectRatio(
          aspectRatio: 1.0,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colorScheme.primary.withValues(alpha: 0.35),
                  colorScheme.tertiary.withValues(alpha: 0.25),
                ],
              ),
            ),
            child: Center(
              child: Icon(
                Icons.auto_stories,
                size: 36,
                color: colorScheme.onSurface.withValues(alpha: 0.35),
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
          story.duration,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}
