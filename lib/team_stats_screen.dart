import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

class TeamStatsScreen extends StatelessWidget {
  const TeamStatsScreen({super.key});

  // Datos de ejemplo basados en tu esquema
  final int partidosJugados = 25;
  final int partidosGanados = 15;
  final int partidosPerdidos = 5;
  final int partidosEmpatados = 5;
  final int golesAFavor = 45;
  final int golesEnContra = 20;
  final double reputacion = 4.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Estadísticas del Equipo', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF1A237E), // Un azul oscuro y serio
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      backgroundColor: Colors.grey[100], // Un fondo neutro para que destaquen las tarjetas
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTeamHeader(),
            const SizedBox(height: 24),
            _buildPerformanceCard(),
            const SizedBox(height: 24),
            _buildGoalStatsCard(),
            const SizedBox(height: 24),
            _buildReputationCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamHeader() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            const Icon(Icons.shield, size: 50, color: Color(0xFF1A237E)),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mi Equipo',
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  'Temporada Actual',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardTitle(Icons.show_chart, 'Rendimiento en Torneos'),
            const SizedBox(height: 20),
            Text(
              'Partidos Jugados: $partidosJugados',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: PieChart(
                PieChartData(
                  sections: _buildPieChartSections(),
                  borderData: FlBorderData(show: false),
                  sectionsSpace: 4,
                  centerSpaceRadius: 40,
                  pieTouchData: PieTouchData(touchCallback: (event, response) {}),
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    const double radius = 60;
    return [
      PieChartSectionData(
        color: Colors.green[400],
        value: partidosGanados.toDouble(),
        title: '${(partidosGanados / partidosJugados * 100).toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.red[400],
        value: partidosPerdidos.toDouble(),
        title: '${(partidosPerdidos / partidosJugados * 100).toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.orange[400],
        value: partidosEmpatados.toDouble(),
        title: '${(partidosEmpatados / partidosJugados * 100).toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildLegendItem(Colors.green[400]!, 'Ganados ($partidosGanados)'),
        _buildLegendItem(Colors.red[400]!, 'Perdidos ($partidosPerdidos)'),
        _buildLegendItem(Colors.orange[400]!, 'Empatados ($partidosEmpatados)'),
      ],
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(width: 16, height: 16, color: color),
        const SizedBox(width: 8),
        Text(text, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildGoalStatsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardTitle(Icons.sports_soccer, 'Goles'),
            const SizedBox(height: 24),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (golesAFavor > golesEnContra ? golesAFavor : golesEnContra) * 1.2,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: _bottomTitles,
                        reservedSize: 38,
                      ),
                    ),
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _buildBarChartGroups(),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<BarChartGroupData> _buildBarChartGroups() {
    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(toY: golesAFavor.toDouble(), color: Colors.blue[400], width: 30, borderRadius: const BorderRadius.all(Radius.circular(4)))
        ],
        showingTooltipIndicators: [0],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(toY: golesEnContra.toDouble(), color: Colors.purple[400], width: 30, borderRadius: const BorderRadius.all(Radius.circular(4)))
        ],
        showingTooltipIndicators: [0],
      ),
    ];
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14);
    String text;
    switch (value.toInt()) {
      case 0:
        text = 'A Favor';
        break;
      case 1:
        text = 'En Contra';
        break;
      default:
        text = '';
        break;
    }
    return SideTitleWidget(axisSide: meta.axisSide, space: 16, child: Text(text, style: style));
  }

  Widget _buildReputationCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCardTitle(Icons.star_half, 'Reputación del Equipo'),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  reputacion.toString(),
                  style: GoogleFonts.poppins(fontSize: 48, fontWeight: FontWeight.bold, color: const Color(0xFF1A237E)),
                ),
                const SizedBox(width: 8),
                Icon(Icons.star, color: Colors.amber[600], size: 40),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Basado en juego limpio y opiniones de otros equipos.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1A237E), size: 28),
        const SizedBox(width: 12),
        Text(
          title,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ],
    );
  }
}
