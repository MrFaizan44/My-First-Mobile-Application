```dart
import 'package:flutter/material.dart';

/// Reusable card widget for displaying study and hydration statistics.
class StatisticCard extends StatelessWidget {
final String title;
final String value;
final String? subtitle;
final IconData icon;
final Color color;
final VoidCallback? onTap;

const StatisticCard({
super.key,
required this.title,
required this.value,
this.subtitle,
required this.icon,
required this.color,
this.onTap,
});

@override
Widget build(BuildContext context) {
return Card(
elevation: 3,
shadowColor: color.withAlpha(45),
color: Colors.white,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(18),
),
child: InkWell(
onTap: onTap,
borderRadius: BorderRadius.circular(18),
splashColor: color.withAlpha(25),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Container(
padding: const EdgeInsets.all(11),
decoration: BoxDecoration(
color: color.withAlpha(25),
borderRadius: BorderRadius.circular(14),
),
child: Icon(
icon,
color: color,
size: 24,
),
),
if (onTap != null)
Icon(
Icons.arrow_forward_rounded,
color: color,
size: 22,
),
],
),
const SizedBox(height: 14),
Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
title,
style: TextStyle(
fontSize: 13,
fontWeight: FontWeight.w600,
color: Colors.grey.shade600,
),
),
const SizedBox(height: 5),
Text(
value,
style: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
color: Colors.blueGrey,
),
maxLines: 1,
overflow: TextOverflow.ellipsis,
),
if (subtitle != null) ...[
const SizedBox(height: 4),
Text(
subtitle!,
style: TextStyle(
fontSize: 11,
color: Colors.grey.shade500,
),
),
],
],
),
],
),
),
),
);
}
}
```