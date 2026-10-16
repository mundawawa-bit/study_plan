import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../models/task_model.dart';

class AppController {
  static final AppController _instance = AppController._internal();
  factory AppController() => _instance;
  AppController._internal();

  final List<CourseModel> courses = [
    CourseModel(id: '1', courseName: 'Pemrograman Mobile', lecturer: 'Pak Dosen'),
    CourseModel(id: '2', courseName: 'Basis Data', lecturer: 'Bu Dosen'),
  ];

  final List<Map<String, dynamic>> tasksList = [
    {
      'id': '1',
      'title': 'Modul Layouting Flutter',
      'course': 'Pemrograman Mobile',
      'notes': 'Kirim format ZIP ke Google Classroom',
      'dueDate': DateTime.now().add(const Duration(days: 2)),
      'isCompleted': false,
    }
  ];

  final List<PlannerModel> planners = [
    PlannerModel(
      id: '1',
      title: 'Koding UI Dashboard Studyora',
      courseName: 'Pemrograman Mobile',
      notes: 'Gunakan arsitektur MVC',
      isCompleted: false,
      dueDate: DateTime.now(), // Hari ini
      startTime: const TimeOfDay(hour: 8, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 30),
      plannerType: 'Daily',
      durationInMinutes: 0,
    ),
    PlannerModel(
      id: '2',
      title: 'Review ERD Database',
      courseName: 'Basis Data',
      notes: 'Latihan relasi foreign key',
      isCompleted: false,
      dueDate: DateTime.now().add(const Duration(days: 3)), // 3 hari lagi (Minggu ini)
      startTime: const TimeOfDay(hour: 14, minute: 0),
      endTime: const TimeOfDay(hour: 16, minute: 0),
      plannerType: 'Daily',
      durationInMinutes: 0,
    ),
    PlannerModel(
      id: '3',
      title: 'Ujian Tengah Semester / Proyek Besar',
      courseName: 'Pemrograman Mobile',
      notes: 'Persiapan akhir bulan',
      isCompleted: false,
      dueDate: DateTime.now().add(const Duration(days: 15)), // 15 hari lagi (Mendatang)
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      plannerType: 'Daily',
      durationInMinutes: 0,
    ),
  ];

  int get totalCourses => courses.length;
  int get totalTasks => tasksList.length;
  int get completedTasks => tasksList.where((t) => t['isCompleted'] == true).length;
  
  int get activeTasksCount {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return tasksList.where((t) {
      DateTime dueDate = t['dueDate'];
      final taskDate = DateTime(dueDate.year, dueDate.month, dueDate.day);
      bool isNotExpired = taskDate.isAfter(today) || taskDate.isAtSameMomentAs(today);
      return t['isCompleted'] == false && isNotExpired;
    }).length;
  }

  int get totalPlanners => planners.length;
  int get completedPlanners => planners.where((p) => p.isCompleted).length;
  int get missedPlanners => planners.where((p) => !p.isCompleted && p.isExpired).length;
  int get uncompletedPlanners => planners.where((p) => !p.isCompleted && !p.isExpired).length;

  List<PlannerModel> get todayPlanners {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return planners.where((p) {
      final pDate = DateTime(p.dueDate.year, p.dueDate.month, p.dueDate.day);
      return pDate.isAtSameMomentAs(today) && !p.isCompleted && !p.isExpired;
    }).toList();
  }

  String get weeklyStudyTimeText {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    int totalMinutes = 0;
    for (var p in planners.where((item) => item.isCompleted)) {
      final pDate = DateTime(p.dueDate.year, p.dueDate.month, p.dueDate.day);
      if ((pDate.isAfter(startOfWeek) || pDate.isAtSameMomentAs(startOfWeek)) &&
          (pDate.isBefore(endOfWeek) || pDate.isAtSameMomentAs(endOfWeek))) {
        totalMinutes += p.durationInMinutes;
      }
    }
    return formatMinutesToText(totalMinutes);
  }

  void addCourse(String name, String lecturer) {
    courses.add(CourseModel(id: DateTime.now().toString(), courseName: name, lecturer: lecturer));
  }

  void editCourse(String id, String name, String lecturer) {
    final index = courses.indexWhere((c) => c.id == id);
    if (index != -1) {
      courses[index].courseName = name;
      courses[index].lecturer = lecturer;
    }
  }

  void deleteCourse(String id) {
    courses.removeWhere((c) => c.id == id);
  }

