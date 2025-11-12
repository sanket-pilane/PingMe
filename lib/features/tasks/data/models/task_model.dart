import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final String id;
  final String title;
  final String assignedTo;
  final DateTime createdAt;
  final bool isComplete;

  const Task({
    required this.id,
    required this.title,
    required this.assignedTo,
    required this.createdAt,
    this.isComplete = false,
  });

  @override
  List<Object?> get props => [id, title, assignedTo, createdAt, isComplete];

  Task copyWith({bool? isComplete}) {
    return Task(
      id: id,
      title: title,
      assignedTo: assignedTo,
      createdAt: createdAt,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'assignedTo': assignedTo,
      'createdAt': Timestamp.fromDate(createdAt),
      'isComplete': isComplete,
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
    );
  }
}
