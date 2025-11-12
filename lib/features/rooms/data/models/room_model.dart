import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Room extends Equatable {
  final String id;
  final String name;
  final List<String> members;
  final String ownerId;
  final DateTime createdAt;

  const Room({
    required this.id,
    required this.name,
    required this.members,
    required this.ownerId,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, members, ownerId, createdAt];

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'members': members,
      'ownerId': ownerId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Room.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Room(
      id: doc.id,
      name: data['name'] as String,
      members: List<String>.from(data['members'] as List<dynamic>),
      ownerId: data['ownerId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}
