import 'package:flutter/material.dart';
import '../models/schedule_block_model.dart';
import '../database/database_helper.dart';
import '../theme/app_theme.dart';
import '../widgets/timeline_schedule_card.dart';
import '../widgets/add_class_slot_bottom_sheet.dart';

/// My Schedule & Timetable Tab for StudyTasker
class ScheduleView extends StatefulWidget {
  const ScheduleView({super.key});

  @override
  State<ScheduleView> createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  int _selectedDay = DateTime.now().weekday; // 1 = Monday, 7 = Sunday
  List<ScheduleBlockModel> _dayBlocks = [];
  bool _isLoading = true;

  final List<Map<String, dynamic>> _weekDays = const [
    {'label': 'Mon', 'day': 1},
    {'label': 'Tue', 'day': 2},
    {'label': 'Wed', 'day': 3},
    {'label': 'Thu', 'day': 4},
    {'label': 'Fri', 'day': 5},
    {'label': 'Sat', 'day': 6},
    {'label': 'Sun', 'day': 7},
  ];

  @override
  void initState() {
    super.initState();
    _loadScheduleForDay();
  }

  Future<void> _loadScheduleForDay() async {
    setState(() => _isLoading = true);

    final blocks =
        await DatabaseHelper.instance.getScheduleBlocksForDay(_selectedDay);

    if (mounted) {
      setState(() {
        _dayBlocks = blocks;
        _isLoading = false;
      });
    }
  }

  void _openAddClassSlotModal({ScheduleBlockModel? block}) {
    AddClassSlotBottomSheet.show(
      context,
      defaultDayOfWeek: _selectedDay,
      initialBlock: block,
      onSaved: _loadScheduleForDay,
    );
  }

  Future<void> _confirmDeleteBlock(int id) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Class Slot?'),
        content: const Text(
            'Are you sure you want to delete this class slot from your schedule?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await DatabaseHelper.instance.deleteScheduleBlock(id);
              _loadScheduleForDay();
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Schedule & Timetable'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),

          // 1. Horizontal Day Picker Bar (Monday to Sunday)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: _weekDays.map((item) {
                final int dayVal = item['day'] as int;
                final String label = item['label'] as String;
                final bool isSelected = _selectedDay == dayVal;

                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected
                            ? Colors.white
                            : (isDark
                                ? AppTheme.darkTextPrimary
                                : AppTheme.lightTextPrimary),
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppTheme.primaryColor,
                    backgroundColor: isDark ? AppTheme.darkSurface : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedDay = dayVal;
                        });
                        _loadScheduleForDay();
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // 2. Vertical Hourly Timeline View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _dayBlocks.isEmpty
                    ? _buildEmptyScheduleState()
                    : RefreshIndicator(
                        onRefresh: _loadScheduleForDay,
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          itemCount: _dayBlocks.length,
                          itemBuilder: (context, index) {
                            final block = _dayBlocks[index];
                            return TimelineScheduleCard(
                              block: block,
                              onEdit: () =>
                                  _openAddClassSlotModal(block: block),
                              onDelete: () => _confirmDeleteBlock(block.id!),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),

      // 3. "+ Add Class Slot" Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAddClassSlotModal(),
        backgroundColor: AppTheme.brandIndigo,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text(
          'Add Class Slot',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyScheduleState() {
    final String dayName = _getDayName(_selectedDay);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_note_outlined,
                size: 56, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No Classes Scheduled Today',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkTextPrimary
                    : AppTheme.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No classes scheduled today. Time to relax or tap "+ Add Class Slot" below to build your $dayName timetable.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkTextSecondary
                    : AppTheme.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getDayName(int day) {
    switch (day) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return 'Monday';
    }
  }
}
