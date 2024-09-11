import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};

  // Método para mostrar el cuadro de diálogo para agregar un recordatorio
  void _addReminder(DateTime day) {
    String reminderText = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir Recordatorio'),
          content: TextField(
            onChanged: (value) {
              reminderText = value;
            },
            decoration:
                const InputDecoration(hintText: "Escribe tu recordatorio"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (reminderText.isNotEmpty) {
                  setState(() {
                    if (_events[day] != null) {
                      _events[day]!.add(reminderText);
                    } else {
                      _events[day] = [reminderText];
                    }
                  });
                }
                Navigator.of(context).pop();
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendario',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF004D40), // Verde oscuro
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectedDay != null
                ? () => _addReminder(_selectedDay!)
                : null, // El botón se desactiva si no hay día seleccionado
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  _selectedDay != null ? const Color(0xFF004D40) : Colors.grey,
            ),
            child: const Text('Añadir Recordatorio'),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _selectedDay != null && _events[_selectedDay!] != null
                  ? _events[_selectedDay!]!.length
                  : 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    _events[_selectedDay!]![index],
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
