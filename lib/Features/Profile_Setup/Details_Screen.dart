import 'package:flutter/material.dart';
import 'package:nutri_track/services/api_service.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _targetWeightController = TextEditingController();

  String? _selectedLanguage;
  String? _selectedGender;
  String? _selectedDiet;
  String? _selectedActivityLevel;

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: const Color(0xFF6ABF4B)));
  }

  Future<void> _validateAndContinue() async {
    if (_nameController.text.trim().isEmpty) { _showErrorSnackBar('Name is required'); return; }
    if (_weightController.text.trim().isEmpty) { _showErrorSnackBar('Weight is required'); return; }
    if (_heightController.text.trim().isEmpty) { _showErrorSnackBar('Height is required'); return; }
    if (_targetWeightController.text.trim().isEmpty) { _showErrorSnackBar('Target Weight is required'); return; }
    if (_selectedLanguage == null) { _showErrorSnackBar('Please select a language'); return; }
    if (_selectedGender == null) { _showErrorSnackBar('Please select a gender'); return; }
    if (_selectedDiet == null) { _showErrorSnackBar('Please select a dietary preference'); return; }
    if (_selectedActivityLevel == null) { _showErrorSnackBar('Please select an activity level'); return; }

    final w = double.tryParse(_weightController.text.trim());
    final h = double.tryParse(_heightController.text.trim());
    final t = double.tryParse(_targetWeightController.text.trim());

    if (w == null || h == null || t == null) { _showErrorSnackBar('Please enter valid numeric values'); return; }

    setState(() => _isLoading = true);
    try {
      await ApiService.updateProfile(
        name: _nameController.text.trim(),
        weight: w,
        height: h,
        targetWeight: t,
        gender: _selectedGender!,
        dietaryPreference: _selectedDiet!,
        activityLevel: _selectedActivityLevel!,
      );
      Navigator.pushNamedAndRemoveUntil(context, '/main', (route) => false);
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: const Color(0xFF6ABF4B)),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tell Us More About You'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
            _buildTextField(label: 'Name', icon: Icons.person_outline, controller: _nameController),
            const SizedBox(height: 16),
            Row(children: [
              Expanded(child: _buildTextField(label: 'Weight (kg)', icon: Icons.fitness_center, controller: _weightController, keyboardType: TextInputType.number)),
              const SizedBox(width: 12),
              Expanded(child: _buildTextField(label: 'Height (cm)', icon: Icons.height, controller: _heightController, keyboardType: TextInputType.number)),
            ]),
            const SizedBox(height: 16),
            _buildTextField(label: 'Target Weight (kg)', icon: Icons.flag_outlined, controller: _targetWeightController, keyboardType: TextInputType.number),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedLanguage,
              onChanged: (String? newValue) { setState(() => _selectedLanguage = newValue); },
              hint: Text('Select Language', style: TextStyle(color: Colors.white.withOpacity(0.7))),
              isExpanded: true,
              dropdownColor: Colors.grey[850],
              icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF6ABF4B)),
              style: const TextStyle(color: Colors.white),
              items: <String>['English', 'Spanish', 'Hindi', 'French'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.language, color: Color(0xFF6ABF4B)),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 12),
            const Text('Gender', style: TextStyle(color: Colors.white70)),
            _buildGenderRadios(),
            const SizedBox(height: 8),
            const Text('Dietary Preference', style: TextStyle(color: Colors.white70)),
            _buildDietRadios(),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedActivityLevel,
              onChanged: (String? newValue) { setState(() => _selectedActivityLevel = newValue); },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.directions_run, color: Color(0xFF6ABF4B)),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
              ),
              hint: Text('Select Activity Level', style: TextStyle(color: Colors.white.withOpacity(0.7))),
              items: <String>['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active', 'Extra Active'].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
            ),
            const SizedBox(height: 18),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6ABF4B), padding: const EdgeInsets.symmetric(vertical: 16.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
              onPressed: _isLoading ? null : _validateAndContinue,
              child: _isLoading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Continue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildGenderRadios() {
    return Row(children: [
      Expanded(child: RadioListTile<String>(title: const Text('Male', style: TextStyle(color: Colors.white)), value: 'male', groupValue: _selectedGender, onChanged: (String? value) { setState(() => _selectedGender = value); }, contentPadding: EdgeInsets.zero)),
      Expanded(child: RadioListTile<String>(title: const Text('Female', style: TextStyle(color: Colors.white)), value: 'female', groupValue: _selectedGender, onChanged: (String? value) { setState(() => _selectedGender = value); }, contentPadding: EdgeInsets.zero)),
    ]);
  }

  Widget _buildDietRadios() {
    return Column(children: [
      RadioListTile<String>(title: const Text('Vegetarian', style: TextStyle(color: Colors.white)), value: 'vegetarian', groupValue: _selectedDiet, onChanged: (String? value) { setState(() => _selectedDiet = value); }, contentPadding: EdgeInsets.zero),
      RadioListTile<String>(title: const Text('Non-Vegetarian', style: TextStyle(color: Colors.white)), value: 'non-vegetarian', groupValue: _selectedDiet, onChanged: (String? value) { setState(() => _selectedDiet = value); }, contentPadding: EdgeInsets.zero),
      RadioListTile<String>(title: const Text('Eggetarian', style: TextStyle(color: Colors.white)), value: 'eggetarian', groupValue: _selectedDiet, onChanged: (String? value) { setState(() => _selectedDiet = value); }, contentPadding: EdgeInsets.zero),
    ]);
  }
}
