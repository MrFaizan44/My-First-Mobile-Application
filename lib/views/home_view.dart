import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/custom_card.dart';
import '../models/course_model.dart';

/// Home Dashboard Tab for CampusOS
class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample running courses (Mathematics, Chemistry, etc.) with colorful gradients / pastel cards
    final List<CourseModel> runningCourses = [
      CourseModel(
        id: '1',
        code: 'MATH201',
        title: 'Advanced Mathematics',
        instructor: 'Dr. Robert Vance',
        room: 'Hall 302',
        scheduleTime: '09:00 AM',
        backgroundColor: AppTheme.pastelAmber,
        borderColor: AppTheme.pastelAmberBorder,
      ),
      CourseModel(
        id: '2',
        code: 'CHEM102',
        title: 'Organic Chemistry',
        instructor: 'Prof. Elena Rostova',
        room: 'Lab B-12',
        scheduleTime: '11:15 AM',
        backgroundColor: AppTheme.pastelGreen,
        borderColor: AppTheme.pastelGreenBorder,
      ),
      CourseModel(
        id: '3',
        code: 'CS301',
        title: 'Data Structures & Algorithms',
        instructor: 'Prof. Sarah Jenkins',
        room: 'Room 402B',
        scheduleTime: '02:00 PM',
        backgroundColor: AppTheme.pastelPurple,
        borderColor: AppTheme.pastelPurpleBorder,
      ),
      CourseModel(
        id: '4',
        code: 'PHY205',
        title: 'Quantum Physics',
        instructor: 'Dr. Alan Grant',
        room: 'Hall 101',
        scheduleTime: '04:00 PM',
        backgroundColor: AppTheme.pastelBlue,
        borderColor: AppTheme.pastelBlueBorder,
      ),
    ];

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Greeting Section ("Hello Alex" + Notification Bell + Profile Avatar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.primaryColor.withAlpha(50),
                            width: 2,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 24,
                          backgroundColor: AppTheme.pastelBlue,
                          child: Icon(Icons.person_rounded,
                              color: AppTheme.primaryColor, size: 26),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, Alex!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Welcome back to CampusOS ✨',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.notifications_none_rounded,
                                color: AppTheme.textPrimary, size: 26),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              side: BorderSide(
                                color: Colors.grey.withAlpha(40),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 12,
                            top: 12,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.pastelRoseBorder,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // 2. Prominent Summary Card Banner (Highlights tasks for the day e.g. "You've got 4 tasks today")
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1E293B), Color(0xFF334155)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E293B).withAlpha(40),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(30),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'DAILY OVERVIEW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ),
                        const Icon(Icons.flare_rounded,
                            color: AppTheme.accentColor, size: 20),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "You've got 4 tasks today",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '2 assignments due by midnight & 2 lectures left on your schedule.',
                      style: TextStyle(
                        color: Colors.white.withAlpha(200),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 0.5,
                      backgroundColor: Colors.white.withAlpha(30),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppTheme.accentColor),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress: 2 of 4 completed',
                          style: TextStyle(
                            color: Colors.white.withAlpha(180),
                            fontSize: 11,
                          ),
                        ),
                        const Text(
                          '50%',
                          style: TextStyle(
                            color: AppTheme.accentColor,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // 3. Horizontal or Grid Section for "Courses" (Mathematics, Chemistry, etc. inside colorful rounded gradient cards)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Running Courses',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Horizontal scrollable course cards with gorgeous gradient / pastel aesthetics
              SizedBox(
                height: 155,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: runningCourses.length,
                  itemBuilder: (context, index) {
                    final course = runningCourses[index];
                    return Container(
                      width: 210,
                      margin: const EdgeInsets.only(right: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: course.backgroundColor,
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(
                          color: course.borderColor.withAlpha(120),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: course.borderColor.withAlpha(30),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  course.code,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: course.borderColor,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.bookmark_rounded,
                                color: course.borderColor,
                                size: 18,
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                course.title,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                course.instructor,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.access_time_rounded,
                                  size: 12, color: AppTheme.textSecondary),
                              const SizedBox(width: 4),
                              Text(
                                course.scheduleTime,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 24),

              // 4. "Your schedule" Section Underneath (Upcoming classes & tasks with time badges and Google Meet / Zoom links)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Your Schedule & Meetings',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Timetable'),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Schedule item 1: Google Meet Lecture
              _buildScheduleCard(
                courseCode: 'MATH201',
                title: 'Advanced Mathematics Lecture',
                timeBadge: '09:00 AM - 10:30 AM',
                instructor: 'Dr. Robert Vance',
                location: 'Room 302 / Virtual',
                meetingPlatform: 'Google Meet',
                meetingUrl: 'meet.google.com/abc-xyz-def',
                badgeColor: AppTheme.pastelAmberBorder,
                cardBg: AppTheme.pastelAmber,
                iconData: Icons.video_call_rounded,
              ),

              const SizedBox(height: 14),

              // Schedule item 2: Zoom Lab session
              _buildScheduleCard(
                courseCode: 'CHEM102',
                title: 'Organic Chemistry Lab & Discussion',
                timeBadge: '11:15 AM - 12:45 PM',
                instructor: 'Prof. Elena Rostova',
                location: 'Lab B-12 / Zoom',
                meetingPlatform: 'Zoom Meeting',
                meetingUrl: 'zoom.us/j/1234567890',
                badgeColor: AppTheme.pastelGreenBorder,
                cardBg: AppTheme.pastelGreen,
                iconData: Icons.videocam_rounded,
              ),

              const SizedBox(height: 14),

              // Schedule item 3: Task deadline reminder
              CustomCard(
                backgroundColor: Colors.white,
                borderColor: Colors.grey.withAlpha(40),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.pastelRose,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.assignment_late_rounded,
                          color: AppTheme.pastelRoseBorder, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Assignment Due',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.pastelRoseBorder,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: AppTheme.pastelRose,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Due 11:59 PM',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.pastelRoseBorder,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Data Structures Lab Report #3',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            'Submit PDF via CampusOS Portal',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper widget for building schedule cards with meeting links (Google Meet / Zoom)
  Widget _buildScheduleCard({
    required String courseCode,
    required String title,
    required String timeBadge,
    required String instructor,
    required String location,
    required String meetingPlatform,
    required String meetingUrl,
    required Color badgeColor,
    required Color cardBg,
    required IconData iconData,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: badgeColor.withAlpha(100), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: badgeColor.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  courseCode,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withAlpha(30),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  timeBadge,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.person_outline_rounded,
                  size: 14, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Text(
                instructor,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.location_on_outlined,
                  size: 14, color: AppTheme.textSecondary),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  location,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(iconData, size: 18, color: badgeColor),
                  const SizedBox(width: 6),
                  Text(
                    meetingPlatform,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.link_rounded, size: 14),
                label: const Text('Join Link', style: TextStyle(fontSize: 12)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

