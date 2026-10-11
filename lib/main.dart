
body: AnimatedSwitcher(
duration: const Duration(milliseconds: 500),
reverseDuration: const Duration(milliseconds: 300),
switchInCurve: Curves.easeOutQuart,
switchOutCurve: Curves.easeInCubic,
transitionBuilder: (child, animation) {
final slideAnimation = Tween<Offset>(
begin: const Offset(0.12, 0),
end: Offset.zero,
).animate(
CurvedAnimation(
parent: animation,
curve: Curves.easeOutQuart,
),
);

final scaleAnimation = Tween<double>(
begin: 0.96,
end: 1.0,
).animate(
CurvedAnimation(
parent: animation,
curve: Curves.easeOutCubic,
),
);

<<<<<<< HEAD
return FadeTransition(
opacity: animation,
child: SlideTransition(
position: slideAnimation,
child: ScaleTransition(
scale: scaleAnimation,
child: child,
),
),
);
},
child: KeyedSubtree(
key: ValueKey<int>(_currentIndex),
child: _screens[_currentIndex],
),
),
=======
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
>>>>>>> 9767c7eb43a25ab2a83e45be8b6861fc20b0b00c
