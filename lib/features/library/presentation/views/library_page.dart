import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:narrata/core/utils/logger.dart';

import 'package:narrata/core/widgets/user_library_section.dart';
import 'package:narrata/core/widgets/expandable_search_header.dart';
import 'package:narrata/features/library/presentation/view_models/library_view_model.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

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
                  title: 'LIBRARY',
                  onSearch: (query) {
                    appLogger.d('Search query: $query');
                  },
                ),
              ),

              const SizedBox(height: 16),
              
              UserLibrarySection(
                storiesAsync: ref.watch(libraryStoriesProvider),
                selectedGenre: ref.watch(librarySelectedGenreProvider),
                onGenreSelected: (genre) {
                  ref.read(librarySelectedGenreProvider.notifier).setGenre(genre);
                },
              ),
              
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
