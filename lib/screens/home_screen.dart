import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:agenda_nusantara/database/database_helper.dart';

import 'package:agenda_nusantara/screens/add_task_screen.dart';
import 'package:agenda_nusantara/screens/settings_screen.dart';
import 'package:agenda_nusantara/screens/task_list_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  int _doneCount = 0;
  int _pendingCount = 0;
  String _loggedInUser = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final done = await DatabaseHelper.countDone();
    final pending = await DatabaseHelper.countPending();

    setState(() {
      _loggedInUser = prefs.getString('loggedInUser') ?? 'User';
      _doneCount = done;
      _pendingCount = pending;
    });
  }

  Future<void> _navigateTo(Widget screen) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) {
          return screen;
        },
      ),
    );
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat(
      'EEEE, d MMMM yyyy',
      'id_ID',
    ).format(DateTime.now());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Agenda Nusantara',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreeting(today),
            const SizedBox(height: 20),
            _buildStatsRow(),
            const SizedBox(height: 24),
            _buildNavigationGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildGreeting(String today) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halo, $_loggedInUser!',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(today, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        _StatCard(
          label: 'Tugas Selesai',
          value: _doneCount,
          color: Colors.green,
        ),
        const SizedBox(width: 12),
        _StatCard(
          label: 'Belum Selesai',
          value: _pendingCount,
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildNavigationGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _NavButton(
          icon: Icons.priority_high,
          label: 'Tambah Tugas Penting',
          color: Colors.red,
          onTap: () {
            _navigateTo(const AddTaskScreen(category: 'important'));
          },
        ),
        _NavButton(
          icon: Icons.add,
          label: 'Tambah Tugas Biasa',
          color: Colors.green,
          onTap: () {
            _navigateTo(const AddTaskScreen(category: 'regular'));
          },
        ),
        _NavButton(
          icon: Icons.list,
          label: 'Daftar Tugas',
          color: Colors.blue,
          onTap: () {
            _navigateTo(const TaskListScreen());
          },
        ),
        _NavButton(
          icon: Icons.settings,
          label: 'Pengaturan',
          color: Colors.grey,
          onTap: () {
            _navigateTo(const SettingsScreen());
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 4),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.15),
              radius: 28,
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }
}
