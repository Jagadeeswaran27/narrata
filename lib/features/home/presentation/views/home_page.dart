import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:narrata/features/home/presentation/views/widgets/featured_story_carousel.dart';
import 'package:narrata/features/home/presentation/view_models/home_view_model.dart';
import 'package:narrata/core/widgets/user_library_section.dart';
import 'package:narrata/core/widgets/section_title.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        elevation: 0,
      ),
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
                child: Center(
                  child: Text(
                    'NARRATA',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ── FEATURED STORIES ──
              const SectionTitle(title: 'Featured Stories'),
              const SizedBox(height: 12),

              // Featured story carousel
              const FeaturedStoryCarousel(),
              const SizedBox(height: 28),

              // ── YOUR LIBRARY ──
              const SectionTitle(title: 'Your Library'),
              const SizedBox(height: 16),

              UserLibrarySection(
                storiesAsync: ref.watch(userStoriesProvider),
                selectedGenre: ref.watch(selectedGenreProvider),
                onGenreSelected: (genre) {
                  ref.read(selectedGenreProvider.notifier).setGenre(genre);
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
