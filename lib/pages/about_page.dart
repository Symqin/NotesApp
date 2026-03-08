import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // App icon
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withAlpha(40),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(
                Icons.edit_note_rounded,
                size: 64,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 24),
            // App name
            Text(
              'Notes App',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurface.withAlpha(120),
              ),
            ),
            const SizedBox(height: 32),
            // Description card
            _buildInfoCard(
              context,
              icon: Icons.description_outlined,
              title: 'Description',
              content:
                  'A simple and beautiful notes application built with Flutter. '
                  'Capture your thoughts, ideas, and important information with ease. '
                  'Features include create, read, update, and delete notes with local storage persistence.',
            ),
            const SizedBox(height: 16),
            // Tech stack card
            _buildInfoCard(
              context,
              icon: Icons.code,
              title: 'Tech Stack',
              content: null,
              child: Column(
                children: [
                  _buildTechItem(context, 'Flutter', 'UI Framework'),
                  _buildTechItem(context, 'Isar', 'Local Database'),
                  _buildTechItem(context, 'Provider', 'State Management'),
                  _buildTechItem(
                    context,
                    'SharedPreferences',
                    'Theme Persistence',
                  ),
                  _buildTechItem(context, 'Material 3', 'Design System'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Features card
            _buildInfoCard(
              context,
              icon: Icons.star_outline,
              title: 'Features',
              content: null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeatureItem(
                    context,
                    'Create & edit notes with title and content',
                  ),
                  _buildFeatureItem(
                    context,
                    'Search notes by title or content',
                  ),
                  _buildFeatureItem(context, 'Sort notes by date or title'),
                  _buildFeatureItem(context, 'Dark and light theme support'),
                  _buildFeatureItem(context, 'Auto-save on back navigation'),
                  _buildFeatureItem(context, 'Persistent local storage'),
                  _buildFeatureItem(context, 'Material Design 3 UI'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Developer card
            _buildInfoCard(
              context,
              icon: Icons.person_outline,
              title: 'Developer',
              content:
                  'Built as a Flutter learning project. This app demonstrates '
                  'CRUD operations, state management with Provider, local database '
                  'with Isar, and modern Material 3 design principles.',
            ),
            const SizedBox(height: 32),
            // Footer
            Text(
              'Made with ❤️ in Flutter',
              style: TextStyle(
                color: colorScheme.onSurface.withAlpha(100),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? content,
    Widget? child,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colorScheme.outlineVariant.withAlpha(80)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 22),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (content != null)
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: colorScheme.onSurface.withAlpha(180),
                ),
              ),
            if (child != null) child,
          ],
        ),
      ),
    );
  }

  Widget _buildTechItem(BuildContext context, String name, String desc) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(width: 8),
          Text(
            '— $desc',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String feature) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 18,
            color: colorScheme.primary,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              feature,
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
