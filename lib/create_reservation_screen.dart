
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class CreateReservationScreen extends StatefulWidget {
  const CreateReservationScreen({super.key});

  @override
  CreateReservationScreenState createState() => CreateReservationScreenState();
}

class CreateReservationScreenState extends State<CreateReservationScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context, {required bool isStartTime}) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? (_startTime ?? TimeOfDay.now()) : (_endTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'No seleccionada';
    return DateFormat('EEEE, d \'de\' MMMM \'de\' y', 'es_ES').format(date);
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return 'No seleccionada';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('h:mm a').format(dt);
  }

  String _calculateTotalHours() {
    if (_startTime == null || _endTime == null) return '0';
    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;
    if (endMinutes <= startMinutes) return '0';
    final duration = endMinutes - startMinutes;
    final hours = duration / 60;
    return hours.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Reserva', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: const Color(0xFF0056B3),
        foregroundColor: Colors.white,
        elevation: 4,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.grey.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildConfirmationButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detalles de la Reserva",
              style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF0056B3)),
            ),
            const SizedBox(height: 16),
            _buildInfoTile(
              icon: Icons.calendar_today,
              title: 'Fecha de la Reserva',
              subtitle: _formatDate(_selectedDate),
              onTap: () => _selectDate(context),
            ),
            _buildInfoTile(
              icon: Icons.access_time,
              title: 'Hora de Inicio',
              subtitle: _formatTime(_startTime),
              onTap: () => _selectTime(context, isStartTime: true),
            ),
            _buildInfoTile(
              icon: Icons.timer_off_outlined,
              title: 'Hora de Fin',
              subtitle: _formatTime(_endTime),
              onTap: () => _selectTime(context, isStartTime: false),
            ),
            const Divider(height: 32),
            _buildStaticInfoRow(icon: Icons.hourglass_bottom, title: 'Total de Horas', value: _calculateTotalHours()),
            _buildStaticInfoRow(icon: Icons.payments_outlined, title: 'Método de Pago', value: 'Efectivo'),
            _buildStaticInfoRow(icon: Icons.attach_money, title: 'Monto Total a Pagar', value: '\$15.00'), // Placeholder
            _buildStaticInfoRow(icon: Icons.flag_outlined, title: 'Estado', value: 'Pendiente', valueColor: Colors.orange.shade700),
          ],
        ),
      ),
    );
  }
  
  Widget _buildInfoTile({required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.blue.shade700, size: 28),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                  Text(subtitle, style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54)),
                ],
              ),
              const Spacer(),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaticInfoRow({required IconData icon, required String title, required String value, Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 24),
          const SizedBox(width: 16),
          Text(title, style: GoogleFonts.poppins(fontSize: 15, color: Colors.black54)),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildConfirmationButton() {
    return ElevatedButton.icon(
      icon: const Icon(Icons.check_circle_outline, color: Colors.white),
      label: Text(
        'Confirmar Reserva',
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        // Lógica para confirmar la reserva
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF007BFF),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(vertical: 16),
        elevation: 5,
        shadowColor: const Color(0xFF007BFF).withAlpha(128),
      ),
    );
  }
}
