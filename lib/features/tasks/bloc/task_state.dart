part of 'task_bloc.dart';

enum TaskFilter { all, myTasks }

enum TaskStatus { initial, loading, success, failure }

@immutable
class TaskState extends Equatable {
  const TaskState({
    this.status = TaskStatus.initial,
    this.tasks = const [],
    this.filteredTasks = const [],
    this.filter = TaskFilter.all,
    this.errorMessage,
  });

  final TaskStatus status;
  final List<TaskModel> tasks;
  final List<TaskModel> filteredTasks;
  final TaskFilter filter;
  final String? errorMessage;

  TaskState copyWith({
    TaskStatus? status,
    List<TaskModel>? tasks,
    List<TaskModel>? filteredTasks,
    TaskFilter? filter,
    String? errorMessage,
  }) {
    return TaskState(
      status: status ?? this.status,
      tasks: tasks ?? this.tasks,
      filteredTasks: filteredTasks ?? this.filteredTasks,
      filter: filter ?? this.filter,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    tasks,
    filteredTasks,
    filter,
    errorMessage,
  ];
}
