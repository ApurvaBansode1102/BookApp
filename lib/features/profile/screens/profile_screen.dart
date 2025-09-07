import 'dart:io';
import 'package:bookapp/features/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/controller/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String? _profileImage;
  late AnimationController _controller;
  late Animation<double> _sizeAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _iconScaleAnim;
  User? get user => FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadProfileImagePath();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _sizeAnim = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    _fadeAnim = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _iconScaleAnim = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _profileImage = picked.path;
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image_path', picked.path);
    }
  }

  void _removeProfileImage() async {
    setState(() {
      _profileImage = null;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('profile_image_path');
  }

  void _logout() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Log Out',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w400),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'No',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Yes',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w300),
            ),
          ),
        ],
      ),
    );
    if (result == true) {
      AuthController.instance.logout();
    }
  }

  Future<void> _loadProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profileImage = prefs.getString('profile_image_path');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.padding(context, mobile: 20, tablet: 40),
              vertical: Responsive.padding(context, mobile: 40, tablet: 80),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture with Icons
                Center(
                  child: SizedBox(
                    width: 130,
                    height: 130,
                    child: Stack(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut,
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                            image: _profileImage != null
                                ? DecorationImage(
                                    image: FileImage(File(_profileImage!)),
                                    fit: BoxFit.cover,
                                  )
                                : (user?.photoURL != null
                                      ? DecorationImage(
                                          image: NetworkImage(user!.photoURL!),
                                          fit: BoxFit.cover,
                                        )
                                      : const DecorationImage(
                                          image: AssetImage(
                                            'assets/Avatar.png',
                                          ),
                                          fit: BoxFit.cover,
                                        )),
                          ),
                        ),
                        // Edit icon (bottom right)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: ClipOval(
                            child: Material(
                              color: Colors.blue.shade50,
                              child: InkWell(
                                onTap: _pickImage,
                                child: const SizedBox(
                                  width: 34,
                                  height: 34,
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        // Delete icon (bottom left)
                        if (_profileImage != null)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: ClipOval(
                              child: Material(
                                color: Colors.red.shade50,
                                child: InkWell(
                                  onTap: _removeProfileImage,
                                  child: const SizedBox(
                                    width: 34,
                                    height: 34,
                                    child: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // User Info
                FadeTransition(
                  opacity: _fadeAnim,
                  child: SizeTransition(
                    sizeFactor: _sizeAnim,
                    axis: Axis.vertical,
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                            user?.displayName ?? "Username",
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Center(
                          child: Text(
                            user?.email ?? "user@email.com",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // const SizedBox(height: 24),

                // // Optional "Edit Profile" Button
                // ElevatedButton.icon(
                //   onPressed: _pickImage,
                //   icon: const Icon(Icons.edit),
                //   label: const Text("Edit Profile"),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.blue.shade100,
                //     foregroundColor: Colors.blue.shade900,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                //   ),
                // ),
                const SizedBox(height: 150),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _logout,
                    icon: const Icon(Icons.logout),
                    label: Text(
                      'Logout',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3366FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
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
