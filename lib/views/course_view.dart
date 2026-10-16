import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';
import '../models/course_model.dart';

class CourseView extends StatefulWidget {
  const CourseView({super.key});

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  final AppController _controller = AppController();

  void _showCourseForm({CourseModel? course}) {
    final nameController = TextEditingController(text: course?.courseName ?? '');
    final lecturerController = TextEditingController(text: course?.lecturer ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 20, top: 20, left: 20, right: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course == null ? 'Tambah Mata Kuliah' : 'Edit Mata Kuliah',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A)),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Mata Kuliah',
                  filled: true,
                  fillColor: const Color(0xFFF8F8FC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: lecturerController,
                decoration: InputDecoration(
                  labelText: 'Nama Dosen Pengampu',
                  filled: true,
                  fillColor: const Color(0xFFF8F8FC),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8C72EC),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  if (nameController.text.isNotEmpty) {
                    setState(() {
                      if (course == null) {
                        _controller.addCourse(nameController.text, lecturerController.text);
                      } else {
                        _controller.editCourse(course.id, nameController.text, lecturerController.text);
                      }
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text('Simpan Mata Kuliah', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: AppBar(
        title: const Text('Daftar Mata Kuliah', style: TextStyle(color: Color(0xFF2D2E4A), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _controller.courses.length,
        itemBuilder: (context, index) {
          final course = _controller.courses[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8)],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: const Color(0xFFEBEBFF), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.book_rounded, color: Color(0xFF8C72EC)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course.courseName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),
                      const SizedBox(height: 4),
                      Text('Dosen Pengampu: ${course.lecturer.isNotEmpty ? course.lecturer : "Belum ada dosen"}', style: const TextStyle(fontSize: 12, color: Color(0xFF8C8CA1))),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                  onPressed: () => _showCourseForm(course: course),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                  onPressed: () {
                    setState(() {
                      _controller.deleteCourse(course.id);
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
      
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF8C72EC),
        onPressed: () => _showCourseForm(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tambah Matkul',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}