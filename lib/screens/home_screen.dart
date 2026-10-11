```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state_provider.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_controls.dart';
import '../widgets/statistic_card.dart';

<<<<<<< HEAD
=======
/// Enhanced Home screen with greeting header, study streak, daily goal progress,
/// quote generator, ambient sound bar, timer, controls, and quick stats.
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c
class HomeScreen extends StatelessWidget {
const HomeScreen({super.key});

<<<<<<< HEAD
static const Color primary = Color(0xFF00AFA6);
static const Color blue = Color(0xFF4776E6);
static const Color background = Color(0xFFF5F8FC);

@override
Widget build(BuildContext context) {
return Consumer<AppStateProvider>(
builder: (context, appState, child) {
if (appState.justCompleted) {
WidgetsBinding.instance.addPostFrameCallback((_) {
if (context.mounted && appState.justCompleted) {
_showCompletionDialog(context, appState);
=======
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
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c
}
});
}

return Scaffold(
backgroundColor: background,
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.symmetric(
horizontal: 18,
vertical: 18,
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
_buildHeader(context, appState),

const SizedBox(height: 24),

_buildWelcomeBanner(appState.userName),

const SizedBox(height: 24),

const TimerDisplay(),

const SizedBox(height: 18),

const TimerControls(),

const SizedBox(height: 30),

Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
"Today's Progress",
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: Color(0xFF172B4D),
),
),
Text(
_getTodayFormattedDate(),
style: const TextStyle(
color: Colors.blueGrey,
fontSize: 12,
),
),
],
),

const SizedBox(height: 14),

Row(
children: [
Expanded(
child: StatisticCard(
title: 'Study Time',
value: _formatMinutes(
appState.todayStudyMinutes,
),
subtitle: 'Focused today',
icon: Icons.timer_rounded,
color: primary,
),
),
const SizedBox(width: 10),
Expanded(
child: StatisticCard(
title: 'Sessions',
value:
'${appState.todayCompletedSessionsCount}',
subtitle: 'Completed',
icon: Icons.task_alt_rounded,
color: blue,
),
),
const SizedBox(width: 10),
Expanded(
child: StatisticCard(
title: 'Water',
value: '${appState.waterGlassesToday}',
subtitle: 'Glasses',
icon: Icons.water_drop_rounded,
color: const Color(0xFF00ACC1),
onTap: () => _addWater(context, appState),
),
),
],
),

const SizedBox(height: 22),

_buildStudyTip(),

const SizedBox(height: 18),
],
),
),
),
);
},
);
}

Widget _buildHeader(
BuildContext context,
AppStateProvider appState,
) {
return Row(
children: [
Container(
width: 48,
height: 48,
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [primary, blue],
),
borderRadius: BorderRadius.circular(16),
),
child: const Icon(
Icons.self_improvement_rounded,
color: Colors.white,
size: 27,
),
),
const SizedBox(width: 12),
const Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'BREAK BUDDY',
style: TextStyle(
fontSize: 11,
fontWeight: FontWeight.bold,
letterSpacing: 1.5,
color: primary,
),
),
SizedBox(height: 3),
Text(
'Your focus space',
style: TextStyle(
fontSize: 17,
fontWeight: FontWeight.bold,
color: Color(0xFF172B4D),
),
),
],
),
),
Material(
color: const Color(0xFFE0F7FA),
borderRadius: BorderRadius.circular(16),
child: InkWell(
borderRadius: BorderRadius.circular(16),
onTap: () => _addWater(context, appState),
child: Padding(
padding: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 10,
),
child: Row(
children: [
const Icon(
Icons.water_drop_rounded,
color: Color(0xFF00838F),
size: 20,
),
const SizedBox(width: 6),
Text(
'${appState.waterGlassesToday}',
style: const TextStyle(
color: Color(0xFF00838F),
fontWeight: FontWeight.bold,
fontSize: 15,
),
),
],
),
),
),
),
],
);
}

Widget _buildWelcomeBanner(String userName) {
final hour = DateTime.now().hour;

final greeting = hour < 12
? 'Good Morning'
    : hour < 17
? 'Good Afternoon'
    : 'Good Evening';

return Container(
width: double.infinity,
padding: const EdgeInsets.all(22),
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [primary, blue],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
borderRadius: BorderRadius.circular(24),
boxShadow: [
BoxShadow(
color: primary.withValues(alpha: 0.18),
blurRadius: 18,
offset: const Offset(0, 7),
),
],
),
child: Row(
children: [
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'$greeting 👋',
style: const TextStyle(
color: Colors.white70,
fontSize: 14,
),
),
const SizedBox(height: 8),
Text(
userName,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
color: Colors.white,
fontSize: 24,
fontWeight: FontWeight.bold,
),
),
const SizedBox(height: 8),
const Text(
'Ready to make today productive?',
style: TextStyle(
color: Colors.white,
fontSize: 12,
),
),
],
),
),
const SizedBox(width: 8),
const Icon(
Icons.auto_awesome_rounded,
color: Colors.white70,
size: 48,
),
],
),
);
}

Widget _buildStudyTip() {
return Container(
padding: const EdgeInsets.all(18),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: const Color(0xFFE5EBF3),
),
),
child: const Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Icon(
Icons.lightbulb_rounded,
color: Color(0xFFE9A23B),
size: 28,
),
SizedBox(width: 12),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Focus Tip',
style: TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
color: Color(0xFF172B4D),
),
),
SizedBox(height: 6),
Text(
'Try focusing on one task at a time. Take regular breaks, stretch, and drink water to refresh your mind.',
style: TextStyle(
fontSize: 13,
height: 1.5,
color: Colors.blueGrey,
),
),
],
),
),
],
),
);
}

String _formatMinutes(int minutes) {
if (minutes < 60) return '${minutes}m';

final hours = minutes ~/ 60;
final remaining = minutes % 60;

return remaining == 0
? '${hours}h'
    : '${hours}h ${remaining}m';
}

String _getTodayFormattedDate() {
final now = DateTime.now();
const months = [
'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
const days = [
'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
];

return '${days[now.weekday - 1]}, '
'${months[now.month - 1]} ${now.day}';
}

void _addWater(
BuildContext context,
AppStateProvider appState,
) {
appState.addWaterGlass();

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Water logged successfully! 💧'),
behavior: SnackBarBehavior.floating,
duration: Duration(seconds: 2),
),
);
}

void _showCompletionDialog(
BuildContext context,
AppStateProvider appState,
) {
final bool wasStudy = appState.currentMode == SessionMode.study;

showDialog<void>(
context: context,
barrierDismissible: false,
builder: (dialogContext) {
return AlertDialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(24),
),
icon: Icon(
wasStudy
? Icons.emoji_events_rounded
    : Icons.coffee_rounded,
size: 48,
color: wasStudy ? primary : blue,
),
title: Text(
wasStudy ? 'Great Work!' : 'Break Completed!',
textAlign: TextAlign.center,
),
content: Text(
wasStudy
? 'You completed ${appState.studyDurationMins} minutes of focused study. Keep going!'
    : 'Your break is complete. Take a breath and get ready for your next task.',
textAlign: TextAlign.center,
),
actionsAlignment: MainAxisAlignment.center,
actions: [
TextButton(
onPressed: () {
appState.addWaterGlass();
appState.dismissCompletionDialog();
Navigator.of(dialogContext).pop();
},
child: const Text('Log Water 💧'),
),
ElevatedButton(
onPressed: () {
appState.dismissCompletionDialog();
Navigator.of(dialogContext).pop();
},
style: ElevatedButton.styleFrom(
backgroundColor: primary,
foregroundColor: Colors.white,
),
child: const Text('Continue'),
),
],
);
},
);
}
}
```