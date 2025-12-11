import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:nutri_track/services/api_service.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({super.key});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  // Controllers for text fields
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _targetWeightController = TextEditingController();

  // State variables for dropdown and radio buttons
  String? _selectedLanguage;
  String? _selectedGender;
  String? _selectedDiet;
  String? _selectedActivityLevel;

  bool _isLoading = false;

  @override
  void dispose() {
    // Clean up controllers
    _nameController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  // Helper function to display a styled SnackBar.
  void _showErrorSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
        isError ? const Color(0xFF6ABF4B) : Colors.green,
      ),
    );
  }

  // Validates all form fields and calls API
  Future<void> _validateAndContinue() async {
    // Check text fields
    if (_nameController.text.trim().isEmpty) {
      _showErrorSnackBar('Name is required');
      return;
    }
    if (_weightController.text.trim().isEmpty) {
      _showErrorSnackBar('Weight is required');
      return;
    }
    if (_heightController.text.trim().isEmpty) {
      _showErrorSnackBar('Height is required');
      return;
    }
    if (_targetWeightController.text.trim().isEmpty) {
      _showErrorSnackBar('Target Weight is required');
      return;
    }

    // Check dropdowns and radio buttons
    if (_selectedLanguage == null) {
      _showErrorSnackBar('Please select a language');
      return;
    }
    if (_selectedGender == null) {
      _showErrorSnackBar('Please select a gender');
      return;
    }
    if (_selectedDiet == null) {
      _showErrorSnackBar('Please select a dietary preference');
      return;
    }
    if (_selectedActivityLevel == null) {
      _showErrorSnackBar('Please select an activity level');
      return;
    }

    final weight = double.tryParse(_weightController.text.trim());
    final height = double.tryParse(_heightController.text.trim());
    final targetWeight =
    double.tryParse(_targetWeightController.text.trim());

    if (weight == null || height == null || targetWeight == null) {
      _showErrorSnackBar(
          'Please enter valid numeric values for weight, height and target weight');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await ApiService.updateProfile(
        name: _nameController.text.trim(),
        weight: weight,
        height: height,
        targetWeight: targetWeight,
        gender: _selectedGender!,
        dietaryPreference: _selectedDiet!,
        activityLevel: _selectedActivityLevel!,
      );

      _showErrorSnackBar('Profile updated successfully', isError: false);

      // Go back to start screen (or change to HomeScreen later)
      Navigator.pushNamedAndRemoveUntil(context, '/profile', (route) => false);
    } catch (e) {
      _showErrorSnackBar(e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Title
              Text(
                'Tell Us More About You',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                'To give you a better experience',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 40.0),

              // Name TextField
              _buildTextField(
                label: 'Name',
                icon: Icons.person_outline,
                controller: _nameController,
              ),
              const SizedBox(height: 20.0),

              // Weight and Height TextFields in a Row
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Weight (kg)',
                      icon: Icons.fitness_center,
                      keyboardType: TextInputType.number,
                      controller: _weightController,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: _buildTextField(
                      label: 'Height (cm)',
                      icon: Icons.height,
                      keyboardType: TextInputType.number,
                      controller: _heightController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),

              // Target Weight TextField
              _buildTextField(
                label: 'Target Weight (kg)',
                icon: Icons.flag_outlined,
                keyboardType: TextInputType.number,
                controller: _targetWeightController,
              ),
              const SizedBox(height: 20.0),

              // Language Dropdown
              _buildDropdown(),
              const SizedBox(height: 20.0),

              // Gender Radio Buttons
              _buildSectionTitle('Gender'),
              _buildGenderRadios(),
              const SizedBox(height: 20.0),

              // Diet Radio Buttons
              _buildSectionTitle('Dietary Preference'),
              _buildDietRadios(),
              const SizedBox(height: 20.0),

              // Activity Level Section
              _buildSectionTitle('Activity Level'),
              const SizedBox(height: 10.0),
              _buildActivityLevelDropdown(),
              const SizedBox(height: 40.0),

              // Continue Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6ABF4B),
                  padding:
                  const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                onPressed: _isLoading ? null : _validateAndContinue,
                child: _isLoading
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
                  ),
                )
                    : const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget to build text fields consistently
  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: keyboardType == TextInputType.number
          ? <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ]
          : null,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        prefixIcon: Icon(icon, color: const Color(0xFF6ABF4B)),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Helper widget for section titles
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white.withOpacity(0.9),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // Helper widget to build the language dropdown
  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedLanguage,
      onChanged: (String? newValue) {
        setState(() {
          _selectedLanguage = newValue;
        });
      },
      hint: Text(
        'Select Language',
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
      isExpanded: true,
      dropdownColor: Colors.grey[850],
      icon: const Icon(Icons.arrow_drop_down,
          color: Color(0xFF6ABF4B)),
      style: const TextStyle(color: Colors.white),
      items: <String>['English', 'Spanish', 'Hindi', 'French']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.language,
            color: Color(0xFF6ABF4B)),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Helper widget for Activity Level Dropdown
  Widget _buildActivityLevelDropdown() {
    final Map<String, String> activityLevels = {
      'Sedentary': 'Little or no exercise',
      'Lightly Active': 'Light Exercise/Sports 1-3 days/week',
      'Moderately Active': 'Moderate Exercise 3-5 days/week',
      'Very Active': 'Hard exercise 6-7 days/week',
      'Extra Active':
      'Very hard exercise, physical job, athlete',
    };

    return DropdownButtonFormField<String>(
      value: _selectedActivityLevel,
      onChanged: (String? newValue) {
        setState(() {
          _selectedActivityLevel = newValue;
        });
      },
      hint: Text(
        'Select Activity Level',
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
      isExpanded: true,
      dropdownColor: Colors.grey[850],
      icon: const Icon(Icons.arrow_drop_down,
          color: Color(0xFF6ABF4B)),
      selectedItemBuilder: (BuildContext context) {
        return activityLevels.keys.map<Widget>((String item) {
          return Text(
            item,
            overflow: TextOverflow.ellipsis,
          );
        }).toList();
      },
      items: activityLevels.entries
          .map<DropdownMenuItem<String>>((entry) {
        return DropdownMenuItem<String>(
          value: entry.key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                entry.key,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                entry.value,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        );
      }).toList(),
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.directions_run,
            color: Color(0xFF6ABF4B)),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Helper widget for gender radio buttons
  Widget _buildGenderRadios() {
    return Row(
      children: [
        Expanded(
          child: RadioListTile<String>(
            title: const Text(
              'Male',
              style: TextStyle(color: Colors.white),
            ),
            value: 'male',
            groupValue: _selectedGender,
            onChanged: (String? value) {
              setState(() {
                _selectedGender = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
        ),
        Expanded(
          child: RadioListTile<String>(
            title: const Text(
              'Female',
              style: TextStyle(color: Colors.white),
            ),
            value: 'female',
            groupValue: _selectedGender,
            onChanged: (String? value) {
              setState(() {
                _selectedGender = value;
              });
            },
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    );
  }

  // Helper widget for diet radio buttons
  Widget _buildDietRadios() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text(
            'Vegetarian',
            style: TextStyle(color: Colors.white),
          ),
          value: 'vegetarian',
          groupValue: _selectedDiet,
          onChanged: (String? value) {
            setState(() {
              _selectedDiet = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          title: const Text(
            'Non-Vegetarian',
            style: TextStyle(color: Colors.white),
          ),
          value: 'non-vegetarian',
          groupValue: _selectedDiet,
          onChanged: (String? value) {
            setState(() {
              _selectedDiet = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
        RadioListTile<String>(
          title: const Text(
            'Eggetarian',
            style: TextStyle(color: Colors.white),
          ),
          value: 'eggetarian',
          groupValue: _selectedDiet,
          onChanged: (String? value) {
            setState(() {
              _selectedDiet = value;
            });
          },
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }
}
