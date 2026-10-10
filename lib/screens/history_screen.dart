import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';
import '../models/study_session.dart';

/// Screen displaying study statistics, metrics, and history list of completed sessions.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final sessions = appState.sessionHistory.reversed.toList();

        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            centerTitle: false,
            title: const Text(
              'Session History & Stats',
              style: TextStyle(
                color: Color(0xFF263238),
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              if (sessions.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                  tooltip: 'Clear History',
                  onPressed: () => _showClearConfirmationDialog(context, appState),
                ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Overview Stats Header Box
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0288D1), Color(0xFF03A9F4)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF0288D1).withAlpha(80),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.insights_rounded, color: Colors.white, size: 24),
                            SizedBox(width: 8),
                            Text(
                              'Study Summary',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildSummaryItem(
                              label: 'Today',
                              value: '${appState.todayStudyMinutes}m',
                              subValue: '${appState.todayCompletedSessionsCount} sessions',
                            ),
                            Container(
                              height: 36,
                              width: 1,
                              color: Colors.white.withAlpha(100),
                            ),
                            _buildSummaryItem(
                              label: 'This Week',
                              value: '${appState.weeklyStudyMinutes}m',
                              subValue: '${appState.weeklyCompletedSessionsCount} sessions',
                            ),
                            Container(
                              height: 36,
                              width: 1,
                              color: Colors.white.withAlpha(100),
                            ),
                            _buildSummaryItem(
                              label: 'All-Time',
                              value: '${appState.totalStudyMinutesAllTime}m',
                              subValue: '${sessions.length} total',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    'Recent Sessions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[900],
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (sessions.isEmpty)
                    _buildEmptyState()
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: sessions.length,
                      itemBuilder: (context, index) {
                        final session = sessions[index];
                        return _buildSessionCard(session);
                      },
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required String subValue,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withAlpha(200),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subValue,
          style: TextStyle(
            color: Colors.white.withAlpha(180),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildSessionCard(StudySession session) {
    final bool isStudy = session.sessionType == 'study';
    final bool isShortBreak = session.sessionType == 'short_break';

    final IconData icon = isStudy
        ? Icons.psychology_rounded
        : (isShortBreak ? Icons.local_cafe_rounded : Icons.beach_access_rounded);

    final Color color = isStudy
        ? const Color(0xFF0288D1)
        : (isShortBreak ? const Color(0xFF4CAF50) : const Color(0xFF8E24AA));

    final String timeStr = DateFormat('MMM d, y • h:mm a').format(session.timestamp);

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withAlpha(25),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          session.displayType,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          timeStr,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: color.withAlpha(20),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${session.durationMinutes} mins',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(Icons.history_toggle_off_rounded,
              size: 64, color: Colors.blueGrey[200]),
          const SizedBox(height: 12),
          Text(
            'No Study Sessions Yet',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[800],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Start a session on the Home screen. Your completed sessions and study time will show up here!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showClearConfirmationDialog(
      BuildContext context, AppStateProvider appState) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text('Clear Session History?'),
          content: const Text(
            'This will permanently delete all completed session logs from local storage. Are you sure?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                appState.clearSessionHistory();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Session history cleared.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Clear All'),
            ),
          ],
        );
      },
    );
  }
}
