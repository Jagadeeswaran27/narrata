import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:narrata/features/auth/domain/models/user_model.dart';
import 'package:narrata/features/auth/presentation/view_models/current_user_provider.dart';
import 'package:narrata/features/auth/data/repositories/firebase_auth_repository.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(currentUserProvider);
    final user = userState.value;
    final colorScheme = Theme.of(context).colorScheme;

    // Get initials for Avatar
    String name = user?.fullName ?? 'Story Explorer';
    String email = user?.email ?? '';
    String initials = name.isNotEmpty
        ? name.substring(0, 1).toUpperCase()
        : '?';
    if (name.contains(' ')) {
      final parts = name.split(' ');
      if (parts.length > 1 && parts[1].isNotEmpty) {
        initials = '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'
            .toUpperCase();
      }
    }

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 24,
            right: 24,
            top: 12,
            bottom: 120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Center(
                child: Text(
                  'PROFILE',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.0,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // 1. Header
              _buildHeader(context, colorScheme, name, email, initials),
              const SizedBox(height: 40),

              // 2. Gamification Stats Grid
              Text(
                'Your Journey',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildStatsGrid(context, colorScheme),
              const SizedBox(height: 32), // Add proper spacing back
              // 3. Settings List
              _buildSettings(context, ref, colorScheme),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colorScheme,
    String name,
    String email,
    String initials,
  ) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [colorScheme.primary, colorScheme.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            initials,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          name,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (email.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            email,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
        const SizedBox(height: 16),
        // Badge UI
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.workspace_premium,
                size: 16,
                color: colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 8),
              Text(
                'Story Explorer',
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(BuildContext context, ColorScheme colorScheme) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                colorScheme,
                icon: Icons.timer,
                title: 'Total Time',
                value: '12h 30m',
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                colorScheme,
                icon: Icons.auto_stories,
                title: 'Stories Read',
                value: '45',
                color: Colors.orangeAccent,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                context,
                colorScheme,
                icon: Icons.local_fire_department,
                title: 'Current Streak',
                value: '3 Days',
                color: Colors.redAccent,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                context,
                colorScheme,
                icon: Icons.category,
                title: 'Top Genre',
                value: 'Sci-Fi',
                color: Colors.purpleAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettings(
    BuildContext context,
    WidgetRef ref,
    ColorScheme colorScheme,
  ) {
    final userState = ref.watch(currentUserProvider);
    final user = userState.value;

    final isPhoneAuth = user?.authMethod == AuthMethod.phone;
    final emailText = user?.email?.isNotEmpty == true
        ? user!.email!
        : 'Add Email';
    final phoneText = user?.phone?.isNotEmpty == true
        ? user!.phone!
        : 'Add Phone';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, 'Account Details'),
        _buildSettingsCard([
          _buildSettingsTile(
            Icons.person_outline,
            user?.fullName.isNotEmpty == true ? 'Edit Name' : 'Add Name',
            onTap: () =>
                _showEditDialog(context, ref, 'Name', user?.fullName ?? ''),
          ),
          _buildSettingsTile(
            Icons.email_outlined,
            isPhoneAuth
                ? (user?.email?.isNotEmpty == true ? 'Edit Email' : 'Add Email')
                : 'Email',
            trailingText: isPhoneAuth ? null : emailText,
            showChevron: isPhoneAuth,
            onTap: isPhoneAuth
                ? () =>
                      _showEditDialog(context, ref, 'Email', user?.email ?? '')
                : null,
          ),
          _buildSettingsTile(
            Icons.phone_outlined,
            !isPhoneAuth
                ? (user?.phone?.isNotEmpty == true ? 'Edit Phone' : 'Add Phone')
                : 'Phone',
            trailingText: !isPhoneAuth ? null : phoneText,
            showChevron: !isPhoneAuth,
            onTap: !isPhoneAuth
                ? () =>
                      _showEditDialog(context, ref, 'Phone', user?.phone ?? '')
                : null,
          ),
        ], colorScheme),

        const SizedBox(height: 24),
        _buildSectionTitle(context, 'App Preferences'),
        _buildSettingsCard([
          _buildSettingsTile(
            Icons.headphones_outlined,
            'Audio Quality',
            trailingText: 'High',
          ),
          _buildSettingsTile(
            Icons.notifications_outlined,
            'Push Notifications',
            trailingText: 'On',
          ),
        ], colorScheme),

        const SizedBox(height: 24),
        _buildSectionTitle(context, 'Support & Info'),
        _buildSettingsCard([
          _buildSettingsTile(Icons.help_outline, 'Help Center'),
          _buildSettingsTile(Icons.privacy_tip_outlined, 'Privacy Policy'),
          _buildSettingsTile(Icons.description_outlined, 'Terms of Service'),
        ], colorScheme),

        const SizedBox(height: 32),
        // Sign Out Button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              ref.read(authRepositoryProvider).signOut();
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(
                color: colorScheme.error.withValues(alpha: 0.5),
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, color: colorScheme.error),
                const SizedBox(width: 8),
                Text(
                  'Sign Out',
                  style: TextStyle(
                    color: colorScheme.error,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children, ColorScheme colorScheme) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSettingsTile(
    IconData icon,
    String title, {
    String? trailingText,
    bool isDestructive = false,
    bool showChevron = true,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: isDestructive ? Colors.redAccent : null),
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: isDestructive ? Colors.redAccent : null,
                  fontWeight: isDestructive
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 16),
              if (trailingText != null)
                Expanded(
                  child: Text(
                    trailingText,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                )
              else
                const Spacer(),
              if (showChevron) ...[
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(
    BuildContext context,
    WidgetRef ref,
    String field,
    String currentValue,
  ) {
    final controller = TextEditingController(text: currentValue);
    final isEmail = field == 'Email';
    final isPhone = field == 'Phone';
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isLoading = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit $field'),
              content: SizedBox(
                width: double.maxFinite,
                child: TextField(
                  controller: controller,
                  keyboardType: isEmail
                      ? TextInputType.emailAddress
                      : (isPhone ? TextInputType.phone : TextInputType.name),
                  decoration: InputDecoration(hintText: 'Enter your $field'),
                  enabled: !isLoading,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final newValue = controller.text.trim();
                          if (newValue.isNotEmpty && newValue != currentValue) {
                            setState(() => isLoading = true);
                            try {
                              final repo = ref.read(authRepositoryProvider);
                              if (field == 'Name') {
                                await repo.updateName(newValue);
                              } else if (field == 'Email') {
                                await repo.updateEmail(newValue);
                              } else if (field == 'Phone') {
                                await repo.updatePhone(newValue);
                              }
                              if (context.mounted) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '$field updated successfully!',
                                    ),
                                    backgroundColor: Colors.green.shade600,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                setState(() => isLoading = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      e.toString().replaceAll(
                                        'Exception: ',
                                        '',
                                      ),
                                    ),
                                    backgroundColor: colorScheme.error,
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            }
                          } else {
                            Navigator.pop(context);
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
