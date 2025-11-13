import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/rooms/data/models/room_model.dart';
import 'package:pingme/features/rooms/view/invite_info_dialog.dart';
import 'package:pingme/features/tasks/bloc/task_bloc.dart';
import 'package:pingme/features/tasks/data/task_repository.dart';
import 'package:pingme/features/tasks/view/create_task_dialog.dart';
import 'package:pingme/features/tasks/view/task_list_view.dart';

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key, required this.room});

  final RoomModel room;

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthBloc>().state.user;

    return BlocProvider(
      create: (context) => TaskBloc(
        taskRepository: context.read<TaskRepository>(),
        roomId: room.id,
        user: user,
      )..add(const GetTasks()),
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: Text(room.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person_add),
                  onPressed: () {
                    showInviteInfoDialog(context, room.inviteCode);
                  },
                ),
              ],
            ),
            body: const TaskListView(),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showCreateTaskDialog(context, room.members);
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
