import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WalkthroughPage extends ConsumerStatefulWidget {
  const WalkthroughPage({super.key});

  @override
  ConsumerState<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends ConsumerState<WalkthroughPage> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  final List<Map<String, String>> _slides = [
    {
      'image': 'assets/images/walkthrough/listen.png',
      'title': 'Discover Magical Worlds',
      'subtitle': 'Immerse yourself in enchanting tales and captivating adventures crafted for curious minds.',
    },
    {
      'image': 'assets/images/walkthrough/ai.png',
      'title': 'AI-Powered Magic',
      'subtitle': 'Use our magical AI wizard to create your own fully customized stories with immersive voices.',
    },
    {
      'image': 'assets/images/walkthrough/select.png',
      'title': 'Choose Your 7 Free Stories',
      'subtitle': 'Create an account today to explore 5 unique genres and select your first 7 magical stories entirely for free!',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // Carousel
          CarouselSlider(
            carouselController: _carouselController,
            options: CarouselOptions(
              height: size.height,
              viewportFraction: 1.0,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            items: _slides.map((slide) {
              return Builder(
                builder: (BuildContext context) {
                  return Column(
                    children: [
                      // Image Section
                      Expanded(
                        flex: 6,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              slide['image']!,
                              fit: BoxFit.cover,
                            ),
                            // Gradient to blend image into background
                            Positioned(
                              bottom: -1,
                              left: 0,
                              right: 0,
                              height: 150,
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      theme.colorScheme.surface.withAlpha(0),
                                      theme.colorScheme.surface,
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Text Section
                      Expanded(
                        flex: 4,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                slide['title']!,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                slide['subtitle']!,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  height: 1.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 80), // Space for indicator & FAB
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            }).toList(),
          ),

          // Custom Dot Indicator
          Positioned(
            bottom: 120,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _slides.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _carouselController.animateToPage(entry.key),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: _currentIndex == entry.key ? 24.0 : 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4.0),
                      color: _currentIndex == entry.key
                          ? theme.colorScheme.primary
                          : theme.colorScheme.outlineVariant,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Skip Button
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: _currentIndex == _slides.length - 1 ? 0.0 : 1.0,
                  child: IgnorePointer(
                    ignoring: _currentIndex == _slides.length - 1,
                    child: TextButton(
                      onPressed: () {
                        context.go('/login');
                      },
                      child: Text(
                        'Skip',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              offset: const Offset(0, 1),
                              blurRadius: 2.0,
                              color: Colors.black.withValues(alpha: 0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Get Started Button
          Positioned(
            bottom: 40,
            left: 32,
            right: 32,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: _currentIndex == _slides.length - 1 ? 1.0 : 0.0,
              child: IgnorePointer(
                ignoring: _currentIndex != _slides.length - 1,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    context.go('/login');
                  },
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  elevation: 4,
                  label: const Text(
                    'Get Started',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  icon: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ),
        ],
      ),
     ),
    );
  }
}
