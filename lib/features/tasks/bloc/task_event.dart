part of 'task_bloc.dart';

@immutable
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class GetTasks extends TaskEvent {
  const GetTasks();
}

class TasksUpdated extends TaskEvent {
  const TasksUpdated(this.tasks);
  final List<TaskModel> tasks;

  @override
  List<Object?> get props => [tasks];
}

class AddTask extends TaskEvent {
  const AddTask({
    required this.title,
    required this.assignedToUid,
    required this.assignedToName,
  });
  final String title;
  final String assignedToUid;
  final String assignedToName;

  @override
  List<Object?> get props => [title, assignedToUid, assignedToName];
}

class ToggleTaskCompletion extends TaskEvent {
  const ToggleTaskCompletion(this.task);
  final TaskModel task;

  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  const DeleteTask(this.taskId);
  final String taskId;

  @override
  List<Object?> get props => [taskId];
}

class SendNudge extends TaskEvent {
  const SendNudge(this.task);
  final TaskModel task;

  @override
  List<Object?> get props => [task];
}

class ChangeTaskFilter extends TaskEvent {
  const ChangeTaskFilter(this.filter);
  final TaskFilter filter;

  @override
  List<Object?> get props => [filter];
}
