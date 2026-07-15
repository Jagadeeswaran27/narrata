import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:narrata/core/utils/logger.dart';

import 'package:narrata/core/widgets/user_library_section.dart';
import 'package:narrata/core/widgets/expandable_search_header.dart';
import 'package:narrata/features/favorites/presentation/view_models/favorites_view_model.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
      ),
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
                child: ExpandableSearchHeader(
                  title: 'FAVORITES',
                  onSearch: (query) {
                    appLogger.d('Search query: $query');
                  },
                ),
              ),

              const SizedBox(height: 16),
              
              UserLibrarySection(
                storiesAsync: ref.watch(favoritesViewModelProvider),
                selectedGenre: ref.watch(favoritesSelectedGenreProvider),
                onGenreSelected: (genre) {
                  ref.read(favoritesSelectedGenreProvider.notifier).setGenre(genre);
                },
                emptyMessage: "You haven't favorited any stories yet.",
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
