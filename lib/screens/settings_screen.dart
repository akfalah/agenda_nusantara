import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() {
    return _SettingsScreenState();
  }
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _currentPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();

  @override
  void dispose() {
    _currentPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _savePassword() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPassword = prefs.getString('password') ?? 'user';

    if (_currentPasswordCtrl.text != savedPassword) {
      _showSnackbar('Password saat ini salah!', isError: true);

      return;
    }

    if (_newPasswordCtrl.text.trim().isEmpty) {
      _showSnackbar('Password baru tidak boleh kosong!', isError: true);

      return;
    }

    await prefs.setString('password', _newPasswordCtrl.text.trim());

    _currentPasswordCtrl.clear();
    _newPasswordCtrl.clear();

    if (mounted) {
      _showSnackbar('Password berhasil diperbarui!');
    }
  }

  void _showSnackbar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildChangePasswordSection(),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 24),
            _buildDeveloperCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildChangePasswordSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Perbarui Password',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Password Saat ini',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _currentPasswordCtrl,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Masukkan password anda',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Password Baru',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _newPasswordCtrl,
          obscureText: true,
          decoration: const InputDecoration(
            hintText: 'Masukkan password baru anda',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _savePassword,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Simpan Password',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeveloperCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'DEVELOPER',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            CircleAvatar(
              radius: 30,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/2241720184.jpg',
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  alignment: Alignment(0, -0.5), // geser ke atas
                  // Alignment(0, 0)  → center (default)
                  // Alignment(0, -1) → paling atas
                  // Alignment(0, 1)  → paling bawah
                ),
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ahmad Khoirul Falah',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                SizedBox(height: 2),
                Text(
                  'NIM: 2241720184',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                SizedBox(height: 2),
                Text(
                  'DEVELOPER APLIKASI',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
