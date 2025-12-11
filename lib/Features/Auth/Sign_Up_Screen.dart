import 'package:flutter/material.dart';
import 'package:nutri_track/services/api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _showSnack(String message, {bool error = true}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: error ? const Color(0xFF6ABF4B) : Colors.green));
  }

  Future<void> _validateAndSignUp() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();
    final conf = _confirmController.text.trim();

    if (email.isEmpty) {
      _showSnack('Email is required');
      return;
    }

    final iiitu = RegExp(r'^[a-zA-Z0-9._%+-]+@iiitu\.ac\.in$');
    if (!iiitu.hasMatch(email)) {
      _showSnack('Please enter a valid email ending with @iiitu.ac.in');
      return;
    }

    if (pass.isEmpty || pass.length < 8) {
      _showSnack('Password must be at least 8 characters');
      return;
    }

    if (conf.isEmpty) {
      _showSnack('Please confirm your password');
      return;
    }

    if (pass != conf) {
      _showSnack('Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ApiService.register(email: email, password: pass);
      await ApiService.login(email: email, password: pass);
      _showSnack('Account created', error: false);
      Navigator.pushReplacementNamed(context, '/details');
    } catch (e) {
      _showSnack(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, height: 0.9, fontFamily: 'Poppins'),
                children: [
                  TextSpan(text: 'Nutri', style: TextStyle(color: Color(0xFFE6A70B), fontSize: 48)),
                  TextSpan(text: 'Track', style: TextStyle(color: Colors.white, fontSize: 39)),
                ],
              ),
            ),
            const SizedBox(height: 36.0),
            Text('Create an Account', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 22, fontWeight: FontWeight.w700, fontFamily: 'Poppins')),
            const SizedBox(height: 8.0),
            Text('Please fill the details to continue', textAlign: TextAlign.center, style: TextStyle(color: Colors.white.withOpacity(0.7))),
            const SizedBox(height: 28.0),

            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'IIITU Email',
                hintText: 'yourid@iiitu.ac.in',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: const Icon(Icons.person_outline, color: Color(0xFF6ABF4B)),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16.0),

            TextField(
              controller: _passwordController,
              obscureText: !_passwordVisible,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Create New Password',
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6ABF4B)),
                suffixIcon: IconButton(icon: Icon(_passwordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70), onPressed: () => setState(() => _passwordVisible = !_passwordVisible)),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 16.0),

            TextField(
              controller: _confirmController,
              obscureText: !_confirmVisible,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6ABF4B)),
                suffixIcon: IconButton(icon: Icon(_confirmVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70), onPressed: () => setState(() => _confirmVisible = !_confirmVisible)),
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24.0),

            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6ABF4B), padding: const EdgeInsets.symmetric(vertical: 16.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
              onPressed: _isLoading ? null : _validateAndSignUp,
              child: _isLoading ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Text('Sign Up', style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white)),
            ),

            const SizedBox(height: 18.0),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Already have an account? ", style: TextStyle(color: Colors.white.withOpacity(0.7))),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Login', style: TextStyle(color: Color(0xFF6ABF4B), fontWeight: FontWeight.bold))),
            ]),
          ]),
        ),
      ),
    );
  }
}
