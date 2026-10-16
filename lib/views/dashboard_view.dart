import 'package:flutter/material.dart';
import '../controllers/app_controller.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  final AppController _controller = AppController();

  @override
  Widget build(BuildContext context) {
    int totalMatkul = _controller.totalCourses;
    int activePlanners = _controller.uncompletedPlanners; // Belum lewat & belum selesai
    int activeTasks = _controller.activeTasksCount;       // Belum lewat & belum selesai
    
    // Calculation Progress
    int totalPlan = _controller.totalPlanners;
    int completedPlan = _controller.completedPlanners;
    double planProgress = totalPlan > 0 ? (completedPlan / totalPlan) : 0.0;

    int totalTask = _controller.totalTasks;
    int completedTask = _controller.completedTasks;
    double taskProgress = totalTask > 0 ? (completedTask / totalTask) : 0.0;

    String weeklyStudyTime = _controller.weeklyStudyTimeText;
    final todayPlans = _controller.todayPlanners; // Hanya yang belum lewat & belum selesai
    final upcomingTasks = _controller.tasksList.where((t) => t['isCompleted'] == false).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Brand
              const Text(
                'STUDYORA',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Color(0xFF8C72EC),
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Text('Hello, Student! ', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),
                  Text('👋', style: TextStyle(fontSize: 22)),
                ],
              ),
              const SizedBox(height: 4),
              const Text('Yuk, atur kegiatan belajarmu hari ini.', style: TextStyle(fontSize: 14, color: Color(0xFF8C8CA1))),
              const SizedBox(height: 20),

              // 3 KARTU STATISTIK UTAMA
              Row(
                children: [
                  Expanded(child: _buildStatCard('$totalMatkul', 'Mata Kuliah\n', Icons.book_outlined, const Color(0xFFE8E5FF), const Color(0xFF6C5CE7))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatCard('$activePlanners', 'Plan Harus\nDiselesaikan', Icons.pending_actions, const Color(0xFFEBEBFF), const Color(0xFF8C72EC))),
                  const SizedBox(width: 8),
                  Expanded(child: _buildStatCard('$activeTasks', 'Tugas Harus\nDiselesaikan', Icons.assignment_late_outlined, const Color(0xFFFFF3D6), const Color(0xFFE89D29))),
                ],
              ),
              const SizedBox(height: 20),

              // ⏱️ CARD TOTAL WAKTU BELAJAR MINGGU INI
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8C72EC), Color(0xFFAFA0F5)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: const Color(0xFF8C72EC).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                      child: const Icon(Icons.timer_outlined, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Waktu Belajar Bulan Ini', style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text(weeklyStudyTime, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 📊 DUA PROGRESS BAR (Study Plan & Tugas Dosen)
              const Text('Progress', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),
              const SizedBox(height: 12),
              
              // Progress 1: Study Plan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Progress Study Plan', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D2E4A))),
                        Text('${(planProgress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8C72EC))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: planProgress,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFEBEBFF),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF8C72EC)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('$completedPlan dari $totalPlan plan selesai.', style: const TextStyle(fontSize: 11, color: Color(0xFF8C8CA1))),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Progress 2: Tugas Dosen
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 8)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Progress Tugas', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2D2E4A))),
                        Text('${(taskProgress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE89D29))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: taskProgress,
                        minHeight: 8,
                        backgroundColor: const Color(0xFFFFF3D6),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFE89D29)),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('$completedTask dari $totalTask tugas selesai.', style: const TextStyle(fontSize: 11, color: Color(0xFF8C8CA1))),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // 🔔 PENGINGAT PLAN HARIAN (Belum Lewat & Belum Selesai)
              const Row(
                children: [
                  Text('Plan Hari Ini ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),
                ],
              ),
              const SizedBox(height: 12),
              if (todayPlans.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: const Text('Tidak ada plan aktif untuk hari ini.', style: TextStyle(fontSize: 13, color: Color(0xFF8C8CA1))),
                )
              else
                Column(
                  children: todayPlans.map((plan) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEBEBFF)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_rounded, color: Color(0xFF8C72EC), size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(plan.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),
                                Text(
                                  '${plan.startTime.format(context)} - ${plan.endTime.format(context)} ${plan.courseName != null ? '• 📚 ${plan.courseName}' : ''}',
                                  style: const TextStyle(fontSize: 11, color: Color(0xFF8C8CA1)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              const SizedBox(height: 24),

              // Upcoming Tasks Dosen
              const Row(
                children: [
                  Text('Tugas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),
                ],
              ),
              const SizedBox(height: 12),
              if (upcomingTasks.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                  child: const Text('Semua tugas telah selesai!', textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF8C8CA1))),
                )
              else
                Column(
                  children: upcomingTasks.map((task) {
                    DateTime dueDate = task['dueDate'];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFEBEBFF)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.alarm_rounded, color: Color(0xFF8C72EC), size: 22),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(task['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(color: const Color(0xFFFFF3D6), borderRadius: BorderRadius.circular(10)),
                            child: Text(
                              '${dueDate.day}/${dueDate.month}/${dueDate.year}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFE89D29)),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

 Widget _buildStatCard(String count, String label, IconData icon, Color bgColor, Color iconColor) {
    return Container(
      height: 115, // Memberikan tinggi tetap agar semua card ukurannya 100% sama rata
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(18)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Mengatur jarak agar rapi atas-bawah
        children: [
          Icon(icon, color: iconColor, size: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: iconColor)),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}