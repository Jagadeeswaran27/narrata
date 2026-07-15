import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:narrata/core/services/download_service.dart';
import 'package:narrata/features/home/presentation/views/widgets/story_tile.dart';

class DownloadsPage extends ConsumerWidget {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloadedStoriesMap = ref.watch(downloadedStoriesProvider);
    final stories = downloadedStoriesMap.values.toList();
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - 40 - 16) / 2;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        title: Text(
          'DOWNLOADS',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: 2.0,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: stories.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    'No downloaded stories yet.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Wrap(
                  spacing: 16,
                  runSpacing: 24,
                  children: stories.map((story) {
                    return SizedBox(
                      width: itemWidth,
                      child: StoryTile(story: story),
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }
}
