
body: AnimatedSwitcher(
duration: const Duration(milliseconds: 450),
switchInCurve: Curves.easeOutBack,
switchOutCurve: Curves.easeIn,
transitionBuilder: (child, animation) {
final slideAnimation = Tween<Offset>(
begin: const Offset(0, 0.08),
end: Offset.zero,
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
child: child,
),
);
},
child: KeyedSubtree(
key: ValueKey<int>(_currentIndex),
child: _screens[_currentIndex],
),
),
