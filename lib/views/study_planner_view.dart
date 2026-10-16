import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/app_controller.dart';
import '../models/task_model.dart';

class StudyPlannerView extends StatefulWidget {
  const StudyPlannerView({super.key});

  @override
  State<StudyPlannerView> createState() => _StudyPlannerViewState();
}

class _StudyPlannerViewState extends State<StudyPlannerView> {
  final AppController _controller = AppController();
  
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.week;

  // Fungsi untuk mengambil daftar plan berdasarkan tanggal tertentu (untuk marker kalender)
  List<PlannerModel> _getEventsForDay(DateTime day) {
    return _controller.planners.where((p) {
      return p.dueDate.year == day.year &&
             p.dueDate.month == day.month &&
             p.dueDate.day == day.day;
    }).toList();
  }

  void _showAddPlannerModal(BuildContext context) {
    final titleController = TextEditingController();
    final notesController = TextEditingController();
    String? selectedCourse = _controller.courses.isNotEmpty ? _controller.courses.first.courseName : null;
    DateTime selectedDate = _selectedDay;
    TimeOfDay startTime = const TimeOfDay(hour: 8, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 0);
    String plannerType = 'Daily';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('✨ Buat Study Plan Baru', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),
                    const SizedBox(height: 16),
                    TextField(
                      controller: titleController,
                      decoration: InputDecoration(
                        labelText: 'Judul Plan',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: selectedCourse,
                      decoration: InputDecoration(
                        labelText: 'Mata Kuliah',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _controller.courses.map((course) {
                        return DropdownMenuItem(
                          value: course.courseName,
                          child: Text(course.courseName),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setModalState(() => selectedCourse = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(
                        labelText: 'Catatan / Detail',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF8C72EC),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (titleController.text.isNotEmpty) {
                            _controller.addPlanner(
                              title: titleController.text,
                              courseName: selectedCourse,
                              notes: notesController.text,
                              dueDate: selectedDate,
                              startTime: startTime,
                              endTime: endTime,
                              plannerType: plannerType,
                            );
                            setState(() {});
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Simpan Study Plan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
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
    final selectedDayPlans = _getEventsForDay(_selectedDay);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: AppBar(
        title: const Text('Study Plan Interaktif', style: TextStyle(color: Color(0xFF2D2E4A), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // --- KALENDER INTERAKTIF DENGAN MARKER (TITIK) ---
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
            ),
            child: TableCalendar<PlannerModel>(
              firstDay: DateTime.utc(2024, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: _getEventsForDay, // <--- Menghubungkan plan dengan tanggal di kalender
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: const CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color(0xFF8C72EC),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Color(0xFFE8E5FF),
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(color: Color(0xFF6C5CE7), fontWeight: FontWeight.bold),
                markerDecoration: BoxDecoration(
                  color: Color(0xFF8C72EC), // <--- Warna titik penanda ( ungu )
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: const HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // --- DAFTAR PLAN SESUAI TANGGAL ---
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: selectedDayPlans.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.event_note_rounded, size: 48, color: Color(0xFFB0A8E8)),
                          const SizedBox(height: 8),
                          Text(
                            'Tidak ada plan pada tanggal ${_selectedDay.day}/${_selectedDay.month}/${_selectedDay.year}',
                            style: const TextStyle(color: Color(0xFF8C8CA1), fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: selectedDayPlans.length,
                      itemBuilder: (context, index) {
                        PlannerModel plan = selectedDayPlans[index];
                        bool isExpired = plan.isExpired && !plan.isCompleted;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 14),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isExpired ? const Color(0xFFFFEBEE) : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isExpired ? Colors.red.shade200 : const Color(0xFFEBEBFF),
                            ),
                            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 8)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: isExpired ? Colors.red.shade100 : const Color(0xFFE8E5FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      isExpired ? 'Plan Terlewat! 🌧️' : (plan.courseName ?? 'Mandiri'),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: isExpired ? Colors.red : const Color(0xFF6C5CE7),
                                      ),
                                    ),
                                  ),
                                  if (isExpired)
                                    const Text('Terkunci', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.red))
                                  else
                                    Checkbox(
                                      value: plan.isCompleted,
                                      activeColor: const Color(0xFF8C72EC),
                                      onChanged: (val) {
                                        setState(() {
                                          _controller.togglePlannerCompletion(plan.id);
                                        });
                                      },
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                plan.title,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2D2E4A),
                                  decoration: plan.isCompleted ? TextDecoration.lineThrough : null,
                                ),
                              ),
                              if (plan.notes.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(plan.notes, style: const TextStyle(fontSize: 12, color: Color(0xFF8C8CA1))),
                              ],
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${plan.startTime.format(context)} - ${plan.endTime.format(context)}',
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF8C72EC)),
                                  ),
                                  if (plan.isCompleted)
                                    const Text(
                                      'Selesai',
                                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF8C72EC),
        onPressed: () => _showAddPlannerModal(context),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Tambah Plan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}