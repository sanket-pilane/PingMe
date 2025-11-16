import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String username;
  final String fullName; // --- ADDED ---
  final String bio; // --- ADDED ---

  const UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.fullName, // --- ADDED ---
    required this.bio, // --- ADDED ---
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      fullName: data['fullName'] ?? '', // --- ADDED ---
      bio: data['bio'] ?? '', // --- ADDED ---
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'username_lowercase': username.toLowerCase(),
      'fullName': fullName, // --- ADDED ---
      'bio': bio, // --- ADDED ---
    };
  }

  static const empty = UserModel(
    uid: '',
    email: '',
    username: '',
    fullName: '', // --- ADDED ---
    bio: '', // --- ADDED ---
  );

  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  UserModel copyWith({
    String? uid,
    String? email,
    String? username,
    String? fullName, // --- ADDED ---
    String? bio, // --- ADDED ---
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      fullName: fullName ?? this.fullName, // --- ADDED ---
      bio: bio ?? this.bio, // --- ADDED ---
    );
  }

  @override
  List<Object> get props => [uid, email, username, fullName, bio]; // --- UPDATED ---
}
