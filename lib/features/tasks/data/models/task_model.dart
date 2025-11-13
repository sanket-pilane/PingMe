import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class TaskModel extends Equatable {
  final String id;
  final String title;
  final bool isComplete;
  final bool needsNudge;
  final DateTime createdAt;
  final String createdById;
  final String createdByName;
  final String assignedToUid;
  final String assignedToName;

  const TaskModel({
    required this.id,
    required this.title,
    required this.isComplete,
    required this.needsNudge,
    required this.createdAt,
    required this.createdById,
    required this.createdByName,
    required this.assignedToUid,
    required this.assignedToName,
  });

  static final empty = TaskModel(
    id: '',
    title: '',
    isComplete: false,
    needsNudge: false,
    createdAt: DateTime(0),
    createdById: '',
    createdByName: '',
    assignedToUid: '',
    assignedToName: '',
  );

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      isComplete: data['isComplete'] ?? false,
      needsNudge: data['needsNudge'] ?? false,
      createdAt: (data['createdAt'] as Timestamp? ?? Timestamp.now()).toDate(),
      createdById: data['createdById'] ?? '',
      createdByName: data['createdByName'] ?? '',
      assignedToUid: data['assignedToUid'] ?? '',
      assignedToName: data['assignedToName'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'isComplete': isComplete,
      'needsNudge': needsNudge,
      'createdAt': createdAt,
      'createdById': createdById,
      'createdByName': createdByName,
      'assignedToUid': assignedToUid,
      'assignedToName': assignedToName,
    };
  }

  @override
  List<Object?> get props => [
    id,
    title,
    isComplete,
    needsNudge,
    createdAt,
    createdById,
    createdByName,
    assignedToUid,
    assignedToName,
  ];

  TaskModel copyWith({
    String? id,
    String? title,
    bool? isComplete,
    bool? needsNudge,
    DateTime? createdAt,
    String? createdById,
    String? createdByName,
    String? assignedToUid,
    String? assignedToName,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      isComplete: isComplete ?? this.isComplete,
      needsNudge: needsNudge ?? this.needsNudge,
      createdAt: createdAt ?? this.createdAt,
      createdById: createdById ?? this.createdById,
      createdByName: createdByName ?? this.createdByName,
      assignedToUid: assignedToUid ?? this.assignedToUid,
      assignedToName: assignedToName ?? this.assignedToName,
    );
  }
}
