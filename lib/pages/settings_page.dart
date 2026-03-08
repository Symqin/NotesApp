import 'package:flutter/material.dart';
import 'package:notes/models/theme_provider.dart';
import 'package:notes/pages/about_page.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const SizedBox(height: 8),

          // Appearance section
          _buildSectionHeader(context, 'Appearance'),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: Text(
              themeProvider.isDarkMode
                  ? 'Dark theme active'
                  : 'Light theme active',
            ),
            secondary: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return RotationTransition(
                  turns: animation,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                key: ValueKey(themeProvider.isDarkMode),
                color: colorScheme.primary,
              ),
            ),
            value: themeProvider.isDarkMode,
            onChanged: (_) => themeProvider.toggleTheme(),
          ),

          const Divider(),

          // General section
          _buildSectionHeader(context, 'General'),
          ListTile(
            leading: Icon(Icons.info_outline, color: colorScheme.primary),
            title: const Text('About'),
            subtitle: const Text('App info, features & tech stack'),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withAlpha(100),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AboutPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: colorScheme.primary),
            title: const Text('Help & Tips'),
            subtitle: const Text('How to use the app'),
            trailing: Icon(
              Icons.chevron_right,
              color: colorScheme.onSurface.withAlpha(100),
            ),
            onTap: () => _showHelpDialog(context),
          ),

          const Divider(),

          // Data section
          _buildSectionHeader(context, 'Data'),
          ListTile(
            leading: Icon(
              Icons.delete_sweep_outlined,
              color: colorScheme.error,
            ),
            title: const Text('Delete All Notes'),
            subtitle: const Text('Remove all notes permanently'),
            onTap: () => _showDeleteAllDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: colorScheme.primary,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: colorScheme.primary),
            const SizedBox(width: 10),
            const Text('Help & Tips'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HelpItem(
              icon: Icons.add,
              text: 'Tap the + button to create a new note',
            ),
            _HelpItem(
              icon: Icons.touch_app,
              text: 'Tap a note to open and edit it',
            ),
            _HelpItem(
              icon: Icons.gesture,
              text: 'Long press a note to delete it quickly',
            ),
            _HelpItem(
              icon: Icons.search,
              text: 'Use the search icon to find notes',
            ),
            _HelpItem(
              icon: Icons.sort,
              text: 'Use the sort icon to reorder notes',
            ),
            _HelpItem(
              icon: Icons.arrow_back,
              text: 'Notes auto-save when you go back',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete All Notes'),
        content: const Text(
          'Are you sure you want to delete ALL notes? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Delete all notes by fetching and deleting each one
              final db = context.read<ThemeProvider>();
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Feature coming soon'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              'Delete All',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

class _HelpItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _HelpItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withAlpha(180),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
