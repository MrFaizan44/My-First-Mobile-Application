```dart
return GestureDetector(
onTap: () => appState.setSessionMode(mode),
child: AnimatedContainer(
duration: const Duration(milliseconds: 300),
curve: Curves.easeInOut,
padding: const EdgeInsets.symmetric(
horizontal: 16,
vertical: 11,
),
decoration: BoxDecoration(
color: isSelected ? activeColor : Colors.transparent,
borderRadius: BorderRadius.circular(24),
boxShadow: isSelected
? [
BoxShadow(
color: activeColor.withAlpha(60),
blurRadius: 10,
offset: const Offset(0, 3),
),
]
    : [],
),
child: AnimatedDefaultTextStyle(
duration: const Duration(milliseconds: 250),
style: TextStyle(
color: isSelected ? Colors.white : Colors.grey.shade700,
fontWeight:
isSelected ? FontWeight.bold : FontWeight.w500,
fontSize: 13,
),
child: Text(label),
),
),
);
```