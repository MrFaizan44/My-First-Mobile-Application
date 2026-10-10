import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/app_state_provider.dart';

/// Settings screen for configuring study/break durations, notification preferences,
/// user profile, and app resets.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    final appState = Provider.of<AppStateProvider>(context, listen: false);
    _nameController = TextEditingController(text: appState.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFF7F9FC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.5,
            title: const Text(
              'Settings',
              style: TextStyle(
                color: Color(0xFF263238),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Profile Section
                  _buildSectionHeader('User Profile'),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFFE1F5FE),
                            radius: 24,
                            child: Icon(Icons.person_rounded,
                                color: Color(0xFF0288D1), size: 28),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Student Name',
                                border: OutlineInputBorder(),
                                isDense: true,
                              ),
                              onChanged: (val) {
                                if (val.trim().isNotEmpty) {
                                  appState.updateUserSettings(
                                    userName: val.trim(),
                                    notificationsEnabled:
                                        appState.notificationsEnabled,
                                    hydrationRemindersEnabled:
                                        appState.hydrationRemindersEnabled,
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Timer Durations Section
                  _buildSectionHeader('Timer Durations (Minutes)'),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          _buildSliderSetting(
                            label: 'Focus Study Duration',
                            value: appState.studyDurationMins,
                            min: 5,
                            max: 90,
                            color: const Color(0xFF0288D1),
                            onChanged: (newVal) {
                              appState.updateTimerDurations(
                                studyMins: newVal.round(),
                                shortBreakMins: appState.shortBreakDurationMins,
                                longBreakMins: appState.longBreakDurationMins,
                              );
                            },
                          ),
                          const Divider(),
                          _buildSliderSetting(
                            label: 'Short Break Duration',
                            value: appState.shortBreakDurationMins,
                            min: 1,
                            max: 30,
                            color: const Color(0xFF4CAF50),
                            onChanged: (newVal) {
                              appState.updateTimerDurations(
                                studyMins: appState.studyDurationMins,
                                shortBreakMins: newVal.round(),
                                longBreakMins: appState.longBreakDurationMins,
                              );
                            },
                          ),
                          const Divider(),
                          _buildSliderSetting(
                            label: 'Long Break Duration',
                            value: appState.longBreakDurationMins,
                            min: 5,
                            max: 60,
                            color: const Color(0xFF8E24AA),
                            onChanged: (newVal) {
                              appState.updateTimerDurations(
                                studyMins: appState.studyDurationMins,
                                shortBreakMins: appState.shortBreakDurationMins,
                                longBreakMins: newVal.round(),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Notifications & Preferences Section
                  _buildSectionHeader('Notifications & Reminders'),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Timer Notifications',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text(
                              'Alerts when focus or break sessions finish'),
                          activeTrackColor: const Color(0xFF81D4FA),
                          activeThumbColor: const Color(0xFF0288D1),
                          value: appState.notificationsEnabled,
                          onChanged: (val) {
                            appState.updateUserSettings(
                              userName: appState.userName,
                              notificationsEnabled: val,
                              hydrationRemindersEnabled:
                                  appState.hydrationRemindersEnabled,
                            );
                          },
                        ),
                        const Divider(height: 1),
                        SwitchListTile(
                          title: const Text('Hydration Reminders 💧',
                              style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text(
                              'Remind to drink water during break sessions'),
                          activeTrackColor: const Color(0xFF80DEEA),
                          activeThumbColor: const Color(0xFF00ACC1),
                          value: appState.hydrationRemindersEnabled,
                          onChanged: (val) {
                            appState.updateUserSettings(
                              userName: appState.userName,
                              notificationsEnabled:
                                  appState.notificationsEnabled,
                              hydrationRemindersEnabled: val,
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Actions & Reset Section
                  _buildSectionHeader('Data Management'),
                  Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.water_drop_outlined,
                              color: Color(0xFF00ACC1)),
                          title: const Text('Reset Today\'s Water Intake'),
                          onTap: () {
                            appState.resetWaterGlasses();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Today\'s water intake reset to 0.'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.restore_rounded,
                              color: Colors.redAccent),
                          title: const Text('Reset All Settings & Data',
                              style: TextStyle(color: Colors.redAccent)),
                          onTap: () => _showResetAllDialog(context, appState),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // App Version Info Footer
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.timer_outlined,
                            size: 32, color: Colors.blueGrey[300]),
                        const SizedBox(height: 6),
                        Text(
                          'Break Buddy v1.0.0',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey[600],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Designed for students to focus, hydrate & excel 🎓',
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey[700],
        ),
      ),
    );
  }

  Widget _buildSliderSetting({
    required String label,
    required int value,
    required double min,
    required double max,
    required Color color,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withAlpha(25),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$value mins',
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        Slider(
          value: value.toDouble().clamp(min, max),
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          activeColor: color,
          inactiveColor: color.withAlpha(40),
          onChanged: onChanged,
        ),
      ],
    );
  }

  void _showResetAllDialog(BuildContext context, AppStateProvider appState) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Reset All Data?'),
          content: const Text(
            'This will clear all preferences, timer configurations, water logs, and session history back to default values. Are you sure?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                appState.resetAllAppData();
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('All app data has been reset.'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reset Everything'),
            ),
          ],
        );
      },
    );
  }
}
