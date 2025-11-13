import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class RoomModel extends Equatable {
  final String id;
  final String name;
  final List<Map<String, dynamic>> members;
  final String ownerId;
  final DateTime createdAt;
  final String inviteCode;

  const RoomModel({
    required this.id,
    required this.name,
    required this.members,
    required this.ownerId,
    required this.createdAt,
    required this.inviteCode,
  });

  static final empty = RoomModel(
    id: '',
    name: '',
    members: const [],
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
      ownerId: data['ownerId'] ?? '',
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      inviteCode: data['inviteCode'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'members': members,
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
    ownerId,
    createdAt,
    inviteCode,
  ];

  RoomModel copyWith({
    String? id,
    String? name,
    List<Map<String, dynamic>>? members,
    String? ownerId,
    DateTime? createdAt,
    String? inviteCode,
  }) {
    return RoomModel(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      ownerId: ownerId ?? this.ownerId,
      createdAt: createdAt ?? this.createdAt,
      inviteCode: inviteCode ?? this.inviteCode,
    );
  }
}
