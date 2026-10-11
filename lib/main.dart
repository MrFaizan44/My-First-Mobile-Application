
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
