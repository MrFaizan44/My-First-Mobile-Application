import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import 'custom_card.dart';

/// Custom card widget displaying a user-added course with custom color theme
class SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const SubjectCard({
    super.key,
    required this.subject,
    this.onTap,
    this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final Color courseColor = subject.color;

    return CustomCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Color Accent Bar with Action Menu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: courseColor.withAlpha(30),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundColor: courseColor,
                  radius: 7,
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz_rounded,
                      color: Colors.grey, size: 18),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  onSelected: (val) {
                    if (val == 'edit' && onEdit != null) onEdit!();
                    if (val == 'delete' && onDelete != null) onDelete!();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18),
                          SizedBox(width: 8),
                          Text('Edit Course'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded,
                              color: Colors.redAccent, size: 18),
                          SizedBox(width: 8),
                          Text('Delete',
                              style: TextStyle(color: Colors.redAccent)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Card Content Body with Overflow Prevention
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      subject.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (subject.instructor.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded,
                            size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            subject.instructor,
                            style: const TextStyle(
                                fontSize: 11, color: Colors.grey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
