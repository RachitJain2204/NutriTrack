import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const ListTile(leading: Icon(Icons.info_outline), title: Text('About'), subtitle: Text('NutriTrack v1.0')),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.policy),
          title: const Text('Privacy Policy'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.help_outline),
          title: const Text('Help & Support'),
          onTap: () {},
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Logout'),
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
          },
        ),
      ]),
    );
  }
}
