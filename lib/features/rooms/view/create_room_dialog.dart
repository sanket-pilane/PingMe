import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/rooms/bloc/room_bloc.dart';

Future<void> showCreateRoomDialog(BuildContext context, RoomBloc read) {
  final controller = TextEditingController();
  final roomBloc = context.read<RoomBloc>();

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Create New Room'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Room Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                roomBloc.add(AddRoom(controller.text));
                Navigator.of(context).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      );
    },
  );
}