  // --- LAPORAN PRODUKTIVITAS ---
  List<String> get availableMonths {
    Set<String> months = {};
    for (var p in planners.where((item) => item.isCompleted)) {
      String mKey = '${p.dueDate.year}-${p.dueDate.month.toString().padLeft(2, '0')}';
      months.add(mKey);
    }
    String currentMonthKey = '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}';
    months.add(currentMonthKey);
    
    List<String> sortedMonths = months.toList();
    sortedMonths.sort((a, b) => b.compareTo(a));
    return sortedMonths;
  }

  String formatMonthName(String yearMonthKey) {
    try {
      final parts = yearMonthKey.split('-');
      int year = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      const months = [
        '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      return '${months[month]} $year';
    } catch (e) {
      return yearMonthKey;
    }
  }

  Map<String, dynamic> getReportDataForMonth(String yearMonthKey) {
    final parts = yearMonthKey.split('-');
    int targetYear = int.parse(parts[0]);
    int targetMonth = int.parse(parts[1]);

    final monthPlans = planners.where((p) {
      return p.isCompleted && p.dueDate.year == targetYear && p.dueDate.month == targetMonth;
    }).toList();

    Map<String, int> dailyMinutes = {};
    int totalMonthMinutes = 0;

    int week1Mins = 0;
    int week2Mins = 0;
    int week3Mins = 0;
    int week4Mins = 0;

    for (var p in monthPlans) {
      int day = p.dueDate.day;
      int mins = p.durationInMinutes;
      
      String dateKey = '${day.toString().padLeft(2, '0')}/${p.dueDate.month.toString().padLeft(2, '0')}/${p.dueDate.year}';
      dailyMinutes[dateKey] = (dailyMinutes[dateKey] ?? 0) + mins;
      totalMonthMinutes += mins;

      if (day >= 1 && day <= 7) {
        week1Mins += mins;
      } else if (day >= 8 && day <= 14) {
        week2Mins += mins;
      } else if (day >= 15 && day <= 21) {
        week3Mins += mins;
      } else {
        week4Mins += mins;
      }
    }

    final now = DateTime.now();
    int totalWeekMinutes = 0;
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    for (var p in planners.where((item) => item.isCompleted)) {
      final pDate = DateTime(p.dueDate.year, p.dueDate.month, p.dueDate.day);
      if ((pDate.isAfter(startOfWeek) || pDate.isAtSameMomentAs(startOfWeek)) &&
          (pDate.isBefore(endOfWeek) || pDate.isAtSameMomentAs(endOfWeek))) {
        totalWeekMinutes += p.durationInMinutes;
      }
    }

    return {
      'daily': dailyMinutes,
      'totalWeekMinutes': totalWeekMinutes,
      'totalMonthMinutes': totalMonthMinutes,
      'weeklyBreakdown': {
        'Minggu 1 (Tgl 1-7)': week1Mins,
        'Minggu 2 (Tgl 8-14)': week2Mins,
        'Minggu 3 (Tgl 15-21)': week3Mins,
        'Minggu 4 (Tgl 22+)': week4Mins,
      },
    };
  }

  String formatMinutesToText(int totalMinutes) {
    int hours = totalMinutes ~/ 60;
    int minutes = totalMinutes % 60;
    if (hours > 0 && minutes > 0) return '$hours Jam $minutes Mnt';
    if (hours > 0) return '$hours Jam';
    return '$minutes Mnt';
  }

  void addPlanner({
    required String title,
    String? courseName,
    String notes = '',
    required DateTime dueDate,
    required TimeOfDay startTime,
    required TimeOfDay endTime,
    required String plannerType,
  }) {
    planners.add(PlannerModel(
      id: DateTime.now().toString(),
      title: title,
      courseName: courseName,
      notes: notes,
      dueDate: dueDate,
      startTime: startTime,
      endTime: endTime,
      plannerType: plannerType,
      durationInMinutes: 60, // Default 1 jam belajar saat dibuat
    ));
  }

  void togglePlannerCompletion(String id) {
    final index = planners.indexWhere((p) => p.id == id);
    if (index != -1) {
      if (!planners[index].isExpired || planners[index].isCompleted) {
        planners[index].isCompleted = !planners[index].isCompleted;
        // Berikan durasi 60 menit otomatis saat dicentang selesai
        if (planners[index].isCompleted) {
          planners[index].durationInMinutes = 60;
        } else {
          planners[index].durationInMinutes = 0;
        }
      }
    }
  }
}