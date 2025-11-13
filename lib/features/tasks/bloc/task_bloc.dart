import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:pingme/features/auth/data/models/user_model.dart';
import 'package:pingme/features/tasks/data/models/task_model.dart';
import 'package:pingme/features/tasks/data/task_repository.dart';

part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository _taskRepository;
  final String _roomId;
  final UserModel _user;
  StreamSubscription? _tasksSubscription;

  TaskBloc({
    required TaskRepository taskRepository,
    required String roomId,
    required UserModel user,
  }) : _taskRepository = taskRepository,
       _roomId = roomId,
       _user = user,
       super(const TaskState()) {
    on<GetTasks>(_onGetTasks); // ADDED this handler
    on<TasksUpdated>(_onTasksUpdated);
    on<AddTask>(_onAddTask);
    on<ToggleTaskCompletion>(_onToggleTaskCompletion);
    on<DeleteTask>(_onDeleteTask);
    on<SendNudge>(_onSendNudge);
  }

  // NEW HANDLER for GetTasks
  void _onGetTasks(GetTasks event, Emitter<TaskState> emit) {
    emit(state.copyWith(status: TaskStatus.loading));
    _tasksSubscription?.cancel();

    _tasksSubscription = _taskRepository.getTasksStream(_roomId).listen((
      tasks,
    ) {
      add(TasksUpdated(tasks));
    });
  }

  void _onTasksUpdated(TasksUpdated event, Emitter<TaskState> emit) {
    emit(state.copyWith(status: TaskStatus.success, tasks: event.tasks));
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await _taskRepository.createTask(_roomId, event.title, _user);
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onToggleTaskCompletion(
    ToggleTaskCompletion event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final updatedTask = event.task.copyWith(
        isComplete: !event.task.isComplete,
      );
      await _taskRepository.updateTask(_roomId, updatedTask);
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await _taskRepository.deleteTask(_roomId, event.taskId);
    } catch (e) {
      emit(
        state.copyWith(status: TaskStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onSendNudge(SendNudge event, Emitter<TaskState> emit) async {
    try {
      await _taskRepository.sendNudge(_roomId, event.task);
    } catch (e) {
      emit(
        state.copyWith(
          status: TaskStatus.failure,
          errorMessage: 'Failed to send nudge: $e',
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }
}
