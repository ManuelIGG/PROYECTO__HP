import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_4_geodesica/model/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Register with email and password
  Future<UserCredential> registerWithEmailAndPassword(
      UserModel user, String password) async {
    try {
      // Create the user in Firebase Auth
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      // Add user details to Firestore
      await _firestore.collection('users').doc(result.user!.uid).set({
        'fullName': user.fullName,
        'email': user.email,
        'birthDate': user.birthDate,
        'document': user.document,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    return await _auth.signOut();
  }

  // Get user details from Firestore
  Future<UserModel?> getUserDetails(String uid) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UserModel(
          id: int.tryParse(uid) ?? 0,
          fullName: data['fullName'] ?? '',
          email: data['email'] ?? '',
          password: '', // We don't store or retrieve passwords
          birthDate: data['birthDate'],
          document: data['document'],
          createdAt: data['createdAt']?.toString(),
        );
      }
      return null;
    } catch (e) {
      print('Error getting user details: $e');
      return null;
    }
  }

  // Add a user to local database
  Future<void> syncUserToLocalDb(UserModel user) async {
    // This would connect to your existing database helper
    // to add the user to the local SQLite database if needed
    // For now this is a placeholder - implement as needed
  }
}
