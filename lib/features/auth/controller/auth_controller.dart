import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';



class AuthController extends GetxController {
  static AuthController instance = Get.find();
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Updated GoogleSignIn for version 7.1.1 - uses singleton instance
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _isGoogleSignInInitialized = false;

  var isLoading = false.obs;
  var user = Rxn<User>();

  // Manual user state management (required in v7.1.1)
  var currentGoogleUser = Rxn<GoogleSignInAccount>();

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    _initializeGoogleSignIn();
  }

  // Initialize GoogleSignIn asynchronously (required in v7.1.1)
  Future<void> _initializeGoogleSignIn() async {
    try {
      await _googleSignIn.initialize();
      _isGoogleSignInInitialized = true;
      print('Google Sign-In initialized successfully');
    } catch (e) {
      print('Failed to initialize Google Sign-In: $e');
    }
  }

  // Ensure Google Sign-In is initialized before use
  Future<void> _ensureGoogleSignInInitialized() async {
    if (!_isGoogleSignInInitialized) {
      await _initializeGoogleSignIn();
    }
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Required Fields",
        "Please enter both email and password.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      Get.snackbar(
        "Login Success",
        "You have logged in successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed('/main');
    } on FirebaseAuthException catch (e) {
      String errorMsg = "Login failed. Please try again.";
      if (e.code == 'user-not-found') {
        errorMsg = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        errorMsg = "Incorrect password. Try again.";
      } else if (e.code == 'invalid-credential') {
        errorMsg = "Invalid credentials. Please check your email and password.";
      } else if (e.code == 'too-many-requests') {
        errorMsg = "Too many failed attempts. Please try again later.";
      }

      Get.snackbar(
        "Login Error",
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (_) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Register with email and password
  Future<void> register(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Required Fields",
        "Please enter all details.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      user.value = _auth.currentUser;

      Get.snackbar(
        "Account Created",
        "Your account has been created successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );

      Get.offAllNamed('/main');
    } on FirebaseAuthException catch (e) {
      String errorMsg = "Registration failed. Please try again.";

      if (e.code == 'email-already-in-use') {
        errorMsg = "This email is already in use.";
      } else if (e.code == 'weak-password') {
        errorMsg = "Password is too weak. Please choose a stronger password.";
      } else if (e.code == 'invalid-email') {
        errorMsg = "The email address is invalid.";
      }

      Get.snackbar(
        "Registration Error",
        errorMsg,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } catch (_) {
      Get.snackbar(
        "Error",
        "An unexpected error occurred. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Google Sign-In - Fixed implementation for version 7.1.1 with fallback
  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    try {
      // Ensure Google Sign-In is initialized
      await _ensureGoogleSignInInitialized();

      // Try lightweight authentication first (silent sign-in)
      GoogleSignInAccount? existingUser = await attemptSilentSignIn();
      if (existingUser != null) {
        await _processGoogleSignIn(existingUser);
        return;
      }

      // If lightweight auth fails, try the authenticate method with retry
      GoogleSignInAccount? googleUser;
      int attempts = 0;
      const maxAttempts = 2;

      while (attempts < maxAttempts) {
        try {
          // Check if platform supports authenticate method
          if (_googleSignIn.supportsAuthenticate()) {
            // Use authenticate() method - new in v7.1.1
            googleUser = await _googleSignIn.authenticate(
              scopeHint: ['email', 'profile'],
            );
            break; // Success, exit loop
          } else {
            // Fallback for platforms that don't support authenticate
            throw UnsupportedError('Platform does not support authenticate method');
          }
        } on GoogleSignInException catch (e) {
          attempts++;
          print('Google Sign-In attempt $attempts failed: ${e.code.name}');

          if (e.code.name == 'canceled' && attempts < maxAttempts) {
            // Wait a bit before retry
            await Future.delayed(const Duration(milliseconds: 500));
            continue;
          } else {
            rethrow; // Re-throw if not canceled or max attempts reached
          }
        }
      }

      if (googleUser != null) {
        await _processGoogleSignIn(googleUser);
      } else {
        throw Exception('Failed to authenticate with Google after $maxAttempts attempts');
      }
    } on GoogleSignInException catch (e) {
      print('Google Sign-In Exception: ${e.code.name} - ${e.description}');
      if (e.code.name != 'canceled') {
        String errorMessage = _getGoogleSignInErrorMessage(e);
        Get.snackbar(
          "Google Sign-In Failed",
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          "Sign-in Cancelled",
          "Google Sign-in was cancelled. Please try again.",
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print('Google Sign-In Error: $e');
      Get.snackbar(
        "Google Sign-In Failed",
        "An error occurred during Google Sign-In. Please try again.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Separate method to process Google Sign-In after successful authentication
  Future<void> _processGoogleSignIn(GoogleSignInAccount googleUser) async {
    // Update local state management
    currentGoogleUser.value = googleUser;

    // Get authentication tokens (now synchronous in v7.1.1)
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;

    // Create Firebase credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.idToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with the Google credential
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    final User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      // Save user data to Firestore
      final userDoc = FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid);
      final docSnapshot = await userDoc.get();

      if (!docSnapshot.exists) {
        await userDoc.set({
          'uid': firebaseUser.uid,
          'name': firebaseUser.displayName ?? '',
          'email': firebaseUser.email ?? '',
          'photoURL': firebaseUser.photoURL ?? '',
          'provider': 'google',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }

    Get.snackbar(
      "Login Success",
      "You have logged in with Google!",
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
    Get.offAllNamed('/main');
  }

  // Helper method to convert GoogleSignInException to user-friendly messages
  String _getGoogleSignInErrorMessage(GoogleSignInException exception) {
    switch (exception.code.name) {
      case 'canceled':
        return 'Sign-in was cancelled. Please try again if you want to continue.';
      case 'interrupted':
        return 'Sign-in was interrupted. Please try again.';
      case 'clientConfigurationError':
        return 'There is a configuration issue with Google Sign-In. Please contact support.';
      case 'providerConfigurationError':
        return 'Google Sign-In is currently unavailable. Please try again later.';
      case 'uiUnavailable':
        return 'Google Sign-In is currently unavailable. Please try again later.';
      case 'userMismatch':
        return 'There was an issue with your account. Please sign out and try again.';
      case 'unknownError':
      default:
        return 'An unexpected error occurred during Google Sign-In. Please try again.';
    }
  }

  // Attempt silent sign-in (replacement for signInSilently in v7.1.1)
  Future<GoogleSignInAccount?> attemptSilentSignIn() async {
    await _ensureGoogleSignInInitialized();
    try {
      final result = _googleSignIn.attemptLightweightAuthentication();

      // Handle both sync and async returns
      if (result is Future<GoogleSignInAccount?>) {
        final account = await result;
        currentGoogleUser.value = account;
        return account;
      } else {
        final account = result as GoogleSignInAccount?;
        currentGoogleUser.value = account;
        return account;
      }
    } catch (error) {
      print('Silent sign-in failed: $error');
      return null;
    }
  }

  /// Logout user
  Future<void> logout() async {
    isLoading.value = true;
    try {
      // Sign out from Firebase
      await _auth.signOut();

      // Sign out from Google
      await _googleSignIn.signOut();

      // Clear local state
      currentGoogleUser.value = null;

      Get.snackbar(
        "Logout Success",
        "You have been logged out successfully!",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar(
        "Logout Failed",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
}