import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pingme/features/tasks/bloc/task_bloc.dart';

void showCreateTaskDialog(
  BuildContext context,
  List<Map<String, dynamic>> members,
) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      final titleController = TextEditingController();
      String? selectedUid = members.isNotEmpty ? members.first['uid'] : null;
      final selectedUser = members.isNotEmpty
          ? members.first
          : <String, dynamic>{};

      return BlocProvider.value(
        value: BlocProvider.of<TaskBloc>(context),
        child: StatefulBuilder(
          builder: (stfContext, stfSetState) {
            return AlertDialog(
              title: const Text('New Task'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Task Title'),
                  ),
                  const SizedBox(height: 20),
                  if (members.isNotEmpty)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Assign to'),
                      value: selectedUid,
                      onChanged: (newValue) {
                        stfSetState(() {
                          selectedUid = newValue;
                        });
                      },
                      items: members.map<DropdownMenuItem<String>>((
                        Map<String, dynamic> member,
                      ) {
                        return DropdownMenuItem<String>(
                          value: member['uid'],
                          child: Text(member['username']),
                        );
                      }).toList(),
                    )
                  else
                    const Text('No other members to assign to.'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        selectedUid != null) {
                      final selectedMember = members.firstWhere(
                        (m) => m['uid'] == selectedUid,
                        orElse: () => {'uid': '', 'username': 'Unknown'},
                      );

                      context.read<TaskBloc>().add(
                        AddTask(
                          title: titleController.text,
                          assignedToUid: selectedMember['uid'],
                          assignedToName: selectedMember['username'],
                        ),
                      );
                      Navigator.of(dialogContext).pop();
                    }
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}
