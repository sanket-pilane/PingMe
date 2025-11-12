import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String username;

  const UserModel({
    required this.uid,
    required this.email,
    required this.username,
  });

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      uid: doc.id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'username_lowercase': username.toLowerCase(),
    };
  }

  static const empty = UserModel(uid: '', email: '', username: '');
  bool get isEmpty => this == UserModel.empty;
  bool get isNotEmpty => this != UserModel.empty;

  // --- THIS IS THE FIX ---
  UserModel copyWith({String? uid, String? email, String? username}) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }
  // --- END OF FIX ---

  @override
  List<Object> get props => [uid, email, username];
}
