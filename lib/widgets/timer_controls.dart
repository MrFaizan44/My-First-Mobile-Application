<<<<<<< HEAD
```dart
return GestureDetector(
onTap: () => appState.setSessionMode(mode),
child: AnimatedContainer(
duration: const Duration(milliseconds: 300),
curve: Curves.easeInOut,
padding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 11,
),
decoration: BoxDecoration(
color: isSelected ? activeColor : Colors.transparent,
borderRadius: BorderRadius.circular(24),
boxShadow: isSelected
? [
BoxShadow(
color: activeColor.withAlpha(60),
blurRadius: 10,
offset: const Offset(0, 3),
),
]
    : [],
),
child: AnimatedDefaultTextStyle(
duration: const Duration(milliseconds: 250),
style: TextStyle(
color: isSelected ? Colors.white : Colors.grey.shade700,
fontWeight:
isSelected ? FontWeight.bold : FontWeight.w500,
fontSize: 13,
),
child: Text(label),
),
),
);
```
=======
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';

/// Timer mode selection tabs, subject selector, preset duration chips,
/// and control action buttons (Start, Pause, Resume, Reset).
class TimerControls extends StatelessWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final bool isBreak = appState.currentMode != SessionMode.study;
        final Color themeColor = isBreak
            ? const Color(0xFF4CAF50)
            : appState.primaryThemeColor;

        return Column(
          children: [
            // Mode Switcher Tabs
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildModeTab(
                    context: context,
                    appState: appState,
                    mode: SessionMode.study,
                    label: 'Study (${appState.studyDurationMins}m)',
                    activeColor: appState.primaryThemeColor,
                  ),
                  _buildModeTab(
                    context: context,
                    appState: appState,
                    mode: SessionMode.shortBreak,
                    label: 'Short (${appState.shortBreakDurationMins}m)',
                    activeColor: const Color(0xFF4CAF50),
                  ),
                  _buildModeTab(
                    context: context,
                    appState: appState,
                    mode: SessionMode.longBreak,
                    label: 'Long (${appState.longBreakDurationMins}m)',
                    activeColor: const Color(0xFF4CAF50),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Subject Tag Selector (when idle and in Study Mode)
            if (appState.currentMode == SessionMode.study &&
                appState.timerStatus == TimerStatus.idle) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: appState.availableSubjects.map((subject) {
                    final bool isSelected = appState.selectedSubject == subject;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(
                          subject,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? Colors.white : Colors.grey[800],
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: appState.primaryThemeColor,
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        onSelected: (selected) {
                          if (selected) {
                            appState.setSelectedSubject(subject);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Action Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (appState.timerStatus == TimerStatus.idle ||
                    appState.timerStatus == TimerStatus.completed) ...[
                  ElevatedButton.icon(
                    onPressed: () => appState.startTimer(),
                    icon: const Icon(Icons.play_arrow_rounded, size: 28),
                    label: const Text(
                      'START FOCUS',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 36, vertical: 14),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ] else if (appState.timerStatus == TimerStatus.running) ...[
                  ElevatedButton.icon(
                    onPressed: () => appState.pauseTimer(),
                    icon: const Icon(Icons.pause_rounded, size: 28),
                    label: const Text(
                      'PAUSE',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  OutlinedButton.icon(
                    onPressed: () => appState.resetTimer(),
                    icon: const Icon(Icons.refresh_rounded, size: 22),
                    label: const Text('RESET'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[400]!, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ] else if (appState.timerStatus == TimerStatus.paused) ...[
                  ElevatedButton.icon(
                    onPressed: () => appState.resumeTimer(),
                    icon: const Icon(Icons.play_arrow_rounded, size: 28),
                    label: const Text(
                      'RESUME',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  OutlinedButton.icon(
                    onPressed: () => appState.resetTimer(),
                    icon: const Icon(Icons.refresh_rounded, size: 22),
                    label: const Text('RESET'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[400]!, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildModeTab({
    required BuildContext context,
    required AppStateProvider appState,
    required SessionMode mode,
    required String label,
    required Color activeColor,
  }) {
    final bool isSelected = appState.currentMode == mode;

    return GestureDetector(
      onTap: () => appState.setSessionMode(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withAlpha(80),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c
