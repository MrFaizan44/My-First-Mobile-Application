import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';

/// Tasks & Assignments Tab for CampusOS
class TasksView extends StatefulWidget {
  const TasksView({super.key});

  @override
  State<TasksView> createState() => _TasksViewState();
}

class _TasksViewState extends State<TasksView> {
  String _selectedFilter = 'All';

  final List<TaskModel> _sampleTasks = [
    TaskModel(
      id: '1',
      title: 'Algorithm Analysis Problem Set 3',
      courseCode: 'CS301',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      priority: 'High',
    ),
    TaskModel(
      id: '2',
      title: 'Database Normalization Project Draft',
      courseCode: 'CS304',
      dueDate: DateTime.now().add(const Duration(days: 3)),
      priority: 'Medium',
    ),
    TaskModel(
      id: '3',
      title: 'Read Chapter 5: Software Architecture',
      courseCode: 'SE202',
      dueDate: DateTime.now().add(const Duration(days: 5)),
      isCompleted: true,
      priority: 'Low',
    ),
    TaskModel(
      id: '4',
      title: 'Linear Algebra Quiz Preparation',
      courseCode: 'MATH201',
      dueDate: DateTime.now().add(const Duration(days: 2)),
      priority: 'High',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Tasks & Assignments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.sort_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Chips Bar
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['All', 'Pending', 'Completed', 'High Priority']
                    .map((filter) {
                  final bool isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(
                        filter,
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : AppTheme.textPrimary,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppTheme.primaryColor,
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Task List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _sampleTasks.length,
              itemBuilder: (context, index) {
                final task = _sampleTasks[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: CustomCard(
                    child: Row(
                      children: [
                        Checkbox(
                          value: task.isCompleted,
                          activeColor: AppTheme.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          onChanged: (val) {
                            setState(() {
                              _sampleTasks[index] = TaskModel(
                                id: task.id,
                                title: task.title,
                                courseCode: task.courseCode,
                                dueDate: task.dueDate,
                                isCompleted: val ?? false,
                                priority: task.priority,
                              );
                            });
                          },
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppTheme.pastelBlue,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      task.courseCode,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.pastelBlueBorder,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  _buildPriorityChip(task.priority),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: task.isCompleted
                                      ? AppTheme.textSecondary
                                      : AppTheme.textPrimary,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.event_outlined,
                                      size: 13, color: AppTheme.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Due in ${task.dueDate.difference(DateTime.now()).inDays + 1} days',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.textSecondary,
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
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        backgroundColor: AppTheme.primaryColor,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('New Task', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Widget _buildPriorityChip(String priority) {
    Color bg = AppTheme.pastelGreen;
    Color border = AppTheme.pastelGreenBorder;

    if (priority == 'High') {
      bg = AppTheme.pastelRose;
      border = AppTheme.pastelRoseBorder;
    } else if (priority == 'Medium') {
      bg = AppTheme.pastelAmber;
      border = AppTheme.pastelAmberBorder;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$priority Priority',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: border,
        ),
      ),
    );
  }
}
