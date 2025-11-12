import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pingme/features/tasks/bloc/task_bloc.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state.status == TaskStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.tasks.isEmpty) {
          return const Center(child: Text('No tasks yet. Create one!'));
        }

        return ListView.builder(
          itemCount: state.tasks.length,
          itemBuilder: (context, index) {
            final task = state.tasks[index];
            return Slidable(
              key: Key(task.id),
              startActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      context.read<TaskBloc>().add(ToggleTaskCompletion(task));
                    },
                    backgroundColor: task.isComplete
                        ? Colors.grey
                        : Colors.green,
                    foregroundColor: Colors.white,
                    icon: task.isComplete ? Icons.undo : Icons.check,
                    label: task.isComplete ? 'Undo' : 'Complete',
                  ),
                ],
              ),
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  SlidableAction(
                    onPressed: (context) {
                      context.read<TaskBloc>().add(DeleteTask(task.id));
                    },
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: ListTile(
                title: Text(
                  task.title,
                  style: TextStyle(
                    decoration: task.isComplete
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    color: task.isComplete ? Colors.grey : null,
                  ),
                ),
                subtitle: Text(
                  'Added by: ${task.assignedTo.substring(0, 6)}...',
                ),
                leading: Checkbox(
                  value: task.isComplete,
                  onChanged: (bool? value) {
                    context.read<TaskBloc>().add(ToggleTaskCompletion(task));
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
