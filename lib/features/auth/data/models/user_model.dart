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

  static const UserModel empty = UserModel(uid: '', email: '', username: '');

  bool get isEmpty => this == empty;
  bool get isNotEmpty => this != empty;

  UserModel copyWith({String? uid, String? email, String? username}) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
    );
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      email: map['email'] ?? '',
      username: map['username'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'email': email, 'username': username};
  }

  @override
  List<Object?> get props => [uid, email, username];
}
