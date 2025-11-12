import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/rooms/bloc/room_bloc.dart';
import 'package:pingme/features/rooms/data/room_repository.dart';
import 'package:pingme/features/rooms/view/create_room_dialog.dart';
import 'package:pingme/features/rooms/view/room_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomBloc(roomRepository: RoomRepository()),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final userEmail = context.select((AuthBloc bloc) => bloc.state.user?.email);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Rooms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Welcome, $userEmail',
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          const Expanded(child: RoomListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showCreateRoomDialog(context),
        label: const Text('New Room'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
