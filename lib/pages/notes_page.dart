import 'package:flutter/material.dart';
import 'package:notes/models/note_database.dart';
import 'package:notes/models/note.dart';
import 'package:notes/pages/note_detail_page.dart';
import 'package:notes/pages/settings_page.dart';
import 'package:notes/widgets/note_card.dart';
import 'package:provider/provider.dart';

enum SortOption { dateNewest, dateOldest, titleAZ, titleZA }

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  String _searchQuery = '';
  SortOption _currentSort = SortOption.dateNewest;

  @override
  void initState() {
    super.initState();
    context.read<NoteDatabase>().fetchNotes();
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Note> _getFilteredAndSortedNotes(List<Note> notes) {
    // Filter by search query
    List<Note> filtered = notes;
    if (_searchQuery.isNotEmpty) {
      filtered = notes.where((note) {
        return note.title.toLowerCase().contains(_searchQuery) ||
            note.content.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Sort
    switch (_currentSort) {
      case SortOption.dateNewest:
        filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case SortOption.dateOldest:
        filtered.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
      case SortOption.titleAZ:
        filtered.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case SortOption.titleZA:
        filtered.sort(
          (a, b) => b.title.toLowerCase().compareTo(a.title.toLowerCase()),
        );
        break;
    }

    return filtered;
  }

  String _getSortLabel(SortOption option) {
    switch (option) {
      case SortOption.dateNewest:
        return 'Newest First';
      case SortOption.dateOldest:
        return 'Oldest First';
      case SortOption.titleAZ:
        return 'Title A-Z';
      case SortOption.titleZA:
        return 'Title Z-A';
    }
  }

  IconData _getSortIcon(SortOption option) {
    switch (option) {
      case SortOption.dateNewest:
        return Icons.arrow_downward;
      case SortOption.dateOldest:
        return Icons.arrow_upward;
      case SortOption.titleAZ:
        return Icons.sort_by_alpha;
      case SortOption.titleZA:
        return Icons.sort_by_alpha;
    }
  }

  void _showSortOptions() {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withAlpha(60),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Icon(Icons.sort, color: colorScheme.primary),
                      const SizedBox(width: 10),
                      Text(
                        'Sort Notes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                ...SortOption.values.map((option) {
                  final isSelected = _currentSort == option;
                  return ListTile(
                    leading: Icon(
                      _getSortIcon(option),
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurface.withAlpha(150),
                    ),
                    title: Text(
                      _getSortLabel(option),
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check, color: colorScheme.primary)
                        : null,
                    onTap: () {
                      setState(() => _currentSort = option);
                      Navigator.of(context).pop();
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchQuery = '';
      }
    });
  }

  void _confirmDeleteNote(Note note) {
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Note'),
        content: Text('Delete "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<NoteDatabase>().deleteNote(note.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('"${note.title}" deleted'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  action: SnackBarAction(label: 'OK', onPressed: () {}),
                ),
              );
            },
            child: Text('Delete', style: TextStyle(color: colorScheme.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    final allNotes = noteDatabase.currentNotes;
    final filteredNotes = _getFilteredAndSortedNotes(List.from(allNotes));
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: TextStyle(color: colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  hintStyle: TextStyle(
                    color: colorScheme.onSurface.withAlpha(120),
                  ),
                  border: InputBorder.none,
                ),
              )
            : const Text('Notes'),
        centerTitle: !_isSearching,
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
            tooltip: _isSearching ? 'Close' : 'Search',
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _showSortOptions,
            tooltip: 'Sort',
          ),
        ],
      ),
      drawer: _buildDrawer(context, allNotes, colorScheme),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const NoteDetailPage()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('New Note'),
      ),
      body: allNotes.isEmpty
          ? _buildEmptyState(colorScheme)
          : filteredNotes.isEmpty
          ? _buildNoResultsState(colorScheme)
          : _buildNotesList(filteredNotes),
    );
  }

  Widget _buildEmptyState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.note_add_outlined,
            size: 80,
            color: colorScheme.primary.withAlpha(100),
          ),
          const SizedBox(height: 16),
          Text(
            'No notes yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to create your first note',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(100),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: colorScheme.onSurface.withAlpha(80),
          ),
          const SizedBox(height: 16),
          Text(
            'No notes found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: colorScheme.onSurface.withAlpha(150),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try a different search term',
            style: TextStyle(
              fontSize: 14,
              color: colorScheme.onSurface.withAlpha(100),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(List<Note> notes) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return NoteCard(
          note: note,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NoteDetailPage(note: note),
              ),
            );
          },
          onLongPress: () => _confirmDeleteNote(note),
        );
      },
    );
  }

  Widget _buildDrawer(
    BuildContext context,
    List<Note> notes,
    ColorScheme colorScheme,
  ) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primaryContainer),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: colorScheme.surface.withAlpha(200),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        Icons.edit_note_rounded,
                        size: 32,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    Text(
                      '${notes.length} note${notes.length == 1 ? '' : 's'}',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer.withAlpha(180),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.notes, color: colorScheme.primary),
              title: const Text('All Notes'),
              selected: true,
              selectedTileColor: colorScheme.primaryContainer.withAlpha(80),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () => Navigator.of(context).pop(),
            ),
            const Divider(indent: 16, endIndent: 16),
            ListTile(
              leading: Icon(Icons.settings, color: colorScheme.primary),
              title: const Text('Settings'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Notes App v1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: colorScheme.onSurface.withAlpha(80),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
