```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';

/// Interactive circular timer display showing remaining time,
/// animated progress ring, and current mode badge.
class TimerDisplay extends StatelessWidget {
const TimerDisplay({super.key});

@override
Widget build(BuildContext context) {
return Consumer<AppStateProvider>(
builder: (context, appState, child) {
final bool isBreak =
appState.currentMode != SessionMode.study;

final Color primaryColor = isBreak
? const Color(0xFF4CAF50)
    : const Color(0xFF0288D1);

final Color backgroundColor = isBreak
? const Color(0xFFE8F5E9)
    : const Color(0xFFE1F5FE);

return Center(
child: Container(
padding: const EdgeInsets.all(12),
child: Stack(
alignment: Alignment.center,
children: [
// Background progress ring
SizedBox(
width: 270,
height: 270,
child: CircularProgressIndicator(
value: 1.0,
strokeWidth: 14,
strokeCap: StrokeCap.round,
valueColor:
AlwaysStoppedAnimation<Color>(
backgroundColor,
),
),
),

// Animated progress ring
SizedBox(
width: 270,
height: 270,
child: TweenAnimationBuilder<double>(
tween: Tween<double>(
begin: 0,
end: appState.progressFraction
    .clamp(0.0, 1.0)
    .toDouble(),
),
duration: const Duration(milliseconds: 500),
curve: Curves.easeInOut,
builder: (context, progress, child) {
return CircularProgressIndicator(
value: progress,
strokeWidth: 14,
strokeCap: StrokeCap.round,
valueColor:
AlwaysStoppedAnimation<Color>(
primaryColor,
),
);
},
),
),

// Inner timer circle
Container(
width: 230,
height: 230,
decoration: BoxDecoration(
color: Colors.white,
shape: BoxShape.circle,
boxShadow: [
BoxShadow(
color: primaryColor.withAlpha(30),
blurRadius: 20,
spreadRadius: 4,
offset: const Offset(0, 6),
),
],
),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
// Current mode badge
AnimatedContainer(
duration:
const Duration(milliseconds: 300),
padding: const EdgeInsets.symmetric(
horizontal: 12,
vertical: 5,
),
decoration: BoxDecoration(
color: backgroundColor,
borderRadius:
BorderRadius.circular(20),
),
child: Text(
appState.modeLabel,
style: TextStyle(
color: primaryColor,
fontWeight: FontWeight.bold,
fontSize: 12,
),
),
),

const SizedBox(height: 8),

// Animated digital timer
AnimatedSwitcher(
duration:
const Duration(milliseconds: 250),
transitionBuilder: (child, animation) {
return FadeTransition(
opacity: animation,
child: child,
);
},
child: Text(
appState.formattedTime,
key: ValueKey(
appState.formattedTime,
),
style: TextStyle(
fontSize: 44,
fontWeight: FontWeight.bold,
color: Colors.blueGrey.shade900,
letterSpacing: 1.5,
),
),
),

const SizedBox(height: 6),

// Timer status subtitle
Padding(
padding: const EdgeInsets.symmetric(
horizontal: 16,
),
child: Text(
_getSubtitleText(appState),
textAlign: TextAlign.center,
maxLines: 1,
overflow: TextOverflow.ellipsis,
style: TextStyle(
fontSize: 12,
fontWeight: FontWeight.w500,
color: Colors.grey.shade600,
),
),
),
],
),
),
],
),
),
);
},
);
}

String _getSubtitleText(AppStateProvider appState) {
switch (appState.timerStatus) {
case TimerStatus.running:
return appState.currentMode == SessionMode.study
? 'Deep focus in progress...'
    : 'Relax & recharge!';

case TimerStatus.paused:
return 'Timer Paused ⏸️';

case TimerStatus.completed:
return 'Session Finished! 🎉';

case TimerStatus.idle:
return 'Tap Start when ready';
}
}
}
```