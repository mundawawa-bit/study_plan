import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  final AppController _controller = AppController();

  void _showTaskForm({Map<String, dynamic>? task}) {
    final titleController = TextEditingController(text: task != null ? task['title'] : '');
    final notesController = TextEditingController(text: task != null ? task['notes'] : '');
    String selectedCourse = task != null ? task['course'] : (_controller.courses.isNotEmpty ? _controller.courses.first.courseName : 'Umum');
    DateTime selectedDate = task != null ? task['dueDate'] : DateTime.now().add(const Duration(days: 1));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      backgroundColor: Colors.white,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, top: 20, left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task == null ? 'Tambah Tugas Baru' : 'Edit Tugas',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A)),
                    ),
                    const SizedBox(height: 15),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Judul Tugas',
                        filled: true,
                        fillColor: const Color(0xFFF8F8FC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCourse,
                      items: _controller.courses.map((c) => DropdownMenuItem(value: c.courseName, child: Text('📚 ${c.courseName}'))).toList(),
                      onChanged: (val) => selectedCourse = val!,
                      decoration: InputDecoration(
                        labelText: 'Mata Kuliah',
                        filled: true,
                        fillColor: const Color(0xFFF8F8FC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: notesController,
                      maxLines: 2,
                      decoration: InputDecoration(
                        labelText: 'Catatan Tugas',
                        hintText: 'Misal: Kirim format PDF ke VLM',
                        filled: true,
                        fillColor: const Color(0xFFF8F8FC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      tileColor: const Color(0xFFF8F8FC),
                      title: Text('Deadline: ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                      trailing: const Icon(Icons.calendar_month, color: Color(0xFF8C72EC)),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime.now().subtract(const Duration(days: 30)),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setModalState(() => selectedDate = picked);
                        }
                      },
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8C72EC),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        if (titleController.text.isNotEmpty) {
                          setState(() {
                            if (task == null) {
                              _controller.tasksList.add({
                                'id': DateTime.now().toString(),
                                'title': titleController.text,
                                'course': selectedCourse,
                                'notes': notesController.text,
                                'dueDate': selectedDate,
                                'isCompleted': false,
                              });
                            } else {
                              task['title'] = titleController.text;
                              task['course'] = selectedCourse;
                              task['notes'] = notesController.text;
                              task['dueDate'] = selectedDate;
                            }
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Simpan Tugas', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: AppBar(
        title: const Text('Daftar Tugas', style: TextStyle(color: Color(0xFF2D2E4A), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _controller.tasksList.length,
        itemBuilder: (context, index) {
          final task = _controller.tasksList[index];
          DateTime dueDate = task['dueDate'];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8)],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Checkbox(
                  activeColor: const Color(0xFF8C72EC),
                  value: task['isCompleted'],
                  onChanged: (val) {
                    setState(() {
                      task['isCompleted'] = val;
                    });
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task['title'],
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2D2E4A),
                          decoration: task['isCompleted'] ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text('${task['course']}', style: const TextStyle(fontSize: 12, color: Color(0xFF8C8CA1))),
                      if (task['notes'] != null && task['notes'].toString().isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text('Catatan: ${task['notes']}', style: const TextStyle(fontSize: 11, color: Color(0xFF8C8CA1), fontStyle: FontStyle.italic)),
                      ],
                      const SizedBox(height: 6),
                      Text(
                        'Deadline: ${dueDate.day}/${dueDate.month}/${dueDate.year}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFE89D29)),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                      onPressed: () => _showTaskForm(task: task),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                      onPressed: () {
                        setState(() {
                          _controller.tasksList.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF8C72EC),
        onPressed: () => _showTaskForm(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Tugas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}