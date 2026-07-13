import 'dart:ui';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:narrata/features/stories/domain/models/story.dart';
import 'package:narrata/features/stories/presentation/view_models/story_favorite_view_model.dart';
import 'package:narrata/features/stories/presentation/views/widgets/audio_visualizer.dart';
import 'package:narrata/features/stories/presentation/views/widgets/royal_divider.dart';
import 'package:narrata/core/widgets/storage_image.dart';

// We'll manage the AudioPlayer in a simple StatefulWidget for easier lifecycle control
// tied directly to this specific screen, as it's a 1:1 relationship.

class StoryReadPage extends ConsumerStatefulWidget {
  final Story story;

  const StoryReadPage({super.key, required this.story});

  @override
  ConsumerState<StoryReadPage> createState() => _StoryReadPageState();
}

class _StoryReadPageState extends ConsumerState<StoryReadPage> {
  late AudioPlayer _audioPlayer;
  bool _isAudioReady = false;
  String? _audioUrl;

  // Highlight tracking
  final ValueNotifier<int> _currentWordIndex = ValueNotifier<int>(-1);
  final ScrollController _scrollController = ScrollController();
  late List<TapGestureRecognizer> _wordRecognizers;
  double? _dragValue;
  
  bool _isReadMode = false;
  double _fontSizeMultiplier = 1.0;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();

    _wordRecognizers = List.generate(widget.story.timestamps.length, (index) {
      return TapGestureRecognizer()
        ..onTap = () {
          final ts = widget.story.timestamps[index];
          _audioPlayer.seek(
            Duration(milliseconds: (ts.startTime * 1000).toInt()),
          );
          if (_audioPlayer.playing != true) {
            _audioPlayer.play();
          }
        };
    });

