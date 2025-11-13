part of 'task_bloc.dart';

@immutable
abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object> get props => [];
}

// NEW EVENT: Added this event
class GetTasks extends TaskEvent {
  const GetTasks();
}

class TasksUpdated extends TaskEvent {
  const TasksUpdated(this.tasks);
  final List<Task> tasks;

  @override
  List<Object> get props => [tasks];
}

class AddTask extends TaskEvent {
  const AddTask(this.title);
  final String title;

  @override
  List<Object> get props => [title];
}

class ToggleTaskCompletion extends TaskEvent {
  const ToggleTaskCompletion(this.task);
  final Task task;

  @override
  List<Object> get props => [task];
}

class DeleteTask extends TaskEvent {
  const DeleteTask(this.taskId);
  final String taskId;

  @override
  List<Object> get props => [taskId];
}

class SendNudge extends TaskEvent {
  const SendNudge(this.task);
  final Task task;

  @override
  List<Object> get props => [task];
}
