import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_controls.dart';
import '../widgets/statistic_card.dart';

/// Main Home screen containing greetings, study/break timer, controls,
/// quick stat cards, and hydration logger.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        // Check if session completed to trigger congratulatory dialog
        if (appState.justCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showCompletionDialog(context, appState);
          });
        }

        final greeting = _getGreetingText();

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting & Profile Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[600],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${appState.userName} 👋',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                        ],
                      ),
                      // Hydration quick button badge
                      InkWell(
                        onTap: () {
                          appState.addWaterGlass();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Great job! 💧 1 glass of water logged.'),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F7FA),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: const Color(0xFF80DEEA)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.water_drop_rounded,
                                  color: Color(0xFF00ACC1), size: 18),
                              const SizedBox(width: 6),
                              Text(
                                '${appState.waterGlassesToday} Glasses',
                                style: const TextStyle(
                                  color: Color(0xFF00838F),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Timer Display Widget
                  const TimerDisplay(),

                  const SizedBox(height: 16),

                  // Timer Controls Widget
                  const TimerControls(),

                  const SizedBox(height: 28),

                  // Today's Quick Statistics Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Progress',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                      Text(
                        _getTodayFormattedDate(),
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Stat Cards Grid
                  Row(
                    children: [
                      Expanded(
                        child: StatisticCard(
                          title: 'Study Time',
                          value: '${appState.todayStudyMinutes}m',
                          subtitle: 'Today\'s total',
                          icon: Icons.timer_outlined,
                          color: const Color(0xFF0288D1),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatisticCard(
                          title: 'Sessions',
                          value: '${appState.todayCompletedSessionsCount}',
                          subtitle: 'Completed',
                          icon: Icons.task_alt_rounded,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: StatisticCard(
                          title: 'Water',
                          value: '${appState.waterGlassesToday}',
                          subtitle: 'Tap to +1 💧',
                          icon: Icons.local_drink_rounded,
                          color: const Color(0xFF00ACC1),
                          onTap: () {
                            appState.addWaterGlass();
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Hydration & Study Tip Banner
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFA5D6A7)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFC8E6C9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.emoji_objects_outlined,
                            color: Color(0xFF2E7D32),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Study Smart Tip 💡',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1B5E20),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Taking 5-minute breaks every 25 minutes restores brain power and prevents fatigue. Don\'t forget to drink water!',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[800],
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Time of day greeting generator
  String _getGreetingText() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  /// Today's formatted date string (e.g. "Mon, Oct 12")
  String _getTodayFormattedDate() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  /// Dialog shown when a study or break session finishes
  void _showCompletionDialog(BuildContext context, AppStateProvider appState) {
    final bool wasStudy = appState.currentMode == SessionMode.study;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                wasStudy ? Icons.stars_rounded : Icons.coffee_rounded,
                color: wasStudy ? const Color(0xFF0288D1) : const Color(0xFF4CAF50),
                size: 28,
              ),
              const SizedBox(width: 10),
              Text(
                wasStudy ? 'Great Focus Session!' : 'Break Time Complete!',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                wasStudy
                    ? 'Awesome job staying focused! You completed ${appState.studyDurationMins} minutes of study time.'
                    : 'Your break is done! Hope you feel recharged and ready for the next session.',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.water_drop_rounded, color: Color(0xFF00ACC1)),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Reminder: Drink a glass of water now to stay hydrated! 💧',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF006064),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                appState.addWaterGlass();
                appState.dismissCompletionDialog();
                Navigator.of(context).pop();
              },
              child: const Text('Log Water 💧'),
            ),
            ElevatedButton(
              onPressed: () {
                appState.dismissCompletionDialog();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    wasStudy ? const Color(0xFF4CAF50) : const Color(0xFF0288D1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(wasStudy ? 'Take Break' : 'Start Focus'),
            ),
          ],
        );
      },
    );
  }
}
