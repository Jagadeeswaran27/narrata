import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:narrata/features/stories/domain/models/story.dart';
import 'package:narrata/features/home/presentation/views/widgets/story_tile.dart';
import 'package:narrata/features/home/presentation/views/widgets/story_tile_skeleton.dart';
import 'package:shimmer/shimmer.dart';

class UserLibrarySection extends StatelessWidget {
  final AsyncValue<List<Story>> storiesAsync;
  final String selectedGenre;
  final ValueChanged<String> onGenreSelected;

  final String? emptyMessage;

  const UserLibrarySection({
    super.key,
    required this.storiesAsync,
    required this.selectedGenre,
    required this.onGenreSelected,
    this.emptyMessage,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;

    return storiesAsync.when(
      data: (stories) {
        if (stories.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  emptyMessage ?? 'No stories found in your library.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          );
        }

        final uniqueGenres = {'All'};
        for (var story in stories) {
          if (story.title.trim().isEmpty) continue;
          final displayGenre = story.genre
              .split('_')
              .map(
                (w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '',
              )
              .join(' ');
          uniqueGenres.add(displayGenre);
        }

        final filteredStories = stories.where((story) {
          if (story.title.trim().isEmpty) return false;
          
          if (selectedGenre == 'All') return true;
          
          final displayGenre = story.genre
              .split('_')
              .map(
                (w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '',
              )
              .join(' ');
          return displayGenre == selectedGenre;
        }).toList();

        final itemWidth = (screenWidth - 40 - 16) / 2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Chips
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: uniqueGenres.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final genre = uniqueGenres.elementAt(index);
                  final isSelected = genre == selectedGenre;
                  return ChoiceChip(
                    label: Text(
                      genre,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w800
                            : FontWeight.w600,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: colorScheme.primary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? colorScheme.onPrimary
                          : colorScheme.onSurface,
                    ),
                    onSelected: (_) => onGenreSelected(genre),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Unified Grid
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Padding(
                key: ValueKey(selectedGenre),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 24,
                  children: filteredStories.map((story) {
                    return SizedBox(
                      width: itemWidth,
                      child: StoryTile(story: story),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      },
      loading: () {
        final itemWidth = (screenWidth - 40 - 16) / 2;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Chips Skeleton
            SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  return Shimmer.fromColors(
                    baseColor: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.5,
                    ),
                    highlightColor: colorScheme.surfaceContainerHighest,
                    child: Container(
                      width: index == 0 ? 50 : 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            // Unified Grid Skeleton
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 16,
                runSpacing: 24,
                children: List.generate(4, (index) {
                  return SizedBox(
                    width: itemWidth,
                    child: const StoryTileSkeleton(),
                  );
                }),
              ),
            ),
          ],
        );
      },
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}
