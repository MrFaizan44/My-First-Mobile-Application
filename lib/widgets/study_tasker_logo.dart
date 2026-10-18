import 'package:flutter/material.dart';

/// Custom logo widget for StudyTasker application
class StudyTaskerLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? textColor;

  const StudyTaskerLogo({
    super.key,
    this.size = 28,
    this.showText = true,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    // Brand Colors from StudyTasker logo
    const Color timerColor = Color(0xFFE91E63); // Pink / Magenta
    const Color studyColor = Color(0xFF0288D1); // Soft Cyan Blue
    const Color taskerColor = Color(0xFF7C3AED); // Soft Purple

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Custom Stopwatch / Timer Icon Badge
        Container(
          width: size,
          height: size,
          padding: EdgeInsets.all(size * 0.15),
          decoration: BoxDecoration(
            color: timerColor.withAlpha(25),
            shape: BoxShape.circle,
            border: Border.all(color: timerColor, width: 1.5),
          ),
          child: Center(
            child: Icon(
              Icons.timer_outlined,
              color: timerColor,
              size: size * 0.65,
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 8),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'STUDY',
                  style: TextStyle(
                    fontSize: size * 0.6,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: textColor ?? studyColor,
                    fontFamily: 'Roboto',
                  ),
                ),
                TextSpan(
                  text: 'TASKER',
                  style: TextStyle(
                    fontSize: size * 0.6,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.8,
                    color: textColor ?? taskerColor,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
