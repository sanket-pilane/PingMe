import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:pingme/features/tasks/bloc/task_bloc.dart';
import 'package:pingme/features/tasks/data/models/task_model.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state.status == TaskStatus.loading ||
            state.status == TaskStatus.initial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == TaskStatus.failure) {
          return Center(
            child: Text('Failed to load tasks: ${state.errorMessage}'),
          );
        }

        if (state.tasks.isEmpty) {
          return const Center(child: Text('No tasks yet. Add one!'));
        }

        return ListView.builder(
          itemCount: state.tasks.length,
          itemBuilder: (context, index) {
            final task = state.tasks[index];
            return TaskListItem(task: task);
          },
        );
      },
    );
  }
}

class TaskListItem extends StatelessWidget {
  const TaskListItem({super.key, required this.task});

  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<TaskBloc>();

    return Slidable(
      key: Key(task.id),
      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              bloc.add(ToggleTaskCompletion(task));
            },
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            icon: task.isComplete ? Icons.remove_done : Icons.done,
            label: task.isComplete ? 'Undo' : 'Complete',
          ),
        ],
      ),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (_) {
              bloc.add(SendNudge(task));
            },
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.notification_add,
            label: 'Nudge',
          ),
          SlidableAction(
            onPressed: (_) {
              bloc.add(DeleteTask(task.id));
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
          ),
        ),
        subtitle: Text('Assigned to: ${task.assignedToName}'),
        trailing: task.needsNudge
            ? const Icon(Icons.notifications_active, color: Colors.blue)
            : null,
      ),
    );
  }
}
