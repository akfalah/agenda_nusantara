import 'package:agenda_nusantara/database/database_helper.dart';
import 'package:agenda_nusantara/models/task.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() {
    return _TaskListScreenState();
  }
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    final tasks = await DatabaseHelper.getAll();

    setState(() {
      _tasks = tasks;
    });
  }

  Future<void> _toggleDone(Task task) async {
    final newStatus = task.isDone == 0 ? 1 : 0;

    await DatabaseHelper.toggleDone(task.id!, newStatus);
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Tugas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_tasks.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Belum ada tugas.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemBuilder: (_, index) {
        return _buildTaskTile(_tasks[index]);
      },
      separatorBuilder: (_, __) {
        return const Divider(height: 1);
      },
      itemCount: _tasks.length,
    );
  }

  Widget _buildTaskTile(Task task) {
    final isimportant = task.category == 'important';
    final isDone = task.isDone == 1;
    final arrowColor = isimportant ? Colors.red : Colors.green;

    final formattedDate = DateFormat(
      'dd MMM yyyy',
    ).format(DateTime.parse(task.dueDate));

    return ListTile(
      leading: Checkbox(
        value: isDone,
        activeColor: isimportant ? Colors.red : Colors.green,
        onChanged: (_) {
          _toggleDone(task);
        },
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: isDone ? TextDecoration.lineThrough : null,
          color: isDone ? Colors.grey : null,
        ),
      ),
      subtitle: Text(
        '$formattedDate | Tugas ${isimportant ? 'Penting' : 'Biasa'}',
        style: const TextStyle(fontSize: 14, color: Colors.grey),
      ),
      trailing: Icon(Icons.arrow_right, color: arrowColor, size: 32),
    );
  }
}
