import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_parking_system/components/common/toast.dart';
import 'package:smart_parking_system/components/settings/settings.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  File? _profileImage; // Holds the selected profile image
  String? _profileImageUrl; // Holds the profile image URL from Firestore

  bool _isUploading = false; // Track the upload state

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh profile info if coming back to this page
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
          if (userData != null) {
            _nameController.text = userData['username'] ?? '';
            _emailController.text = userData['email'] ?? '';
            _phoneController.text = userData['phoneNumber'] ?? '';
            _profileImageUrl = userData['profileImageUrl']; // Get the profile image URL
            setState(() {}); // Refresh UI
          }
        }
      }
    } catch (e) {
      showToast(message: 'Error loading profile: $e');
    }
  }

  Future<void> _updateUserProfile() async {
    setState(() {
      _isUploading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String? profileImageUrl = _profileImageUrl;
        if (_profileImage != null) {
          profileImageUrl = await _uploadProfileImage(user.uid);
        }

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'username': _nameController.text,
          'email': _emailController.text,
          'phoneNumber': _phoneController.text,
          'profileImageUrl': profileImageUrl, // Save the profile image URL
        }, SetOptions(merge: true));

        showToast(message: 'Profile Updated Successfully!');
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const SettingsPage(),
            ),
          );
        }
      }
    } catch (e) {
      showToast(message: 'Error: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<String?> _uploadProfileImage(String userId) async {
    try {
      final FirebaseStorage storage = FirebaseStorage.instanceFor(bucket: "gs://parkme-c2508.appspot.com");
      final Reference storageRef = storage.ref().child('profileImages/$userId.jpg');
      UploadTask uploadTask = storageRef.putFile(_profileImage!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      showToast(message: 'Error uploading image: $e');
      return null;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2F3E),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          backgroundColor: const Color(0xFF2D2F3E),
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Text(
                        'User Profile',
                        style: TextStyle(
                          color: Color(0xFF58C6A9),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Center(
              child: SizedBox(
                width: 500,
                  child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 140,
                              height: 140,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF3A3D5F),
                              ),
                            ),
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.grey[300],
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : _profileImageUrl != null
                                      ? NetworkImage(_profileImageUrl!) as ImageProvider
                                      : null,
                              onBackgroundImageError: _profileImage == null && _profileImageUrl == null
                                  ? null
                                  : (error, stackTrace) {
                                      showToast(message: 'Error loading image: $error');
                                    },
                              child: _profileImage == null && _profileImageUrl == null
                                  ? const Icon(Icons.person, size: 80, color: Colors.grey)
                                  : null,
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: InkWell(
                                onTap: _pickImage,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      ProfileField(
                        label: 'Username',
                        controller: _nameController,
                      ),
                      ProfileField(
                        label: 'Email address',
                        controller: _emailController,
                      ),
                      ProfileField(
                        label: 'Phone number',
                        controller: _phoneController,
                      ),
                      const SizedBox(height: 40),
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF58C6A9), Color(0xFF4CAF93)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(28),
                        ),
                        child: ElevatedButton(
                          onPressed: _updateUserProfile,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: const Text(
                            'Save',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isUploading) 
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}

class ProfileField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;

  const ProfileField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
