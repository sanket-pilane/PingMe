import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RoomModel extends Equatable {
  final String id;
  final String name;
  final List<Map<String, dynamic>> members;
  final List<String> memberUIDs; // <-- ADDED THIS
  final String ownerId;
  final DateTime createdAt;
  final String inviteCode;

  const RoomModel({
    required this.id,
    required this.name,
    required this.members,
    required this.memberUIDs, // <-- ADDED THIS
    required this.ownerId,
    required this.createdAt,
    required this.inviteCode,
  });

  static final empty = RoomModel(
    id: '',
    name: '',
    members: const [],
    memberUIDs: const [], // <-- ADDED THIS
    ownerId: '',
    createdAt: DateTime(0),
    inviteCode: '',
  );

  factory RoomModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RoomModel(
      id: doc.id,
      name: data['name'] ?? '',
      members: List<Map<String, dynamic>>.from(data['members'] ?? []),
      memberUIDs: List<String>.from(data['memberUIDs'] ?? []), // <-- ADDED THIS
      ownerId: data['ownerId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      inviteCode: data['inviteCode'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'members': members,
      'memberUIDs': memberUIDs, // <-- ADDED THIS
      'ownerId': ownerId,
      'createdAt': createdAt,
      'inviteCode': inviteCode,
    };
  }

  @override
  List<Object?> get props => [
    id,
    name,
    members,
    memberUIDs, // <-- ADDED THIS
    ownerId,
    createdAt,
    inviteCode,
  ];

  RoomModel copyWith({
    String? id,
    String? name,
    List<Map<String, dynamic>>? members,
    List<String>? memberUIDs, // <-- ADDED THIS
    String? ownerId,
    DateTime? createdAt,
    String? inviteCode,
  }) {
    return RoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      memberUIDs: memberUIDs ?? this.memberUIDs, // <-- ADDED THIS
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      inviteCode: inviteCode ?? this.inviteCode,
    );
  }
}
