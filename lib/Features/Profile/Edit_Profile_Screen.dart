import 'package:flutter/material.dart';
import 'package:nutri_track/core/components/app_input_field.dart';
import 'package:nutri_track/core/components/app_button.dart';
import 'package:nutri_track/services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _name = TextEditingController();
  final _weight = TextEditingController();
  final _height = TextEditingController();
  final _target = TextEditingController();
  String? gender;
  String? diet;
  String? activity;
  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final user = await ApiService.getCurrentUser();
      _name.text = user['name'] ?? '';
      _weight.text = (user['weight'] ?? '').toString();
      _height.text = (user['height'] ?? '').toString();
      _target.text = (user['targetWeight'] ?? '').toString();
      gender = user['gender'] ?? 'male';
      diet = user['dietaryPreference'] ?? 'vegetarian';
      activity = user['activityLevel'] ?? 'Moderately Active';
    } catch (e) {
      // fallback sample values
      _name.text = 'Tarsem';
      _weight.text = '72.5';
      _height.text = '175';
      _target.text = '68';
      gender = 'male';
      diet = 'vegetarian';
      activity = 'Moderately Active';
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> _save() async {
    final w = double.tryParse(_weight.text.trim());
    final h = double.tryParse(_height.text.trim());
    final t = double.tryParse(_target.text.trim());
    if (_name.text.trim().isEmpty || w == null || h == null || t == null || gender == null || diet == null || activity == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }
    setState(() => saving = true);
    try {
      await ApiService.updateProfile(
        name: _name.text.trim(),
        weight: w,
        height: h,
        targetWeight: t,
        gender: gender!,
        dietaryPreference: diet!,
        activityLevel: activity!,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved'), backgroundColor: Colors.green));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _weight.dispose();
    _height.dispose();
    _target.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          AppInputField(controller: _name, label: 'Name'),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: AppInputField(controller: _weight, label: 'Weight (kg)', keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: AppInputField(controller: _height, label: 'Height (cm)', keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 12),
          AppInputField(controller: _target, label: 'Target (kg)', keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(value: gender, decoration: const InputDecoration(labelText: 'Gender'), items: ['male', 'female'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => gender = v)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(value: diet, decoration: const InputDecoration(labelText: 'Dietary Preference'), items: ['vegetarian', 'non-vegetarian', 'eggetarian'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => diet = v)),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(value: activity, decoration: const InputDecoration(labelText: 'Activity Level'), items: ['Sedentary','Lightly Active','Moderately Active','Very Active','Extra Active'].map((e)=>DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v)=>setState(()=>activity=v)),
          const SizedBox(height: 18),
          AppButton(label: 'Save Changes', onTap: _save, loading: saving),
        ]),
      ),
    );
  }
}
