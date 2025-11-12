part of 'task_bloc.dart';

enum TaskStatus { initial, loading, success, failure }

@immutable
class TaskState extends Equatable {
  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.errorMessage,
  });

  final TaskStatus status;
  final List<Task> tasks;
  final String? errorMessage;

  TaskState copyWith({
    TaskStatus? status,
    List<Task>? tasks,
    String? errorMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, tasks, errorMessage];
}
