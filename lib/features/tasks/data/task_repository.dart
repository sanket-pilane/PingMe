import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pingme/features/tasks/data/models/task_model.dart';

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
          final tasks = snapshot.docs.map((doc) {
            return TaskModel.fromFirestore(doc);
          }).toList();
          tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return tasks;
        });
  }

  Future<void> createTask(String roomId, TaskModel task) async {
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .add(task.toFirestore());
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
    await _firestore
        .collection('rooms')
        .doc(roomId)
        .collection('tasks')
        .doc(task.id)
        .update({'needsNudge': true});
  }
}
