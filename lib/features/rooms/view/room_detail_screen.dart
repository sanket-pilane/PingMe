import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/rooms/data/models/room_model.dart';
import 'package:pingme/features/rooms/view/invite_info_dialog.dart';
import 'package:pingme/features/tasks/bloc/task_bloc.dart';
import 'package:pingme/features/tasks/data/task_repository.dart';
import 'package:pingme/features/tasks/view/task_list_view.dart';

class RoomDetailScreen extends StatelessWidget {
  const RoomDetailScreen({super.key, required this.room});

  final RoomModel room;

  static Route<void> route({required RoomModel room}) {
    return MaterialPageRoute(builder: (_) => RoomDetailScreen(room: room));
  }

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    return BlocProvider(
      create: (context) => TaskBloc(
        taskRepository: context.read<TaskRepository>(),
        roomId: room.id,
        user: user,
      )..add(const GetTasks()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(room.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add_alt_1_outlined),
              tooltip: 'Invite Member',
              onPressed: () {
                showInviteInfoDialog(context, room.inviteCode);
              },
            ),
          ],
        ),
        body: const TaskListView(),
      ),
    );
  }
}
