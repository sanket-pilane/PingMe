import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pingme/features/auth/data/models/user_model.dart';
import 'package:pingme/features/tasks/data/models/task_model.dart';

class TaskRepository {
  final FirebaseFirestore _firestore;

  TaskRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

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

  Future<void> createTask(String roomId, String title, UserModel user) async {
    final newTask = Task(
      id: '',
      title: title,
      assignedToId: user.uid,
      assignedToName: user.username,
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

  Future<void> sendNudge(String roomId, Task task) async {
    final updatedTask = task.copyWith(needsNudge: true);
    await updateTask(roomId, updatedTask);
  }
}
