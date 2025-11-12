import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String assignedToId;
  final String assignedToName;
  final DateTime createdAt;
  final bool isComplete;
  final bool needsNudge;

  const Task({
    required this.id,
    required this.title,
    required this.assignedToId,
    required this.assignedToName,
    required this.createdAt,
    this.isComplete = false,
    this.needsNudge = false,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    assignedToId,
    assignedToName,
    createdAt,
    isComplete,
    needsNudge,
  ];

  Task copyWith({bool? isComplete, bool? needsNudge}) {
    return Task(
      id: id,
      title: title,
      assignedToId: assignedToId,
      assignedToName: assignedToName,
      createdAt: createdAt,
      isComplete: isComplete ?? this.isComplete,
      needsNudge: needsNudge ?? this.needsNudge,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'assignedToId': assignedToId,
      'assignedToName': assignedToName,
      'createdAt': Timestamp.fromDate(createdAt),
      'isComplete': isComplete,
      'needsNudge': needsNudge,
    };
  }

  factory Task.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Task(
      id: doc.id,
      title: data['title'] as String,
      assignedToId:
          data['assignedToId'] as String? ??
          data['assignedTo'] as String? ??
          '',
      assignedToName: data['assignedToName'] as String? ?? '...',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isComplete: data['isComplete'] as bool? ?? false,
      needsNudge: data['needsNudge'] as bool? ?? false,
    );
  }
}
