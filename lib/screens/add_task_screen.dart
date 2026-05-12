import 'package:flutter/material.dart';

import 'package:intl/intl.dart';

import 'package:agenda_nusantara/database/database_helper.dart';

import 'package:agenda_nusantara/models/task.dart';

class AddTaskScreen extends StatefulWidget {
  final String category;

  const AddTaskScreen({super.key, required this.category});

  @override
  State<AddTaskScreen> createState() {
    return _AddTaskScreenState();
  }
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleCtrl = TextEditingController();
  final _descriptionCtrl = TextEditingController();
  DateTime _selectedDueDate = DateTime.now();

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descriptionCtrl.dispose();
    super.dispose();
  }

  bool get _isImportant {
    return widget.category == 'important';
  }

  Color get _accentColor {
    if (_isImportant) {
      return Colors.red;
    }

    return Colors.green;
  }

  String get _screenTitle {
    if (_isImportant) {
      return 'Tambah Tugas Penting';
    }

    return 'Tambah Tugas Biasa';
  }

  Future<void> _pickDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  Future<void> _saveTask() async {
    if (_titleCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Judul tugas tidak boleh kosong!')),
      );

      return;
    }

    try {
      final task = Task(
        title: _titleCtrl.text.trim(),
        description: _descriptionCtrl.text.trim(),
        dueDate: DateFormat('yyyy-MM-dd').format(_selectedDueDate),
        category: widget.category,
        createdAt: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      );

      await DatabaseHelper.insert(task);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tugas berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Gagal menyimpan: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _screenTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryBadge(),
            const SizedBox(height: 20),
            _buildDueDatePicker(),
            const SizedBox(height: 20),
            _buildTitleField(),
            const SizedBox(height: 20),
            _buildDescriptionField(),
            const SizedBox(height: 30),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _accentColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _accentColor.withValues(alpha: 0.4)),
      ),
      child: Text(
        _isImportant ? 'Penting' : 'Biasa',
        style: TextStyle(
          color: _accentColor,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildDueDatePicker() {
    final formattedDate = DateFormat('dd MMM yyyy').format(_selectedDueDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tanggal Jatuh Tempo',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _pickDueDate,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 8),
                Text(formattedDate),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Judul Tugas',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _titleCtrl,
          decoration: InputDecoration(
            hintText: _isImportant
                ? 'Contoh: Submit Laporan'
                : 'Contoh: Membeli Buah',
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Deskripsi Tugas',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _descriptionCtrl,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Jelaskan tugas ...',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveTask,
        style: ElevatedButton.styleFrom(
          backgroundColor: _accentColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Simpan',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
