import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Import package grafik
import '../controllers/app_controller.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  final AppController _controller = AppController();
  late String selectedMonthKey;

  @override
  void initState() {
    super.initState();
    selectedMonthKey = _controller.availableMonths.first;
  }

  @override
  Widget build(BuildContext context) {
    int totalPlan = _controller.totalPlanners;
    int completed = _controller.completedPlanners;
    int missed = _controller.missedPlanners;
    int uncompleted = _controller.uncompletedPlanners;
    double percentage = totalPlan > 0 ? (completed / totalPlan) * 100 : 0.0;

    var reportData = _controller.getReportDataForMonth(selectedMonthKey);
    Map<String, int> dailyMinutes = reportData['daily'];
    int totalWeekMins = reportData['totalWeekMinutes'];
    int totalMonthMins = reportData['totalMonthMinutes'];
    Map<String, int> weeklyBreakdown = reportData['weeklyBreakdown'];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FC),
      appBar: AppBar(
        title: const Text('Laporan Produktivitas', style: TextStyle(color: Color(0xFF2D2E4A), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown Pilih Periode Bulan
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Periode Laporan:', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF8C72EC)),
                  ),
                  child: DropdownButton<String>(
                    value: selectedMonthKey,
                    underline: const SizedBox(),
                    items: _controller.availableMonths.map((mKey) {
                      return DropdownMenuItem(
                        value: mKey,
                        child: Text(_controller.formatMonthName(mKey), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8C72EC))),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => selectedMonthKey = val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Banner Ring Progress Keseluruhan
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8C72EC), Color(0xFFAFA0F5)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: const Color(0xFF8C72EC).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))],
              ),
              child: Column(
                children: [
                  Text('Rangkuman ${_controller.formatMonthName(selectedMonthKey)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircularProgressIndicator(
                          value: percentage / 100,
                          strokeWidth: 12,
                          backgroundColor: Colors.white.withValues(alpha: 0.25),
                          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      Column(
                        children: [
                          Text('${percentage.toStringAsFixed(0)}%', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                          const Text('Terlaksana', style: TextStyle(fontSize: 11, color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3 Statistik Ringkas
            Row(
              children: [
                Expanded(child: _buildMetricCard('Terlaksana', '$completed', const Color(0xFFE2F7E2), const Color(0xFF4CAF50))),
                const SizedBox(width: 8),
                Expanded(child: _buildMetricCard('Terlewat', '$missed', const Color(0xFFFFEBEE), Colors.red)),
                const SizedBox(width: 8),
                Expanded(child: _buildMetricCard('Belum Selesai', '$uncompleted', const Color(0xFFFFF3D6), const Color(0xFFE89D29))),
              ],
            ),
            const SizedBox(height: 20),

            // 💡 MENU EVALUASI BELAJAR
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  const Text('💡', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Evaluasi Belajar Mandiri', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),
                        const SizedBox(height: 4),
                        Text(
                          missed > 0
                              ? 'Ada $missed plan terlewat! Sistem mengunci plan tersebut demi menjaga disiplin belajarmu. Yuk, mulai plan berikutnya tepat waktu~'
                              : 'Luar biasa! Semua rencana belajarmu berjalan tepat waktu tanpa ada yang terlewat ✨',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF8C8CA1)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Akumulasi Waktu Belajar
            const Text('Akumulasi Waktu Belajar', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total Minggu Ini', style: TextStyle(fontSize: 12, color: Color(0xFF8C8CA1))),
                        const SizedBox(height: 6),
                        Text(_controller.formatMinutesToText(totalWeekMins), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF8C72EC))),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Total 1 Bulan Penuh', style: TextStyle(fontSize: 12, color: Color(0xFF8C8CA1))),
                        const SizedBox(height: 6),
                        Text(_controller.formatMinutesToText(totalMonthMins), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C5CE7))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 📊 VISUALISASI GRAFIK BATANG: STATISTIK JAM BELAJAR PER MINGGU
            const Text('Statistik Jam Belajar per Minggu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),
            const SizedBox(height: 12),
            Container(
              height: 220,
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxY(weeklyBreakdown),
                  barTouchData: BarTouchData(enabled: true),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['W1', 'W2', 'W3', 'W4'];
                          if (value.toInt() >= 0 && value.toInt() < titles.length) {
                            return Text(titles[value.toInt()], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF8C72EC)));
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: weeklyBreakdown.values.toList().asMap().entries.map((entry) {
                    int index = entry.key;
                    int minutes = entry.value;
                    double hours = minutes / 60.0; // Ubah menit ke jam untuk grafik

                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: hours > 0 ? hours : 0.2, // Minimal tinggi batang agar tetap terlihat
                          color: const Color(0xFF8C72EC),
                          width: 22,
                          borderRadius: BorderRadius.circular(8),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: _getMaxY(weeklyBreakdown),
                            color: const Color(0xFFF8F8FC),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Keterangan Label Grafik W1-W4
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: weeklyBreakdown.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(entry.key, style: const TextStyle(fontSize: 12, color: Color(0xFF2D2E4A), fontWeight: FontWeight.w600)),
                        Text(_controller.formatMinutesToText(entry.value), style: const TextStyle(fontSize: 12, color: Color(0xFF8C72EC), fontWeight: FontWeight.bold)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // 📅 RINCIAN HARIAN
            const Text('Total waktu belajar hari ini', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),
            const SizedBox(height: 12),
            if (dailyMinutes.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                child: const Text('Belum ada riwayat belajar yang selesai pada bulan ini.', style: TextStyle(color: Color(0xFF8C8CA1))),
              )
            else
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18)),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: dailyMinutes.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF0EBFE)),
                  itemBuilder: (context, index) {
                    String dateKey = dailyMinutes.keys.elementAt(index);
                    int mins = dailyMinutes[dateKey]!;
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFFEBEBFF),
                        child: Icon(Icons.calendar_today_rounded, size: 18, color: Color(0xFF8C72EC)),
                      ),
                      title: Text('Tanggal: $dateKey', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2D2E4A))),
                      trailing: Text(_controller.formatMinutesToText(mins), style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF8C72EC))),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  double _getMaxY(Map<String, int> weeklyData) {
    double maxMins = 0;
    for (var val in weeklyData.values) {
      if (val > maxMins) maxMins = val.toDouble();
    }
    double maxHours = (maxMins / 60.0);
    return maxHours < 5 ? 5.0 : maxHours + 2; // Batas minimal sumbu Y grafik adalah 5 jam
  }

  Widget _buildMetricCard(String title, String count, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Text(count, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 4),
          Text(title, textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}