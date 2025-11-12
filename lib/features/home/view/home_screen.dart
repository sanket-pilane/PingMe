import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/profile/view/settings_screen.dart';
import 'package:pingme/features/rooms/bloc/room_bloc.dart';
import 'package:pingme/features/rooms/data/room_repository.dart';
import 'package:pingme/features/rooms/view/create_room_dialog.dart';
import 'package:pingme/features/rooms/view/room_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RoomBloc(
        roomRepository: RoomRepository(),
        authBloc: context.read<AuthBloc>(),
      ),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Rooms'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.of(context).push(SettingsScreen.route());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(const AuthLogoutRequested());
            },
          ),
        ],
      ),
      body: const RoomListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showCreateRoomDialog(context),
        child: const Icon(Icons.add_home_work),
      ),
    );
  }
}
