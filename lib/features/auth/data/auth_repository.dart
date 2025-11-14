import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:pingme/features/auth/data/models/user_model.dart';

class AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  }) : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<UserModel> get user {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) {
        return UserModel.empty;
      }

      final userDoc = await _firestore
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        final newUser = UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          username: '',
        );
        await _firestore
            .collection('users')
            .doc(firebaseUser.uid)
            .set(newUser.toMap());
        return newUser;
      }

      return UserModel.fromMap(userDoc.data()!, userDoc.id);
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

  Future<void> updateUserProfile({
    required String uid,
    required String username,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).update({
        'username': username,
      });
    } catch (_) {
      rethrow;
    }
  }
}
