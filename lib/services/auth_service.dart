import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get user => _auth.currentUser;

  Future<User?> signIn(String email, String password) async {
    try {
      final credentials = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credentials.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found for that email.');
        case 'wrong-password':
          throw Exception('Incorrect password.');
        case 'invalid-email':
          throw Exception('Invalid email format.');
        default:
          throw Exception('Sign-in failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error during sign-in: $e');
    }
  }

  Future<User?> register(
      {required String email,
      required String password,
      required String displayName}) async {
    try {
      final credentials = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credentials.user?.updateDisplayName(displayName);
      await credentials.user?.reload();

      return credentials.user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('Email is already registered.');
        case 'weak-password':
          throw Exception('Password is too weak.');
        case 'invalid-email':
          throw Exception('Invalid email format.');
        default:
          throw Exception('Registration failed: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error during registration: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Sign-out failed: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      debugPrint('Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      debugPrint('Password reset error: ${e.code} - ${e.message}');
      throw Exception('Password reset error');
    } catch (e) {
      debugPrint('Unknown password reset error: $e');
      throw 'Failed to send password reset email. Please try again.';
    }
  }
}
