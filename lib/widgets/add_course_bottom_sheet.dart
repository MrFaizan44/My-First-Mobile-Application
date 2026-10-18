import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../theme/app_theme.dart';
import '../database/database_helper.dart';

/// Modal Bottom Sheet form for creating or editing user-defined courses
class AddCourseBottomSheet extends StatefulWidget {
  final SubjectModel? initialCourse;
  final VoidCallback onSaved;

  const AddCourseBottomSheet({
    super.key,
    this.initialCourse,
    required this.onSaved,
  });

  static void show(
    BuildContext context, {
    SubjectModel? initialCourse,
    required VoidCallback onSaved,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCourseBottomSheet(
        initialCourse: initialCourse,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<AddCourseBottomSheet> createState() => _AddCourseBottomSheetState();
}

class _AddCourseBottomSheetState extends State<AddCourseBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _instructorController;
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.initialCourse?.name ?? '');
    _instructorController =
        TextEditingController(text: widget.initialCourse?.instructor ?? '');
    _selectedColor = widget.initialCourse != null
        ? widget.initialCourse!.color
        : AppTheme.subjectColors[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _instructorController.dispose();
    super.dispose();
  }

  Future<void> _saveCourse() async {
    if (_formKey.currentState!.validate()) {
      final course = SubjectModel(
        id: widget.initialCourse?.id,
        name: _nameController.text.trim(),
        colorValue: _selectedColor.toARGB32(),
        instructor: _instructorController.text.trim(),
      );

      if (widget.initialCourse == null) {
        await DatabaseHelper.instance.insertSubject(course);
      } else {
        await DatabaseHelper.instance.updateSubject(course);
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
              // Drag Handle Bar Indicator
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

              // Header title bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.initialCourse == null ? 'Add New Course' : 'Edit Course',
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

              // Course Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Course Name *',
                  hintText: 'e.g. Mathematics, Computer Networks',
                  prefixIcon: const Icon(Icons.book_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  isDense: true,
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Please enter course name' : null,
              ),
              const SizedBox(height: 14),

              // Instructor Name
              TextFormField(
                controller: _instructorController,
                decoration: InputDecoration(
                  labelText: 'Instructor Name',
                  hintText: 'e.g. Dr. Sarah Jenkins',
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  isDense: true,
                ),
              ),
              const SizedBox(height: 18),

              // Palette Color Picker (Preset of 8 soft pastels)
              const Text(
                'Color Palette Theme:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              Wrap(
                spacing: 12,
                runSpacing: 10,
                children: AppTheme.subjectColors.map((color) {
                  final bool isSelected =
                      _selectedColor.toARGB32() == color.toARGB32();
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(color: color, width: 3)
                            : Border.all(color: Colors.transparent, width: 3),
                      ),
                      child: CircleAvatar(
                        backgroundColor: color,
                        radius: 18,
                        child: isSelected
                            ? const Icon(Icons.check,
                                color: Colors.white, size: 20)
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _saveCourse,
                  icon: const Icon(Icons.check_rounded, color: Colors.white),
                  label: Text(
                    widget.initialCourse == null ? 'Create Course' : 'Save Changes',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selectedColor,
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
