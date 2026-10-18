import 'package:flutter/material.dart';
import '../models/schedule_block_model.dart';
import '../theme/app_theme.dart';
import 'custom_card.dart';

/// Hourly timeline card displaying a user class slot with options to edit or delete
class TimelineScheduleCard extends StatelessWidget {
  final ScheduleBlockModel block;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final bool showMenu; // Set to false on Home Page to disable delete option!

  const TimelineScheduleCard({
    super.key,
    required this.block,
    required this.onEdit,
    required this.onDelete,
    this.showMenu = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color courseColor = block.subjectColorValue != null
        ? Color(block.subjectColorValue!)
        : AppTheme.brandIndigo;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Time Node Indicator with AM/PM formatting
          SizedBox(
            width: 78,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  block.formattedStartTime,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  block.formattedEndTime,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Timeline Node Line & Dot
          Column(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: courseColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: courseColor.withAlpha(80),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              Container(
                width: 2,
                height: 70,
                color: courseColor.withAlpha(50),
              ),
            ],
          ),
          const SizedBox(width: 12),

          // Right Content Card
          Expanded(
            child: CustomCard(
              padding: const EdgeInsets.all(14.0),
              borderColor: courseColor.withAlpha(80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: courseColor,
                            radius: 5,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            block.subjectName ?? 'Course',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      if (showMenu)
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
                                  Text('Edit Slot'),
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
                                  Text('Delete Slot',
                                      style:
                                          TextStyle(color: Colors.redAccent)),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  if (block.subjectInstructor != null &&
                      block.subjectInstructor!.isNotEmpty) ...[
                    Row(
                      children: [
                        const Icon(Icons.person_outline_rounded,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          block.subjectInstructor!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],

                  if (block.room.isNotEmpty)
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13, color: AppTheme.brandIndigo),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            block.room,
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppTheme.brandIndigo,
                              fontWeight: FontWeight.bold,
                            ),
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
