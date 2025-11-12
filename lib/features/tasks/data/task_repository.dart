import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pingme/features/tasks/data/models/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TaskRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _auth = auth ?? FirebaseAuth.instance;

  Stream<List<Task>> getTasksStream(String roomId) {
    return _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) => Task.fromFirestore(doc)).toList();
        });
  }

  Future<void> createTask(String roomId, String title) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not logged in');

    final newTask = Task(
      id: '',
      title: title,
      assignedTo: userId,
      createdAt: DateTime.now(),
    );

    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .add(newTask.toFirestore());
  }

  Future<void> updateTask(String roomId, Task task) async {
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

  // NEW: Method to set the needsNudge flag
  Future<void> sendNudge(String roomId, Task task) async {
    final updatedTask = task.copyWith(needsNudge: true);
    await updateTask(roomId, updatedTask);
  }
}
