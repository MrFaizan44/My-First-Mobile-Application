import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../models/class_note_model.dart';
import '../theme/app_theme.dart';
import '../database/database_helper.dart';

/// Modal Bottom Sheet form for creating or editing class notes & resources
class AddNoteBottomSheet extends StatefulWidget {
  final SubjectModel? preselectedCourse;
  final ClassNoteModel? initialNote;
  final VoidCallback onSaved;

  const AddNoteBottomSheet({
    super.key,
    this.preselectedCourse,
    this.initialNote,
    required this.onSaved,
  });

  static void show(
    BuildContext context, {
    SubjectModel? preselectedCourse,
    ClassNoteModel? initialNote,
    required VoidCallback onSaved,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddNoteBottomSheet(
        preselectedCourse: preselectedCourse,
        initialNote: initialNote,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<AddNoteBottomSheet> createState() => _AddNoteBottomSheetState();
}

class _AddNoteBottomSheetState extends State<AddNoteBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  List<SubjectModel> _courses = [];
  SubjectModel? _selectedCourse;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialNote?.title ?? '');
    _contentController =
        TextEditingController(text: widget.initialNote?.content ?? '');
    _loadUserCourses();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _loadUserCourses() async {
    final courses = await DatabaseHelper.instance.getSubjects();
    if (mounted) {
      setState(() {
        _courses = courses;
        if (courses.isNotEmpty) {
          if (widget.initialNote != null) {
            _selectedCourse = courses.firstWhere(
              (c) => c.id == widget.initialNote!.subjectId,
              orElse: () => courses[0],
            );
          } else if (widget.preselectedCourse != null) {
            _selectedCourse = courses.firstWhere(
              (c) => c.id == widget.preselectedCourse!.id,
              orElse: () => courses[0],
            );
          } else {
            _selectedCourse = courses[0];
          }
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _saveNote() async {
    if (_formKey.currentState!.validate() && _selectedCourse != null) {
      final note = ClassNoteModel(
        id: widget.initialNote?.id,
        subjectId: _selectedCourse!.id!,
        title: _titleController.text.trim(),
        content: _contentController.text.trim(),
        createdAt: widget.initialNote?.createdAt ?? DateTime.now(),
      );

      if (widget.initialNote == null) {
        await DatabaseHelper.instance.insertClassNote(note);
      } else {
        await DatabaseHelper.instance.updateClassNote(note);
      }

      widget.onSaved();
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? AppTheme.darkSurface : Colors.white;

    if (_isLoading) {
      return Container(
        height: 200,
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_courses.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.school_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text(
              'No Courses Found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Please add at least one course on the Home Dashboard before creating class notes or resources.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: bottomInset + 20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initialNote == null
                        ? 'Add Note / Resource'
                        : 'Edit Note',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<SubjectModel>(
                initialValue: _selectedCourse,
                decoration: InputDecoration(
                  labelText: 'Select Course *',
                  prefixIcon: const Icon(Icons.book_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  isDense: true,
                ),
                items: _courses.map((course) {
                  return DropdownMenuItem(
                    value: course,
                    child: Row(
                      children: [
                        CircleAvatar(backgroundColor: course.color, radius: 6),
                        const SizedBox(width: 8),
                        Text(course.name, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedCourse = val;
                    });
                  }
                },
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Note Title *',
                  hintText: 'e.g. Chapter 4 Lecture Notes or Drive Link',
                  prefixIcon: const Icon(Icons.title_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  isDense: true,
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter a title'
                    : null,
              ),
              const SizedBox(height: 14),

              TextFormField(
                controller: _contentController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: 'Note Details / Online Links *',
                  hintText:
                      'Type lecture summaries, key formulas, or paste Zoom / Google Drive resource links...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  isDense: true,
                ),
                validator: (val) => val == null || val.trim().isEmpty
                    ? 'Please enter note content or links'
                    : null,
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveNote,
                  icon: const Icon(Icons.check_rounded, color: Colors.white),
                  label: Text(
                    widget.initialNote == null ? 'Save Note' : 'Update Note',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _selectedCourse?.color ?? AppTheme.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
