import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/rooms/data/models/room_model.dart';
import 'package:pingme/features/tasks/bloc/task_bloc.dart';
import 'package:pingme/features/tasks/data/task_repository.dart';
import 'package:pingme/features/tasks/view/create_task_dialog.dart';
import 'package:pingme/features/tasks/view/task_list_view.dart';

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key, required this.room});

  final Room room;

  static Route<void> route({required Room room}) {
    return MaterialPageRoute(builder: (_) => RoomDetailScreen(room: room));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;

    return BlocProvider(
      create: (context) => TaskBloc(
        taskRepository: TaskRepository(),
        roomId: room.id,
        user: user,
      ),
      child: RoomDetailView(roomName: room.name),
    );
  }
}

class RoomDetailView extends StatelessWidget {
  const RoomDetailView({super.key, required this.roomName});
  final String roomName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(roomName)),
      body: const TaskListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateTaskDialog(context),
        child: const Icon(Icons.add_task),
      ),
    );
  }
}
