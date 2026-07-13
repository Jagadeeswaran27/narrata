import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExpandableSearchHeader extends StatefulWidget {
  final String title;
  final ValueChanged<String>? onSearch;

  const ExpandableSearchHeader({super.key, required this.title, this.onSearch});

  @override
  State<ExpandableSearchHeader> createState() => _ExpandableSearchHeaderState();
}

class _ExpandableSearchHeaderState extends State<ExpandableSearchHeader> {
  bool _isExpanded = false;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _focusNode.requestFocus();
      } else {
        _focusNode.unfocus();
        _textController.clear();
        if (widget.onSearch != null) {
          widget.onSearch!('');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        return TapRegion(
          onTapOutside: (event) {
            if (_isExpanded) {
              _toggleSearch();
            }
          },
          child: SizedBox(
            height: 42,
            child: Stack(
              children: [
                // Title (centered, visible when not fully expanded over it)
                Center(
                  child: AnimatedOpacity(
                    opacity: _isExpanded ? 0.0 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Text(
                      widget.title,
                      style: GoogleFonts.playfairDisplay(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2.0,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),

                // Expanding Search Bar positioned to the right
                Align(
                  alignment: Alignment.centerRight,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: _isExpanded ? constraints.maxWidth : 42,
                    height: 42,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(21), // pill shape
                    ),
                    child: ClipRect(
                      child: OverflowBox(
                        alignment: Alignment.centerRight,
                        minWidth: constraints.maxWidth,
                        maxWidth: constraints.maxWidth,
                        child: Row(
                          children: [
                            // Search Icon (left edge of the search bar)
                            Padding(
                              padding: const EdgeInsets.only(left: 12.0),
                              child: Icon(
                                Icons.search,
                                color: Colors.white.withValues(alpha: 0.7),
                                size: 20,
                              ),
                            ),

                            // TextField
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: TextField(
                                  controller: _textController,
                                  focusNode: _focusNode,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search stories...',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.zero,
                                    filled: true,
                                    fillColor: Colors
                                        .transparent, // Fixes the background color issue
                                  ),
                                  onChanged: widget.onSearch,
                                ),
                              ),
                            ),

                            // Action Button (Close when expanded, Search when collapsed)
                            GestureDetector(
                              onTap: _toggleSearch,
                              behavior: HitTestBehavior.opaque,
                              child: Container(
                                width: 42,
                                height: 42,
                                alignment: Alignment.center,
                                child: Icon(
                                  _isExpanded ? Icons.close : Icons.search,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ), // Close SizedBox
        ); // Close TapRegion
      },
    );
  }
}
