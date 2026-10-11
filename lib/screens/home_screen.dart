```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/app_state_provider.dart';
import '../widgets/timer_display.dart';
import '../widgets/timer_controls.dart';
import '../widgets/statistic_card.dart';

class HomeScreen extends StatelessWidget {
const HomeScreen({super.key});

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