    _audioPlayer.positionStream.listen((position) {
      if (_dragValue == null) {
        _updateHighlightedWord(position);
      }
    });
  }

  @override
  void dispose() {
    for (var recognizer in _wordRecognizers) {
      recognizer.dispose();
    }
    _audioPlayer.dispose();
    _scrollController.dispose();
    _currentWordIndex.dispose();
    super.dispose();
  }

  Future<void> _initAudio() async {
    try {
      if (widget.story.audioPath.isNotEmpty) {
        final ref = FirebaseStorage.instance.ref().child(
          widget.story.audioPath,
        );
        _audioUrl = await ref.getDownloadURL();
        if (_audioUrl != null) {
          String? thumbnailUrl;
          try {
            if (widget.story.thumbnailPath.isNotEmpty) {
              final thumbRef = FirebaseStorage.instance.ref().child(widget.story.thumbnailPath);
              thumbnailUrl = await thumbRef.getDownloadURL();
            }
          } catch (e) {
            debugPrint('Could not fetch thumbnail URL for media item: $e');
          }

          final audioSource = AudioSource.uri(
            Uri.parse(_audioUrl!),
            tag: MediaItem(
              id: widget.story.id,
              title: widget.story.title,
              album: 'Narrata',
              artist: widget.story.genre.replaceAll('_', ' ').toUpperCase(),
              artUri: thumbnailUrl != null ? Uri.parse(thumbnailUrl) : null,
            ),
          );

          await _audioPlayer.setAudioSource(audioSource);
          if (mounted) {
            setState(() {
              _isAudioReady = true;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error initializing audio: $e');
    }
  }

  void _updateHighlightedWord(Duration position) {
    if (widget.story.timestamps.isEmpty) return;

    final currentSeconds = position.inMilliseconds / 1000.0;

    int newIndex = -1;
    for (int i = 0; i < widget.story.timestamps.length; i++) {
      final ts = widget.story.timestamps[i];
      if (currentSeconds >= ts.startTime) {
        if (i == widget.story.timestamps.length - 1 ||
            currentSeconds < widget.story.timestamps[i + 1].startTime) {
          newIndex = i;
          break;
        }
      }
    }

    if (newIndex != _currentWordIndex.value) {
      _currentWordIndex.value = newIndex;
      _scrollToCurrentWord();
    }
  }

  void _scrollToCurrentWord() {
    if (!_scrollController.hasClients ||
        widget.story.timestamps.isEmpty ||
        _currentWordIndex.value < 0) {
      return;
    }

    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    final viewportHeight = _scrollController.position.viewportDimension;
    final currentScroll = _scrollController.offset;

    final progress = _currentWordIndex.value / widget.story.timestamps.length;
    final estimatedWordY = (maxScroll + viewportHeight) * progress;

    // Check if the word is hitting the bottom of the visible area
    // We leave about 60px of padding at the bottom so it scrolls right before it goes completely off-screen
    final isBelowVisibleArea =
        estimatedWordY > (currentScroll + viewportHeight - 60);

    // Check if the word is above the visible area (e.g. if user manually scrolled down)
    final isAboveVisibleArea = estimatedWordY < currentScroll + 20;

    if (isBelowVisibleArea || isAboveVisibleArea) {
      // Scroll the text up so the current word is roughly at the top 30% of the screen
      final targetScroll = (estimatedWordY - (viewportHeight * 0.3)).clamp(
        0.0,
        maxScroll,
      );

      _scrollController.animateTo(
        targetScroll,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        forceMaterialTransparency: true,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: _buildModeToggle(colorScheme),
        centerTitle: true,
        actions: [
          if (_isReadMode)
            IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.text_fields, color: Colors.white, size: 20),
              ),
              onPressed: _showFontSettings,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // 1. Blurred Background Cover Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.6,
            child: StorageImage(
              path: widget.story.thumbnailPath,
              fit: BoxFit.cover,
            ),
          ),

          // Blur overlay for background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.6,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                ),
              ),
            ),
          ),

          // 1.5. Vertical Action Buttons at Top Right
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            top: MediaQuery.of(context).padding.top + 8,
            right: _isReadMode ? -80 : 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final isFavoriteAsync = ref.watch(storyFavoriteStatusProvider(widget.story.id));
                    final isFavorite = isFavoriteAsync.value ?? false;

                    return GestureDetector(
                      onTap: () {
                        ref.read(storyFavoriteActionProvider.notifier)
                           .toggleFavorite(widget.story.id, isFavorite);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border, 
                          color: Colors.white, 
                          size: 20
                        ),
                      ),
                    );
                  }
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.cloud_sync_outlined, color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.file_download_outlined, color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),

          // 2. Clear Foreground Cover Image (Smaller)
          Positioned(
            top: MediaQuery.of(context).padding.top + kToolbarHeight + 10,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Hero(
                  tag: 'story_cover_${widget.story.id}',
                  child: Container(
                    width: size.width * 0.5,
                    height: size.width * 0.5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: StorageImage(
                      path: widget.story.thumbnailPath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Audio Controls (Play/Pause and Progress)
                if (_isAudioReady)
                  Column(
                    children: [
                      StreamBuilder<PlayerState>(
                        stream: _audioPlayer.playerStateStream,
                        builder: (context, snapshot) {
                          final playerState = snapshot.data;
                          final processingState = playerState?.processingState;
                          final playing = playerState?.playing;
                          final isLoading = processingState == ProcessingState.loading ||
                              processingState == ProcessingState.buffering;

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AudioVisualizer(
                                isPlaying: playing == true,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 32),
                                if (isLoading)
                                  _buildPlayButton(
                                    Icons.play_arrow,
                                    () {},
                                    colorScheme,
                                    isLoading: true,
                                  )
                                else if (playing != true)
                                  _buildPlayButton(
                                    Icons.play_arrow,
                                    () => _audioPlayer.play(),
                                    colorScheme,
                                  )
                                else if (processingState !=
                                    ProcessingState.completed)
                                  _buildPlayButton(
                                    Icons.pause,
                                    () => _audioPlayer.pause(),
                                    colorScheme,
                                  )
                                else
                                  _buildPlayButton(
                                    Icons.replay,
                                    () => _audioPlayer.seek(Duration.zero),
                                    colorScheme,
                                  ),
                              const SizedBox(width: 32),
                              AudioVisualizer(
                                isPlaying: playing == true,
                                color: Colors.white,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      // Audio Progress Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 48),
                        child: StreamBuilder<Duration>(
                          stream: _audioPlayer.positionStream,
                          builder: (context, snapshot) {
                            final position = snapshot.data ?? Duration.zero;
                            final duration =
                                _audioPlayer.duration ?? Duration.zero;

                            double max = duration.inMilliseconds.toDouble();
                            if (max <= 0) max = 1.0;
                            double current = position.inMilliseconds.toDouble();

                            return SliderTheme(
                              data: SliderThemeData(
                                trackHeight: 4,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                                overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 14,
                                ),
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white.withValues(
                                  alpha: 0.2,
                                ),
                                thumbColor: Colors.white,
                                overlayColor: Colors.white.withValues(
                                  alpha: 0.1,
                                ),
                              ),
                              child: Slider(
                                min: 0.0,
                                max: max,
                                value: (_dragValue ?? current).clamp(0.0, max),
                                onChanged: (value) {
                                  setState(() {
                                    _dragValue = value;
                                  });
                                  _updateHighlightedWord(
                                    Duration(milliseconds: value.toInt()),
                                  );
                                },
                                onChangeEnd: (value) {
                                  _audioPlayer.seek(
                                    Duration(milliseconds: value.toInt()),
                                  );
                                  setState(() {
                                    _dragValue = null;
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        'Loading audio...',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontStyle: FontStyle.italic,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
              ],
            ),
          ),

          // 3. Scrollable Text Card
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            top: _isReadMode ? MediaQuery.of(context).padding.top + kToolbarHeight + 16 : size.height * 0.55,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF4EAD5), // Parchment / Old paper color
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 30,
                    offset: const Offset(0, -10),
                  ),
                  BoxShadow(
                    color: const Color(
                      0xFF8B5A2B,
                    ).withValues(alpha: 0.1), // Subtle warm inner shadow feel
                    blurRadius: 20,
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Stylish Royal Divider (Drag Handle)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: RoyalDivider(color: Color(0xFF8B5A2B), width: 140),
                    ),
                  ),

                  // Title & Genre
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.story.title,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.story.genre.replaceAll('_', ' ').toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Text Content
                  Expanded(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                      child: _buildStoryText(colorScheme),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayButton(
    IconData icon,
    VoidCallback onPressed,
    ColorScheme colorScheme, {
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: colorScheme.primary,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: isLoading 
            ? Padding(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  color: colorScheme.onPrimary,
                  strokeWidth: 3,
                ),
              )
            : Icon(icon, color: colorScheme.onPrimary, size: 32),
      ),
    );
  }

  Widget _buildStoryText(ColorScheme colorScheme) {
    if (widget.story.timestamps.isEmpty) {
      // Fallback if no timestamps
      return Text(
        widget.story.content,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontSize: 18 * _fontSizeMultiplier,
          height: 1.8,
          color: const Color(0xFF3E2723), // Dark brown ink
        ),
      );
    }

    // Wrap with RichText for highlighted words
    return ValueListenableBuilder<int>(
      valueListenable: _currentWordIndex,
      builder: (context, currentIndex, child) {
        return RichText(
          textAlign: TextAlign.justify,
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 18 * _fontSizeMultiplier,
              height: 1.8,
              color: const Color(0xFF3E2723), // Dark brown ink base
            ),
            children: List.generate(widget.story.timestamps.length, (index) {
              final word = widget.story.timestamps[index].word;
              final isHighlighted = index == currentIndex && !_isReadMode;

              return TextSpan(
                text: '$word ',
                style: TextStyle(
                  color: isHighlighted
                      ? const Color(
                          0xFFD84315,
                        ) // Deep rusty orange/red for highlight
                      : const Color(0xFF3E2723),
                  fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                ),
                recognizer: _isReadMode ? null : _wordRecognizers[index],
              );
            }),
          ),
        );
      },
    );
  }

  Widget _buildModeToggle(ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildToggleOption(
            title: 'Listen',
            icon: Icons.headphones,
            isSelected: !_isReadMode,
            onTap: () {
              setState(() {
                _isReadMode = false;
              });
            },
          ),
          _buildToggleOption(
            title: 'Read',
            icon: Icons.menu_book,
            isSelected: _isReadMode,
            onTap: () {
              setState(() {
                _isReadMode = true;
                _audioPlayer.pause();
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildToggleOption({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.black : Colors.white,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showFontSettings() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF4EAD5),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Text Size',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF3E2723),
                ),
              ),
              const SizedBox(height: 24),
              StatefulBuilder(
                builder: (context, setSheetState) {
                  return Row(
                    children: [
                      const Text('A', style: TextStyle(fontSize: 14, color: Color(0xFF3E2723))),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: const Color(0xFF8B5A2B),
                            inactiveTrackColor: const Color(0xFF8B5A2B).withValues(alpha: 0.2),
                            thumbColor: const Color(0xFF8B5A2B),
                          ),
                          child: Slider(
                            value: _fontSizeMultiplier,
                            min: 0.8,
                            max: 1.5,
                            divisions: 7,
                            onChanged: (value) {
                              setSheetState(() {
                                _fontSizeMultiplier = value;
                              });
                              setState(() {
                                _fontSizeMultiplier = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const Text('A', style: TextStyle(fontSize: 22, color: Color(0xFF3E2723))),
                    ],
                  );
                }
              ),
              const SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }
}
