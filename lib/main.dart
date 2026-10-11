
body: AnimatedSwitcher(
duration: const Duration(milliseconds: 300),
switchInCurve: Curves.easeOutCubic,
switchOutCurve: Curves.easeInCubic,
transitionBuilder: (child, animation) {
final slideAnimation = Tween<Offset>(
begin: const Offset(0.04, 0),
end: Offset.zero,
).animate(animation);

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
