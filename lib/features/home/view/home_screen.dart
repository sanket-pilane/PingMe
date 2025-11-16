import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/auth/bloc/auth_bloc.dart';
import 'package:pingme/features/auth/view/login.dart';
import 'package:pingme/features/profile/view/settings_screen.dart';
import 'package:pingme/features/rooms/bloc/room_bloc.dart';
import 'package:pingme/features/rooms/data/room_repository.dart';
import 'package:pingme/features/rooms/view/create_room_dialog.dart';
import 'package:pingme/features/rooms/view/join_room_dialog.dart';
import 'package:pingme/features/rooms/view/room_list_view.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.select((AuthBloc bloc) => bloc.state.user);

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // 🔥 This is the missing logic that fixes logout navigation
        if (state.status == AuthStatus.unauthenticated) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const LoginScreen()),
            (route) => false,
          );
        }
      },
      child: BlocProvider(
        create: (context) => RoomBloc(
          authBloc: context.read<AuthBloc>(),
          roomRepository: context.read<RoomRepository>(),
        )..add(const GetRooms()),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Your Rooms'),
            actions: [
              IconButton(
                icon: const Icon(Icons.group_add_outlined),
                tooltip: 'Join Room',
                onPressed: () => showJoinRoomDialog(context, user),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Settings',
                onPressed: () =>
                    Navigator.of(context).push(SettingsScreen.route()),
              ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                },
              ),
            ],
          ),
          body: const RoomListView(),
          floatingActionButton: Builder(
            builder: (context) {
              return FloatingActionButton(
                child: const Icon(Icons.add),
                onPressed: () {
                  showCreateRoomDialog(context, context.read<RoomBloc>());
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
