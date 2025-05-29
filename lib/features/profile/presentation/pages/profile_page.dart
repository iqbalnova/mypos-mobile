import 'package:flutter/material.dart';
import 'package:myposapp/features/core/injection.dart';
import 'package:myposapp/features/core/router/app_routes.dart';

import '../../../core/helper/secure_storage_helper.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final SecureStorageHelper _secureStorageHelper =
      locator<SecureStorageHelper>();
  UserCredential? _userCredential;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    final userCredential = await _secureStorageHelper.getUserCredential();
    if (mounted) {
      setState(() {
        _userCredential = userCredential;
      });
    }
  }

  Future<void> _clearUserData() async {
    await _secureStorageHelper.deleteToken();
  }

  Future<void> _signOut() async {
    await _clearUserData();

    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.account_circle,
                  size: 80,
                  color: Colors.blueGrey,
                ),
                const SizedBox(height: 16),
                Text(
                  _userCredential?.name ?? '',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _userCredential?.email ?? '',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _signOut,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
