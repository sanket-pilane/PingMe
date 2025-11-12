import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/rooms/bloc/room_bloc.dart';

Future<void> showCreateRoomDialog(BuildContext context) {
  final controller = TextEditingController();
  return showDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) {
      return AlertDialog(
        title: const Text('Create a New Room'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Room Name'),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
          ),
          ElevatedButton(
            child: const Text('Create'),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                context.read<RoomBloc>().add(CreateRoom(controller.text));
                Navigator.of(dialogContext).pop();
              }
            },
          ),
        ],
      );
    },
  );
}
