import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String assignedTo;
  final DateTime createdAt;
  final bool isComplete;
  final bool needsNudge; // <-- NEW: Flag for urgent reminder

  const Task({
    required this.id,
    required this.title,
    required this.assignedTo,
    required this.createdAt,
    this.isComplete = false,
    this.needsNudge = false, // <-- NEW: Default is false
  });

  @override
  List<Object?> get props => [
    id,
    title,
    assignedTo,
    createdAt,
    isComplete,
    needsNudge,
  ];

  Task copyWith({
    bool? isComplete,
    bool? needsNudge, // <-- NEW
  }) {
    return Task(
      id: id,
      title: title,
      assignedTo: assignedTo,
      createdAt: createdAt,
      isComplete: isComplete ?? this.isComplete,
      needsNudge: needsNudge ?? this.needsNudge, // <-- NEW
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'assignedTo': assignedTo,
      'createdAt': Timestamp.fromDate(createdAt),
      'isComplete': isComplete,
      'needsNudge': needsNudge, // <-- NEW
    };
  }

  factory Task.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Task(
      id: doc.id,
      title: data['title'] as String,
      assignedTo: data['assignedTo'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      isComplete: data['isComplete'] as bool,
      // Handle the case where the field might not exist in old documents
      needsNudge: data['needsNudge'] as bool? ?? false, // <-- NEW
    );
  }
}
