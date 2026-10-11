```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';

<<<<<<< HEAD
/// Interactive circular timer display showing remaining time,
/// animated progress ring, and current mode badge.
=======
/// Interactive circular timer display showing remaining time, progress ring,
/// active subject badge, and current mode status.
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c
class TimerDisplay extends StatelessWidget {
const TimerDisplay({super.key});

@override
Widget build(BuildContext context) {
return Consumer<AppStateProvider>(
builder: (context, appState, child) {
final bool isBreak =
appState.currentMode != SessionMode.study;

<<<<<<< HEAD
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
=======
        final Color primaryColor = isBreak
            ? const Color(0xFF4CAF50)
            : appState.primaryThemeColor;

        final Color backgroundColor = isBreak
            ? const Color(0xFFE8F5E9)
            : primaryColor.withAlpha(25);

        return Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer glowing aura ring when running
                if (appState.timerStatus == TimerStatus.running)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    width: 285,
                    height: 285,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor.withAlpha(15),
                    ),
                  ),

                // Background track circle
                SizedBox(
                  width: 270,
                  height: 270,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 14,
                    valueColor: AlwaysStoppedAnimation<Color>(backgroundColor),
                  ),
                ),

                // Active animated progress indicator
                SizedBox(
                  width: 270,
                  height: 270,
                  child: CircularProgressIndicator(
                    value: appState.progressFraction,
                    strokeWidth: 14,
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                ),

                // Inner card container
                Container(
                  width: 230,
                  height: 230,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withAlpha(35),
                        blurRadius: 20,
                        spreadRadius: 4,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Mode & Subject Chip Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          !isBreak
                              ? '${appState.selectedSubject} • ${appState.modeLabel}'
                              : appState.modeLabel,
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Digital Countdown MM:SS
                      Text(
                        appState.formattedTime,
                        style: TextStyle(
                          fontSize: 44,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey[900],
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Status Subtitle
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          _getSubtitleText(appState),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),

                      // Ambient Sound Badge Indicator
                      if (appState.activeAmbientSound != 'None') ...[
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.graphic_eq_rounded,
                                size: 12, color: Color(0xFF4CAF50)),
                            const SizedBox(width: 4),
                            Text(
                              appState.activeAmbientSound,
                              style: const TextStyle(
                                fontSize: 10,
                                color: Color(0xFF2E7D32),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
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
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c

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