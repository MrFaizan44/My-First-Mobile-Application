import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';

/// Interactive circular timer display showing remaining time, progress ring,
/// and current mode badge.
class TimerDisplay extends StatelessWidget {
  const TimerDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final bool isBreak = appState.currentMode != SessionMode.study;

        // Theme colors: Light blue for study, Soft green for break
        final Color primaryColor = isBreak
            ? const Color(0xFF4CAF50) // Soft Green
            : const Color(0xFF0288D1); // Light Blue

        final Color backgroundColor = isBreak
            ? const Color(0xFFE8F5E9) // Light Green tint
            : const Color(0xFFE1F5FE); // Light Blue tint

        return Center(
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Outer background track circle
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
                // Inner card container with timer text & badges
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
                      // Mode Chip Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(20),
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
                      const SizedBox(height: 6),
                      // Large Digital Timer MM:SS
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
                      // Subtitle Status Message
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
