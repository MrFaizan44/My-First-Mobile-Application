import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';

/// Modal dialog allowing the student to update their personalized profile name
class EditProfileDialog extends StatefulWidget {
  final String currentName;
  final VoidCallback onSaved;

  const EditProfileDialog({
    super.key,
    required this.currentName,
    required this.onSaved,
  });

  static void show(
    BuildContext context, {
    required String currentName,
    required VoidCallback onSaved,
  }) {
    showDialog(
      context: context,
      builder: (context) => EditProfileDialog(
        currentName: currentName,
        onSaved: onSaved,
      ),
    );
  }

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.currentName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _saveName() async {
    final newName = _nameController.text.trim();
    if (newName.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('student_name', newName);
      widget.onSaved();
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text('Edit Student Profile',
          style: TextStyle(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Student Name',
              hintText: 'e.g. Alex Rivers',
              prefixIcon: Icon(Icons.person_outline_rounded),
              border: OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveName,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Save Profile'),
        ),
      ],
    );
  }
}
