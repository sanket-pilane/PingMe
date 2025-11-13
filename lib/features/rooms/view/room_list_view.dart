import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/rooms/bloc/room_bloc.dart';
import 'package:pingme/features/rooms/view/room_detail_screen.dart';

class RoomListView extends StatelessWidget {
  const RoomListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomBloc, RoomState>(
      builder: (context, state) {
        if (state.status == RoomStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.rooms.isEmpty) {
          return const Center(child: Text('No rooms yet. Create one!'));
        }

        return ListView.builder(
          itemCount: state.rooms.length,
          itemBuilder: (context, index) {
            final room = state.rooms[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(room.name),
                subtitle: Text(
                  'Created on: ${room.createdAt.toLocal().toString().split(' ')[0]}',
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => RoomDetailScreen(room: room),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
