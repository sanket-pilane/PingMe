import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:pingme/features/auth/data/models/user_model.dart';
import 'package:rxdart/rxdart.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().switchMap((firebaseUser) {
      if (firebaseUser == null) {
        return Stream.value(UserModel.empty);
      } else {
        return _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .snapshots()
            .asyncMap((snapshot) async {
              if (snapshot.exists) {
                return UserModel.fromFirestore(snapshot);
              } else {
                // --- UPDATED New User Creation ---
                final newUser = UserModel(
                  uid: firebaseUser.uid,
                  email: firebaseUser.email ?? '',
                  username: '',
                  fullName: '', // Add default empty value
                  bio: '', // Add default empty value
                );
                // --- END OF UPDATE ---

                await _firestore
                    .collection('users')
                    .doc(newUser.uid)
                    .set(newUser.toFirestore());
                return newUser;
              }
            });
      }
    });
  }

  Future<void> signUp({required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (_) {
      rethrow;
    }
  }

  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  // --- UPDATED Method Signature and Body ---
  Future<void> updateUserProfile({
    required String uid,
    required String username,
    String? fullName, // Made optional to support profile setup
    String? bio, // Made optional to support profile setup
  }) async {
    await _firestore.collection('users').doc(uid).update({
      'username': username,
      'username_lowercase': username.toLowerCase(),
      'fullName': fullName ?? '',
      'bio': bio ?? '',
    });
  }

  // --- END OF UPDATE ---
}
