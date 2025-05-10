import 'package:flutter/material.dart';

class FeatureTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool enabled;
  final VoidCallback? onTap;

  const FeatureTile({
    super.key,
    required this.title,
    required this.icon,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.4,
        child: Card(
          child: ListTile(
            leading: Icon(icon),
            title: Text(title),
          ),
        ),
      ),
    );
  }
}
