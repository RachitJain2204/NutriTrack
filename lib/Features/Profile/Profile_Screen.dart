import 'package:flutter/material.dart';
import 'package:nutri_track/Core/Utils/App_Assets.dart';
import 'package:nutri_track/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? user;
  bool loading = true;

  // fallback hard-coded values for UI preview
  final Map<String, dynamic> fallback = {
    'name': 'Tarsem',
    'email': 'tarsem@nutriTrack.com',
    'weight': 72.5,
    'height': 175,
    'targetWeight': 68,
    'gender': 'male',
    'dietaryPreference': 'vegetarian',
    'activityLevel': 'Moderately Active',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final d = await ApiService.getCurrentUser();
      setState(() {
        user = d;
      });
    } catch (e) {
      // fallback to hard-coded values
      setState(() {
        user = fallback;
      });
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = user ?? fallback;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Row(children: [
            ClipRRect(borderRadius: BorderRadius.circular(14), child: Image.asset(AppAssets.logo, width: 92, height: 92)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(u['name'] ?? '-', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(u['email'] ?? '-', style: TextStyle(color: Colors.white70)),
                const SizedBox(height: 8),
                Text('${u['weight'] ?? '-'} kg • ${u['height'] ?? '-'} cm • Target ${u['targetWeight'] ?? '-'} kg', style: TextStyle(color: Colors.white70)),
              ]),
            ),
          ]),
          const SizedBox(height: 18),
          ListTile(leading: const Icon(Icons.edit), title: const Text('Edit Profile'), onTap: () => Navigator.pushNamed(context, '/edit_profile')),
          ListTile(leading: const Icon(Icons.settings), title: const Text('Settings'), onTap: () => Navigator.pushNamed(context, '/settings')),
          const SizedBox(height: 12),
          ElevatedButton.icon(onPressed: () async {
            await ApiService.clearToken();
            Navigator.pushNamedAndRemoveUntil(context, '/login', (r) => false);
          }, icon: const Icon(Icons.logout), label: const Text('Logout'), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6ABF4B))),
        ]),
      ),
    );
  }
}
