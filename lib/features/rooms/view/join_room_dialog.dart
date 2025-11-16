import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/auth/data/models/user_model.dart';
import 'package:pingme/features/rooms/data/room_repository.dart';

void showJoinRoomDialog(BuildContext context, UserModel user) {
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Join Room'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Enter Invite Code',
            border: OutlineInputBorder(),
          ),
          autofocus: true,
          maxLength: 6,
          textCapitalization: TextCapitalization.characters,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final inviteCode = controller.text.trim().toUpperCase();
              if (inviteCode.isNotEmpty) {
                try {
                  await context.read<RoomRepository>().joinRoom(
                    inviteCode,
                    user,
                  );
                  Navigator.of(dialogContext).pop();
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Join'),
          ),
        ],
      );
    },
  );
}
