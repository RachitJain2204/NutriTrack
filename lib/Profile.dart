import 'package:flutter/material.dart';
import 'package:nutri_track/services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Future<Map<String, dynamic>> _userFuture;

  final Color _nutriGreen = const Color(0xFF6ABF4B);

  @override
  void initState() {
    super.initState();
    _userFuture = ApiService.getCurrentUser();
  }

  void _refresh() {
    setState(() {
      _userFuture = ApiService.getCurrentUser();
    });
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : _nutriGreen,
      ),
    );
  }

  Future<void> _logout() async {
    await ApiService.clearToken();
    _showSnackBar('Logged out', isError: false);
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.9),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(color: Colors.white.withOpacity(0.8)),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: _nutriGreen,
        elevation: 0,
        title: const Text('Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor:
                AlwaysStoppedAnimation<Color>(Color(0xFF6ABF4B)),
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 44, color: Colors.redAccent),
                    const SizedBox(height: 12),
                    Text('Failed to load profile', style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16)),
                    const SizedBox(height: 8),
                    Text(snapshot.error.toString(), style: TextStyle(color: Colors.white.withOpacity(0.7)), textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    ElevatedButton(onPressed: _refresh, style: ElevatedButton.styleFrom(backgroundColor: _nutriGreen), child: const Text('Retry'))
                  ],
                ),
              ),
            );
          }

          final user = snapshot.data ?? {};
          final name = (user['name'] ?? user['username'] ?? 'User').toString();
          final email = (user['email'] ?? '').toString();
          final weight = user['weight']?.toString() ?? '-';
          final height = user['height']?.toString() ?? '-';
          final target = user['targetWeight']?.toString() ?? '-';
          final gender = (user['gender'] ?? '-').toString();
          final diet = (user['dietaryPreference'] ?? '-').toString();
          final activity = (user['activityLevel'] ?? '-').toString();
          final age = user['age']?.toString() ?? '-';
          final timesWeek = user['TimesWeek']?.toString() ?? '-';

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // header card
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,', style: TextStyle(color: Colors.white.withOpacity(0.8))),
                      const SizedBox(height: 8),
                      Text(name, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      if (email.isNotEmpty) Text(email, style: TextStyle(color: Colors.white.withOpacity(0.7))),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () => Navigator.pushReplacementNamed(context, '/details'),
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text('Edit profile'),
                            style: ElevatedButton.styleFrom(backgroundColor: _nutriGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          ),
                          OutlinedButton.icon(
                            onPressed: _logout,
                            icon: const Icon(Icons.logout),
                            label: const Text('Logout'),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.white12),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Body stats card
                _sectionTitle('Body stats'),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white12)),
                  child: Column(
                    children: [
                      _infoTile('Age', '$age'),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 10),
                      _infoTile('Weight', '$weight kg'),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 10),
                      _infoTile('Height', '$height cm'),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 10),
                      _infoTile('Target weight', '$target kg'),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Preferences card
                _sectionTitle('Preferences'),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.grey.withOpacity(0.06), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white12)),
                  child: Column(
                    children: [
                      _infoTile('Gender', gender),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 10),
                      _infoTile('Diet', diet),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 10),
                      _infoTile('Activity', activity),
                      const SizedBox(height: 10),
                      const Divider(color: Colors.white12),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                const SizedBox(height: 26),
                const SizedBox(height: 30),

                // footer
                Center(
                  child: Text('NutriTrack • v1.0', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
