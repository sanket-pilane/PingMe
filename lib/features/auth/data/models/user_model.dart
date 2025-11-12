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

  @override
  List<Object> get props => [uid, email, username];

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return UserModel(
      uid: doc.id,
      email: data['email'] as String,
      username: data['username'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'email': email, 'username': username};
  }

  UserModel copyWith({String? username}) {
    return UserModel(
      uid: uid,
      email: email,
      username: username ?? this.username,
    );
  }

  static const empty = UserModel(uid: '', email: '', username: '');
}
