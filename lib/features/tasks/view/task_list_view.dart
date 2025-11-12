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

            // Determine if the task is overdue or has been nudged recently
            final bool isUrgent =
                task.needsNudge ||
                (DateTime.now().difference(task.createdAt).inDays > 3 &&
                    !task.isComplete);

            return Slidable(
              key: Key(task.id),
              // Swipe Right: Mark Complete/Undo
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
              // Swipe Left: Delete / Nudge
              endActionPane: ActionPane(
                motion: const StretchMotion(),
                children: [
                  // Nudge Action (Available only if not completed)
                  if (!task.isComplete)
                    SlidableAction(
                      onPressed: (context) {
                        context.read<TaskBloc>().add(SendNudge(task));
                      },
                      backgroundColor: task.needsNudge
                          ? Colors
                                .orange
                                .shade700 // Nudged/Pending
                          : Colors.amber, // Ready to nudge
                      foregroundColor: Colors.white,
                      icon: task.needsNudge
                          ? Icons.notifications_active
                          : Icons.notifications,
                      label: task.needsNudge ? 'Pending' : 'Nudge',
                    ),
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
                    color: isUrgent
                        ? Colors
                              .red
                              .shade700 // Red text for urgent items
                        : task.isComplete
                        ? Colors.grey
                        : null,
                    fontWeight: isUrgent ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  'Added by: ${task.assignedTo.substring(0, 6)}...',
                ),
                trailing: task.needsNudge
                    ? const Icon(Icons.flash_on, color: Colors.amber)
                    : null,
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
