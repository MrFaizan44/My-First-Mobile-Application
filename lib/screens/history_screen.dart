```dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../services/app_state_provider.dart';
import '../models/study_session.dart';

class HistoryScreen extends StatelessWidget {
const HistoryScreen({super.key});

static const Color primary = Color(0xFF00AFA6);
static const Color background = Color(0xFFF5F8FC);

@override
Widget build(BuildContext context) {
return Consumer<AppStateProvider>(
builder: (context, appState, child) {
final sessions = appState.sessionHistory.reversed.toList();

return Scaffold(
backgroundColor: background,
appBar: AppBar(
backgroundColor: background,
title: const Text(
'Your Progress',
style: TextStyle(
fontWeight: FontWeight.bold,
color: Color(0xFF172B4D),
),
),
actions: [
if (sessions.isNotEmpty)
IconButton(
tooltip: 'Clear history',
icon: const Icon(
Icons.delete_outline_rounded,
color: Colors.redAccent,
),
onPressed: () =>
_showClearDialog(context, appState),
),
const SizedBox(width: 8),
],
),
body: SafeArea(
child: SingleChildScrollView(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
_buildWelcomeHeader(),
const SizedBox(height: 20),

_buildStats(appState, sessions.length),

const SizedBox(height: 28),

Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
const Text(
'Recent Sessions',
style: TextStyle(
fontSize: 20,
fontWeight: FontWeight.bold,
color: Color(0xFF172B4D),
),
),
Text(
'${sessions.length} total',
style: const TextStyle(
color: Colors.blueGrey,
fontWeight: FontWeight.w500,
),
),
],
),

const SizedBox(height: 14),

if (sessions.isEmpty)
_buildEmptyState()
else
...sessions.map(
(session) => _buildSessionCard(session),
),
],
),
),
),
);
},
);
}

Widget _buildWelcomeHeader() {
return Container(
width: double.infinity,
padding: const EdgeInsets.all(22),
decoration: BoxDecoration(
gradient: const LinearGradient(
colors: [
Color(0xFF00AFA6),
Color(0xFF4776E6),
],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
borderRadius: BorderRadius.circular(24),
),
child: const Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Icon(
Icons.auto_awesome_rounded,
color: Colors.white,
size: 32,
),
SizedBox(height: 14),
Text(
'Keep up the great work!',
style: TextStyle(
color: Colors.white,
fontSize: 22,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 6),
Text(
'Every focused minute brings you closer to your goals.',
style: TextStyle(
color: Colors.white,
fontSize: 14,
height: 1.5,
),
),
],
),
);
}

Widget _buildStats(AppStateProvider appState, int totalSessions) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
const Text(
'Study Overview',
style: TextStyle(
fontSize: 19,
fontWeight: FontWeight.bold,
color: Color(0xFF172B4D),
),
),
const SizedBox(height: 14),

Row(
children: [
Expanded(
child: _statCard(
icon: Icons.today_rounded,
title: 'Today',
value: _formatMinutes(appState.todayStudyMinutes),
subtitle:
'${appState.todayCompletedSessionsCount} sessions',
color: const Color(0xFF00AFA6),
),
),
const SizedBox(width: 12),
Expanded(
child: _statCard(
icon: Icons.date_range_rounded,
title: 'This Week',
value: _formatMinutes(appState.weeklyStudyMinutes),
subtitle:
'${appState.weeklyCompletedSessionsCount} sessions',
color: const Color(0xFF4776E6),
),
),
],
),

const SizedBox(height: 12),

_statCard(
icon: Icons.emoji_events_rounded,
title: 'Total Study Time',
value: _formatMinutes(appState.totalStudyMinutesAllTime),
subtitle: '$totalSessions completed sessions',
color: const Color(0xFF9C6ADE),
horizontal: true,
),
],
);
}

Widget _statCard({
required IconData icon,
required String title,
required String value,
required String subtitle,
required Color color,
bool horizontal = false,
}) {
return Container(
width: double.infinity,
padding: const EdgeInsets.all(16),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(20),
border: Border.all(
color: const Color(0xFFE8EDF4),
),
),
child: horizontal
? Row(
children: [
_iconBox(icon, color),
const SizedBox(width: 14),
Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: const TextStyle(
color: Colors.blueGrey,
fontSize: 13,
),
),
const SizedBox(height: 5),
Text(
value,
style: const TextStyle(
fontSize: 23,
fontWeight: FontWeight.bold,
color: Color(0xFF172B4D),
),
),
Text(
subtitle,
style: const TextStyle(
fontSize: 12,
color: Colors.blueGrey,
),
),
],
),
),
],
)
    : Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
_iconBox(icon, color),
const SizedBox(height: 14),
Text(
title,
style: const TextStyle(
color: Colors.blueGrey,
fontSize: 13,
),
),
const SizedBox(height: 5),
FittedBox(
fit: BoxFit.scaleDown,
alignment: Alignment.centerLeft,
child: Text(
value,
style: const TextStyle(
fontSize: 23,
fontWeight: FontWeight.bold,
color: Color(0xFF172B4D),
),
),
),
const SizedBox(height: 4),
Text(
subtitle,
style: const TextStyle(
fontSize: 11,
color: Colors.blueGrey,
),
),
],
),
);
}

Widget _iconBox(IconData icon, Color color) {
return Container(
padding: const EdgeInsets.all(10),
decoration: BoxDecoration(
color: color.withValues(alpha: 0.12),
borderRadius: BorderRadius.circular(14),
),
child: Icon(icon, color: color, size: 23),
);
}

String _formatMinutes(int minutes) {
if (minutes < 60) return '${minutes}m';

final hours = minutes ~/ 60;
final remainingMinutes = minutes % 60;

if (remainingMinutes == 0) return '${hours}h';

return '${hours}h ${remainingMinutes}m';
}

Widget _buildSessionCard(StudySession session) {
final bool isStudy = session.sessionType == StudySession.study;
final bool isShortBreak =
session.sessionType == StudySession.shortBreak;

final Color color = isStudy
? primary
    : isShortBreak
? const Color(0xFF43A66B)
    : const Color(0xFF9C6ADE);

final IconData icon = isStudy
? Icons.menu_book_rounded
    : isShortBreak
? Icons.coffee_rounded
    : Icons.spa_rounded;

final String time = DateFormat(
'MMM d, y • h:mm a',
).format(session.timestamp);

return Container(
margin: const EdgeInsets.only(bottom: 12),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(18),
border: Border.all(
color: const Color(0xFFE8EDF4),
),
),
child: ListTile(
contentPadding: const EdgeInsets.symmetric(
horizontal: 14,
vertical: 10,
),
leading: Container(
width: 48,
height: 48,
decoration: BoxDecoration(
color: color.withValues(alpha: 0.12),
borderRadius: BorderRadius.circular(15),
),
child: Icon(icon, color: color, size: 25),
),
title: Text(
session.displayType,
style: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.bold,
color: Color(0xFF172B4D),
),
),
subtitle: Padding(
padding: const EdgeInsets.only(top: 5),
child: Text(
'$time\n${session.subject}',
maxLines: 2,
overflow: TextOverflow.ellipsis,
style: const TextStyle(
height: 1.5,
fontSize: 11,
color: Colors.blueGrey,
),
),
),
trailing: Container(
padding: const EdgeInsets.symmetric(
horizontal: 10,
vertical: 7,
),
decoration: BoxDecoration(
color: color.withValues(alpha: 0.10),
borderRadius: BorderRadius.circular(12),
),
child: Text(
session.formattedDuration,
style: TextStyle(
color: color,
fontWeight: FontWeight.bold,
fontSize: 12,
),
),
),
),
);
}

Widget _buildEmptyState() {
return Container(
width: double.infinity,
padding: const EdgeInsets.symmetric(
horizontal: 24,
vertical: 36,
),
decoration: BoxDecoration(
color: Colors.white,
borderRadius: BorderRadius.circular(22),
border: Border.all(
color: const Color(0xFFE8EDF4),
),
),
child: const Column(
children: [
Icon(
Icons.hourglass_empty_rounded,
size: 60,
color: Color(0xFF00AFA6),
),
SizedBox(height: 16),
Text(
'Your journey starts here',
style: TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: Color(0xFF172B4D),
),
),
SizedBox(height: 8),
Text(
'Complete your first study session on the Home screen. Your progress will appear here.',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 13,
height: 1.6,
color: Colors.blueGrey,
),
),
],
),
);
}

void _showClearDialog(
BuildContext context,
AppStateProvider appState,
) {
showDialog<void>(
context: context,
builder: (dialogContext) {
return AlertDialog(
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(22),
),
icon: const Icon(
Icons.delete_sweep_rounded,
color: Colors.redAccent,
size: 34,
),
title: const Text('Clear History?'),
content: const Text(
'All completed session records will be permanently deleted. This action cannot be undone.',
),
actions: [
TextButton(
onPressed: () => Navigator.pop(dialogContext),
child: const Text('Cancel'),
),
ElevatedButton(
style: ElevatedButton.styleFrom(
backgroundColor: Colors.redAccent,
foregroundColor: Colors.white,
),
onPressed: () {
appState.clearSessionHistory();
Navigator.pop(dialogContext);

ScaffoldMessenger.of(context).showSnackBar(
const SnackBar(
content: Text('Session history cleared.'),
behavior: SnackBarBehavior.floating,
),
);
},
child: const Text('Clear All'),
),
],
);
},
);
}
}
```