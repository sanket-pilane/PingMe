import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pingme/features/auth/data/models/user_model.dart';
import 'package:pingme/features/tasks/data/models/task_model.dart';
import 'package:rxdart/rxdart.dart';

class TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  Stream<List<TaskModel>> getTasksStream(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .snapshots()
        .map((snapshot) {
          final tasks = snapshot.docs
              .map((doc) => TaskModel.fromFirestore(doc))
              .toList();
          tasks.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          return tasks;
        })
        .onErrorReturnWith((error, stackTrace) {
          print(error);
          return [];
        });
  }

  Future<void> createTask(
    String roomId,
    String title,
    UserModel createdBy,
    String assignedToUid,
    String assignedToName,
  ) async {
    final newTask = TaskModel.empty.copyWith(
      title: title,
      createdAt: DateTime.now(),
      createdById: createdBy.uid,
      createdByName: createdBy.username,
      assignedToUid: assignedToUid,
      assignedToName: assignedToName,
    );

    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .add(newTask.toFirestore());
  }

  Future<void> updateTask(String roomId, TaskModel task) async {
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toFirestore());
  }

  Future<void> deleteTask(String roomId, String taskId) async {
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }

  Future<void> sendNudge(String roomId, TaskModel task) async {
    final updatedTask = task.copyWith(needsNudge: true);
    await updateTask(roomId, updatedTask);
  }
}
