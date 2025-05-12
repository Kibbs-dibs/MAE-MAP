import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../screens/camera_access_screen.dart';
import '../screens/schedule_screen.dart';
import '../screens/routing_screen.dart';
import '../widgets/feature_tile.dart';

class DashboardScreen extends StatelessWidget {
  final UserModel user;

  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final role = user.role;

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        children: [
          FeatureTile(
            title: 'AR Camera',
            icon: Icons.camera,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CameraAccessScreen()),
                ),
          ),
          FeatureTile(
            title: 'Routing',
            icon: Icons.map,
            enabled:
                role == UserRole.student ||
                role == UserRole.teacher ||
                role == UserRole.admin,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RoutingScreen()),
                ),
          ),
          FeatureTile(
            title: 'Schedule',
            icon: Icons.schedule,
            enabled:
                role == UserRole.student ||
                role == UserRole.teacher ||
                role == UserRole.admin,
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScheduleScreen()),
                ),
          ),
          FeatureTile(
            title: 'Place Temporary AR Comments',
            icon: Icons.comment,
            enabled: role == UserRole.student,
            onTap: () {}, // Student-only feature
          ),
          FeatureTile(
            title: 'Send Class Updates',
            icon: Icons.school,
            enabled: role == UserRole.teacher || role == UserRole.admin,
            onTap: () {}, // Teacher/Admin-only
          ),
          FeatureTile(
            title: 'Send Announcements',
            icon: Icons.announcement,
            enabled: role == UserRole.admin,
            onTap: () {}, // Admin-only
          ),
          FeatureTile(
            title: 'Manage AR Elements',
            icon: Icons.settings,
            enabled: role == UserRole.admin,
            onTap: () {}, // Admin-only
          ),
        ],
      ),
    );
  }
}
