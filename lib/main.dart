import 'package:flutter/material.dart';
import 'views/dashboard_view.dart';
import 'views/course_view.dart';
import 'views/task_view.dart';
import 'views/study_planner_view.dart';
import 'views/report_view.dart';
import 'views/login_view.dart'; // Import halaman login yang baru dibuat

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cute Study Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFFF8F8FC),
      ),
      home: const LoginView(), // Mengatur halaman pertama saat aplikasi dibuka adalah LoginView
    );
  }
}

class MainNavigator extends StatefulWidget {
  const MainNavigator({super.key});

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const DashboardView(),
    const CourseView(),
    const TaskView(),
    const StudyPlannerView(),
    const ReportView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF5A4B81),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.book_rounded), label: 'Matkul'),
          BottomNavigationBarItem(icon: Icon(Icons.task_alt), label: 'Tugas'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Planner'),
          BottomNavigationBarItem(icon: Icon(Icons.insert_chart_rounded), label: 'Laporan'),
        ],
      ),
    );
  }
}