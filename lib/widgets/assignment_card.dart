import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/assignment_model.dart';
import '../theme/app_theme.dart';

/// Card widget displaying a course assignment with due date indicator and completion checkbox
class AssignmentCard extends StatelessWidget {
  final AssignmentModel assignment;
  final ValueChanged<bool?> onToggleComplete;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.onToggleComplete,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final Color courseColor = assignment.courseColorValue != null
        ? Color(assignment.courseColorValue!)
        : AppTheme.accentColor;

    final String formattedDueDate =
        DateFormat('EEE, MMM d • h:mm a').format(assignment.dueDate);

    final bool isOverdue = !assignment.isCompleted &&
        assignment.dueDate.isBefore(DateTime.now());

    return Card(
      elevation: 2,
      shadowColor: courseColor.withAlpha(30),
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Checkbox
            Checkbox(
              value: assignment.isCompleted,
              activeColor: courseColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              onChanged: onToggleComplete,
            ),
            const SizedBox(width: 8),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Row: Course Tag & Due Date Badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: courseColor.withAlpha(20),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: courseColor.withAlpha(60)),
                        ),
                        child: Text(
                          assignment.courseCode ?? 'Course',
                          style: TextStyle(
                            color: courseColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_horiz_rounded,
                            color: Colors.grey, size: 20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        onSelected: (val) {
                          if (val == 'edit') onEdit();
                          if (val == 'delete') onDelete();
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit_outlined, size: 18),
                                SizedBox(width: 8),
                                Text('Edit Assignment'),
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
                  const SizedBox(height: 6),

                  // Assignment Title
                  Text(
                    assignment.title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: assignment.isCompleted
                          ? AppTheme.textSecondary
                          : AppTheme.textPrimary,
                      decoration: assignment.isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  if (assignment.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      assignment.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[700],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),

                  // Due Date Indicator Badge
                  Row(
                    children: [
                      Icon(
                        Icons.event_rounded,
                        size: 14,
                        color: isOverdue ? Colors.redAccent : Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isOverdue ? 'Overdue: $formattedDueDate' : formattedDueDate,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              isOverdue ? FontWeight.bold : FontWeight.w500,
                          color: isOverdue ? Colors.redAccent : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
