import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../models/class_note_model.dart';
import '../database/database_helper.dart';
import '../theme/app_theme.dart';
import '../widgets/note_card.dart';
import '../widgets/add_note_bottom_sheet.dart';

/// Class Notes & Resources Tab for StudyTasker
class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  List<ClassNoteModel> _notes = [];
  List<SubjectModel> _courses = [];
  SubjectModel? _selectedCourseFilter;
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotesAndCourses();
  }

  Future<void> _loadNotesAndCourses() async {
    setState(() => _isLoading = true);

    final courses = await DatabaseHelper.instance.getSubjects();
    final notes = await DatabaseHelper.instance.getClassNotes(
      subjectId: _selectedCourseFilter?.id,
    );

    if (mounted) {
      setState(() {
        _courses = courses;
        _notes = notes;
        _isLoading = false;
      });
    }
  }

  void _openAddNoteModal({ClassNoteModel? note}) {
    AddNoteBottomSheet.show(
      context,
      preselectedCourse: _selectedCourseFilter,
      initialNote: note,
      onSaved: _loadNotesAndCourses,
    );
  }

  Future<void> _confirmDeleteNote(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Class Note?'),
        content: const Text(
            'Are you sure you want to delete this note? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await DatabaseHelper.instance.deleteClassNote(id);
              _loadNotesAndCourses();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final filteredNotes = _notes.where((note) {
      final matchesSearch = note.title
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          note.content.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Notes & Resources'),
      ),
      body: Column(
        children: [
          Container(
            color: isDark ? AppTheme.darkSurface : Colors.white,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Live Search Bar
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Search notes, summaries, or links...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: isDark ? AppTheme.darkBorder : Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                          color: isDark ? AppTheme.darkBorder : Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: AppTheme.brandIndigo),
                    ),
                    filled: true,
                    fillColor: isDark
                        ? AppTheme.darkBackground
                        : AppTheme.lightBackground,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                ),

                if (_courses.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('All Courses'),
                          selected: _selectedCourseFilter == null,
                          selectedColor: AppTheme.primaryColor,
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: _selectedCourseFilter == null
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: _selectedCourseFilter == null
                                ? Colors.white
                                : (isDark
                                    ? AppTheme.darkTextPrimary
                                    : AppTheme.lightTextPrimary),
                          ),
                          onSelected: (val) {
                            setState(() {
                              _selectedCourseFilter = null;
                            });
                            _loadNotesAndCourses();
                          },
                        ),
                        const SizedBox(width: 8),
                        ..._courses.map((course) {
                          final bool isSelected =
                              _selectedCourseFilter?.id == course.id;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: FilterChip(
                              label: Text(course.name),
                              selected: isSelected,
                              selectedColor: course.color,
                              checkmarkColor: Colors.white,
                              labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark
                                        ? AppTheme.darkTextPrimary
                                        : AppTheme.lightTextPrimary),
                              ),
                              onSelected: (val) {
                                setState(() {
                                  _selectedCourseFilter = val ? course : null;
                                });
                                _loadNotesAndCourses();
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Notes List View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredNotes.isEmpty
                    ? _buildEmptyNotesState()
                    : RefreshIndicator(
                        onRefresh: _loadNotesAndCourses,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = filteredNotes[index];
                            return NoteCard(
                              note: note,
                              onEdit: () => _openAddNoteModal(note: note),
                              onDelete: () => _confirmDeleteNote(note.id!),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddNoteModal(),
        backgroundColor: AppTheme.brandIndigo,
        icon: const Icon(Icons.note_add_rounded, color: Colors.white),
        label: const Text(
          'Add Note',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyNotesState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.description_outlined,
                size: 56, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No Notes Found for "$_searchQuery"'
                  : _selectedCourseFilter != null
                      ? 'No Notes for ${_selectedCourseFilter!.name}'
                      : 'No Class Notes Yet',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _searchQuery.isNotEmpty
                  ? 'Try searching for another keyword or clear the search field.'
                  : 'Tap "+ Add Note" below to save quick notes, lecture summaries, or Google Drive / Zoom links.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
