import 'package:agrifrontend/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeNotifier>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: isDarkMode,
              onChanged: (value) {
                Provider.of<ThemeNotifier>(context, listen: false).toggleTheme(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
