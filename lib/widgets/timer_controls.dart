import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';

/// Timer mode selection tabs and control action buttons (Start, Pause, Resume, Reset).
class TimerControls extends StatelessWidget {
  const TimerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final bool isBreak = appState.currentMode != SessionMode.study;
        final Color themeColor = isBreak
            ? const Color(0xFF4CAF50) // Soft Green
            : const Color(0xFF0288D1); // Light Blue

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
                    activeColor: const Color(0xFF0288D1),
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
            const SizedBox(height: 24),
            // Primary Action Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Start / Pause / Resume Primary Button
                if (appState.timerStatus == TimerStatus.idle ||
                    appState.timerStatus == TimerStatus.completed) ...[
                  ElevatedButton.icon(
                    onPressed: () => appState.startTimer(),
                    icon: const Icon(Icons.play_arrow_rounded, size: 28),
                    label: const Text(
                      'START',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 16),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber[800],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () => appState.resetTimer(),
                    icon: const Icon(Icons.refresh_rounded, size: 24),
                    label: const Text('RESET'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[400]!, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () => appState.resetTimer(),
                    icon: const Icon(Icons.refresh_rounded, size: 24),
                    label: const Text('RESET'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[700],
                      side: BorderSide(color: Colors.grey[400]!, width: 1.5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
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
