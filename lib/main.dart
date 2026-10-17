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

/// Root widget for Break Buddy application.
class BreakBuddyApp extends StatelessWidget {
  const BreakBuddyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStateProvider>(
      builder: (context, appState, child) {
        final primaryColor = appState.primaryThemeColor;

        return MaterialApp(
          title: 'Break Buddy',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: primaryColor,
              primary: primaryColor,
              secondary: const Color(0xFF4CAF50),
              surface: const Color(0xFFF7F9FC),
            ),
            scaffoldBackgroundColor: const Color(0xFFF7F9FC),
            fontFamily: 'Roboto',
          ),
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}

/// Main container with bottom navigation bar switching between Home, History, and Settings screens.
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    HistoryScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppStateProvider>(context);
    final primaryColor = appState.primaryThemeColor;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: Colors.white,
        elevation: 8,
        indicatorColor: primaryColor.withAlpha(35),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer_rounded, color: primaryColor),
            label: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart_rounded, color: primaryColor),
            label: 'History',
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded, color: primaryColor),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
