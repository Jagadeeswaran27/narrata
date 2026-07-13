import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:narrata/features/onboarding/presentation/view_models/story_selection_view_model.dart';
import 'package:narrata/features/stories/domain/models/story.dart';
import 'package:narrata/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:shimmer/shimmer.dart';

class StorySelectionPage extends ConsumerWidget {
  const StorySelectionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storiesState = ref.watch(storiesListProvider);
    final selectedStories = ref.watch(selectedStoriesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: storiesState.when(
        data: (stories) {
          final groupedStories = <String, List<Story>>{};
          for (var story in stories) {
            if (story.title.trim().isEmpty) continue;
            groupedStories.putIfAbsent(story.genre, () => []).add(story);
          }

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 100.0,
                floating: false,
                pinned: true,
                backgroundColor: theme.colorScheme.surface,
                actions: [
                  IconButton(
                    icon: Icon(Icons.logout, color: theme.colorScheme.primary),
                    onPressed: () {
                      ref.read(authViewModelProvider.notifier).signOut();
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    'Pick 7 Stories',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                  child: Text(
                    'Select exactly 7 stories to begin your journey.\n(${selectedStories.length}/7)',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final genre = groupedStories.keys.elementAt(index);
                    final genreStories = groupedStories[genre]!;
                    
                    return GenreSection(
                      genre: genre,
                      stories: genreStories,
                    );
                  },
                  childCount: groupedStories.keys.length,
                ),
              ),
              // Bottom padding for FAB
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          );
        },
        loading: () => CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 100.0,
              floating: false,
              pinned: true,
              backgroundColor: theme.colorScheme.surface,
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: theme.colorScheme.primary),
                  onPressed: () {
                    ref.read(authViewModelProvider.notifier).signOut();
                  },
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                title: Text(
                  'Pick 7 Stories',
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                child: Shimmer.fromColors(
                  baseColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  highlightColor: theme.colorScheme.surfaceContainerHighest,
                  child: Container(
                    height: 20,
                    width: 200,
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
                    child: Shimmer.fromColors(
                      baseColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      highlightColor: theme.colorScheme.surfaceContainerHighest,
                      child: Container(
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                      ),
                    ),
                  );
                },
                childCount: 4,
              ),
            ),
          ],
        ),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selectedStories.length == 7
          ? FloatingActionButton.extended(
              onPressed: () {
                ref.read(selectedStoriesProvider.notifier).completeOnboarding();
              },
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 8,
              icon: const Icon(Icons.auto_awesome),
              label: const Text(
                'Begin Journey',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            )
          : null,
    );
  }
}

class GenreSection extends ConsumerStatefulWidget {
  final String genre;
  final List<Story> stories;

  const GenreSection({
    super.key,
    required this.genre,
    required this.stories,
  });

  @override
  ConsumerState<GenreSection> createState() => _GenreSectionState();
}

class _GenreSectionState extends ConsumerState<GenreSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedStories = ref.watch(selectedStoriesProvider);

    return Column(
      children: [
        // Genre Header Card
        GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, top: 24.0, bottom: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Transform.scale(
                    scale: 1.05,
                    child: Image.asset(
                      'assets/images/genres/${widget.genre}.png',
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 160,
                        color: theme.colorScheme.primaryContainer,
                        child: const Center(child: Icon(Icons.image, size: 50)),
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20.0,
                    bottom: 20.0,
                    right: 20.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.genre.replaceAll('_', ' ').toUpperCase(),
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        Icon(
                          _isExpanded
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 32,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Stories List (Animated visibility)
        AnimatedCrossFade(
          firstChild: const SizedBox(width: double.infinity, height: 0),
          secondChild: Column(
            children: widget.stories.map((story) {
              final isSelected = selectedStories.contains(story.id);
              final title = story.title;

              return Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 6.0),
                child: Card(
                  elevation: isSelected ? 4 : 0,
                  color: isSelected
                      ? theme.colorScheme.primaryContainer
                      : theme.colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: isSelected
                          ? theme.colorScheme.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    title: Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? theme.colorScheme.onPrimaryContainer
                            : theme.colorScheme.onSurface,
                      ),
                    ),
                    subtitle: story.description.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              story.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isSelected
                                    ? theme.colorScheme.onPrimaryContainer.withAlpha(200)
                                    : theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        : null,
                    trailing: isSelected
                        ? Icon(Icons.check_circle,
                            color: theme.colorScheme.primary, size: 28)
                        : Icon(Icons.circle_outlined,
                            color: theme.colorScheme.outline, size: 28),
                    onTap: () {
                      ref
                          .read(selectedStoriesProvider.notifier)
                          .toggleStory(story.id);
                    },
                  ),
                ),
              );
            }).toList(),
          ),
          crossFadeState: _isExpanded
              ? CrossFadeState.showSecond
              : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 300),
          sizeCurve: Curves.easeInOut,
        ),
      ],
    );
  }
}
