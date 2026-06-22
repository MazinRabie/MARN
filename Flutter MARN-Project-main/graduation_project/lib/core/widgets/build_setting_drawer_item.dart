import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BuildSettingDrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const BuildSettingDrawerItem({
    super.key,
    required this.icon,
    required this.title,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        context.push(route);
      },
    );
  }
}
