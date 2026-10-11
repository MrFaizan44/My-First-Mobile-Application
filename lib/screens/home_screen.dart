import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_controls.dart';
import '../widgets/statistic_card.dart';

/// Enhanced Home screen with greeting header, study streak, daily goal progress,
/// quote generator, ambient sound bar, timer, controls, and quick stats.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        if (appState.justCompleted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showCompletionDialog(context, appState);
          });
        }

        final greeting = _getGreetingText();
        final primaryColor = appState.primaryThemeColor;

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Header: Greeting, Streak & Hydration Quick Log
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            greeting,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[600],
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${appState.userName} 👋',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey[900],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          // Streak Counter Badge
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.orange[200]!),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.local_fire_department_rounded,
                                    color: Colors.orange, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  '${appState.studyStreakDays}d Streak',
                                  style: const TextStyle(
                                    color: Colors.deepOrange,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Water Intake Badge
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
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F7FA),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFF80DEEA)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.water_drop_rounded,
                                      color: Color(0xFF00ACC1), size: 18),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${appState.waterGlassesToday}💧',
                                    style: const TextStyle(
                                      color: Color(0xFF00838F),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Daily Goal Progress Banner
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withAlpha(20),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.track_changes_rounded,
                                    color: primaryColor, size: 20),
                                const SizedBox(width: 6),
                                Text(
                                  'Daily Goal Progress',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey[800],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${appState.todayCompletedSessionsCount} / ${appState.dailyGoalSessions} Sessions',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: appState.dailyGoalProgress,
                            minHeight: 8,
                            backgroundColor: primaryColor.withAlpha(30),
                            valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Motivational Quote Card
                  InkWell(
                    onTap: () => appState.nextQuote(),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: primaryColor.withAlpha(15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.format_quote_rounded,
                              color: primaryColor, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              appState.currentQuote,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.italic,
                                color: Colors.blueGrey[800],
                              ),
                            ),
                          ),
                          Icon(Icons.refresh_rounded,
                              size: 16, color: primaryColor),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Circular Timer Display
                  const TimerDisplay(),

                  const SizedBox(height: 12),

                  // Timer Controls & Subject Selector
                  const TimerControls(),

                  const SizedBox(height: 20),

                  // Ambient Focus Sounds Selector
                  Row(
                    children: [
                      Icon(Icons.headphones_rounded,
                          size: 18, color: Colors.blueGrey[700]),
                      const SizedBox(width: 6),
                      Text(
                        'Ambient Focus Sounds',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[800],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: appState.availableAmbientSounds.map((sound) {
                        final bool isSelected =
                            appState.activeAmbientSound == sound;
                        return Padding(
                          padding: const EdgeInsets.only(right: 6.0),
                          child: ActionChip(
                            avatar: isSelected
                                ? const Icon(Icons.volume_up_rounded, size: 14)
                                : null,
                            label: Text(
                              sound,
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[800],
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            backgroundColor: isSelected
                                ? const Color(0xFF4CAF50)
                                : Colors.white,
                            onPressed: () => appState.setAmbientSound(sound),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Today's Progress Cards Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Today\'s Summary',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                      Text(
                        _getTodayFormattedDate(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Quick Stat Cards Row
                  Row(
                    children: [
                      Expanded(
                        child: StatisticCard(
                          title: 'Study Time',
                          value: '${appState.todayStudyMinutes}m',
                          subtitle: 'Today\'s total',
                          icon: Icons.timer_outlined,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatisticCard(
                          title: 'Sessions',
                          value: '${appState.todayCompletedSessionsCount}',
                          subtitle: 'Completed',
                          icon: Icons.task_alt_rounded,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StatisticCard(
                          title: 'Water Log',
                          value: '${appState.waterGlassesToday}',
                          subtitle: 'Tap +1 💧',
                          icon: Icons.local_drink_rounded,
                          color: const Color(0xFF00ACC1),
                          onTap: () {
                            appState.addWaterGlass();
                          },
                        ),
                      ),
                    ],
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

  String _getTodayFormattedDate() {
    final now = DateTime.now();
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

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
                color: wasStudy ? appState.primaryThemeColor : const Color(0xFF4CAF50),
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
                    ? 'Awesome job! You completed ${appState.studyDurationMins} minutes of study in ${appState.selectedSubject}.'
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
                    wasStudy ? const Color(0xFF4CAF50) : appState.primaryThemeColor,
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
