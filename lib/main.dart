```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/app_state_provider.dart';
import 'screens/home_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
WidgetsFlutterBinding.ensureInitialized();

final appStateProvider = AppStateProvider();
await appStateProvider.init();

runApp(
ChangeNotifierProvider<AppStateProvider>.value(
value: appStateProvider,
child: const BreakBuddyApp(),
),
);
}

/// Root widget for Break Buddy.
class BreakBuddyApp extends StatelessWidget {
const BreakBuddyApp({super.key});

static const Color primaryColor = Color(0xFF00AFA6);
static const Color secondaryColor = Color(0xFF4776E6);
static const Color backgroundColor = Color(0xFFF5F8FC);

@override
Widget build(BuildContext context) {
final colorScheme = ColorScheme.fromSeed(
seedColor: primaryColor,
brightness: Brightness.light,
).copyWith(
primary: primaryColor,
secondary: secondaryColor,
surface: Colors.white,
);

return MaterialApp(
title: 'Break Buddy',
debugShowCheckedModeBanner: false,

theme: ThemeData(
useMaterial3: true,
colorScheme: colorScheme,
scaffoldBackgroundColor: backgroundColor,
fontFamily: 'Roboto',

appBarTheme: const AppBarTheme(
backgroundColor: backgroundColor,
foregroundColor: Color(0xFF172B4D),
elevation: 0,
centerTitle: false,
titleTextStyle: TextStyle(
fontSize: 23,
fontWeight: FontWeight.bold,
color: Color(0xFF172B4D),
),
),

cardTheme: CardThemeData(
color: Colors.white,
elevation: 1,
shadowColor: const Color(0xFF172B4D).withValues(alpha: 0.06),
margin: EdgeInsets.zero,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(20),
),
),

navigationBarTheme: NavigationBarThemeData(
backgroundColor: Colors.white,
elevation: 0,
height: 72,
indicatorColor: primaryColor.withValues(alpha: 0.13),
labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
(states) {
if (states.contains(WidgetState.selected)) {
return const IconThemeData(
color: primaryColor,
size: 25,
);
}

return const IconThemeData(
color: Color(0xFF8491A5),
size: 23,
);
},
),
labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
(states) {
return TextStyle(
fontSize: 12,
fontWeight: states.contains(WidgetState.selected)
? FontWeight.w700
    : FontWeight.w500,
color: states.contains(WidgetState.selected)
? primaryColor
    : const Color(0xFF8491A5),
);
},
),
),

elevatedButtonTheme: ElevatedButtonThemeData(
style: ElevatedButton.styleFrom(
backgroundColor: primaryColor,
foregroundColor: Colors.white,
elevation: 0,
padding: const EdgeInsets.symmetric(
horizontal: 24,
vertical: 16,
),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(14),
),
textStyle: const TextStyle(
fontSize: 15,
fontWeight: FontWeight.w600,
),
),
),

inputDecorationTheme: InputDecorationTheme(
filled: true,
fillColor: Colors.white,
contentPadding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 16,
),
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: Color(0xFFE2E8F0),
),
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: Color(0xFFE2E8F0),
),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(14),
borderSide: const BorderSide(
color: primaryColor,
width: 1.5,
),
),
),
),

home: const MainNavigationScreen(),
);
}
}

/// Main navigation for Home, History, and Settings.
class MainNavigationScreen extends StatefulWidget {
const MainNavigationScreen({super.key});

@override
State<MainNavigationScreen> createState() =>
_MainNavigationScreenState();
}

class _MainNavigationScreenState
extends State<MainNavigationScreen> {
int _currentIndex = 0;

final List<Widget> _screens = const [
HomeScreen(),
HistoryScreen(),
SettingsScreen(),
];

@override
Widget build(BuildContext context) {
return Scaffold(
body: IndexedStack(
index: _currentIndex,
children: _screens,
),

bottomNavigationBar: SafeArea(
top: false,
child: Container(
decoration: BoxDecoration(
color: Colors.white,
boxShadow: [
BoxShadow(
color: const Color(0xFF172B4D)
    .withValues(alpha: 0.06),
blurRadius: 20,
offset: const Offset(0, -4),
),
],
),
child: NavigationBar(
selectedIndex: _currentIndex,
onDestinationSelected: (index) {
setState(() {
_currentIndex = index;
});
},
destinations: const [
NavigationDestination(
icon: Icon(Icons.timer_outlined),
selectedIcon: Icon(Icons.timer_rounded),
label: 'Home',
),
NavigationDestination(
icon: Icon(Icons.history_rounded),
selectedIcon: Icon(Icons.bar_chart_rounded),
label: 'History',
),
NavigationDestination(
icon: Icon(Icons.settings_outlined),
selectedIcon: Icon(Icons.settings_rounded),
label: 'Settings',
),
],
),
),
),
);
}
}
```