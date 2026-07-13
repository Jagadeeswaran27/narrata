import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const BottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      padding: EdgeInsets.only(
        top: 14,
        bottom: bottomInset > 0 ? bottomInset * 0.6 : 14,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: Icons.home_filled,
            label: 'Home',
            isSelected: selectedIndex == 0,
            onTap: () => onDestinationSelected(0),
          ),
          _buildNavItem(
            context,
            icon: Icons.library_books,
            label: 'Library',
            isSelected: selectedIndex == 1,
            onTap: () => onDestinationSelected(1),
          ),
          _buildNavItem(
            context,
            icon: Icons.favorite,
            label: 'Favorites',
            isSelected: selectedIndex == 2,
            onTap: () => onDestinationSelected(2),
          ),
          _buildNavItem(
            context,
            icon: Icons.person,
            label: 'Profiles',
            isSelected: selectedIndex == 3,
            onTap: () => onDestinationSelected(3),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isSelected
        ? colorScheme.onPrimary
        : colorScheme.onPrimary.withValues(alpha: 0.6);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
