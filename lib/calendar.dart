import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:ubook/services/calendarservice.dart';
import 'package:ubook/services/auth_service.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<Map<String, dynamic>>> _events = {};
  final List<Map<String, dynamic>> _allReminders = [];
  final AuthService authService = AuthService();

  String? userId;
  String _viewOption = 'Por día';

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    String? savedUserId = await authService.getUserId();
    if (savedUserId != null) {
      setState(() {
        userId = savedUserId;
      });
      _loadReminders();
    } else {
      print('No se encontró el userId');
    }
  }

  Future<void> _loadReminders() async {
    if (userId != null) {
      try {
        List<dynamic> reminders =
            await CalendarService.loadReminders(int.parse(userId!));

        setState(() {
          _allReminders.clear();
          _events.clear(); // Reset the events

          // Populate the _events map with reminders
          for (var reminder in reminders) {
            DateTime date = DateTime.parse(
                reminder['reminder_date']); // Ensure accurate parsing of date
            if (_events[date] == null) {
              _events[date] = [];
            }

            // Add reminder to the _events map and the list of all reminders
            _events[date]!.add({
              'message': reminder['reminder_message'],
              'reminder_id': reminder['reminder_id'],
            });

            _allReminders.add({
              'date': date,
              'message': reminder['reminder_message'],
              'reminder_id': reminder['reminder_id'],
            });
          }
        });
      } catch (e) {
        print('Error loading reminders: $e');
      }
    }
  }

  Future<void> _loadRemindersByDay(DateTime day) async {
    if (userId != null) {
      try {
        List<dynamic> reminders = await CalendarService.getRemindersByDay(
            int.parse(userId!), day.toIso8601String().split('T')[0]);

        setState(() {
          _events[day]
              ?.clear(); // Limpiamos solo los eventos del día seleccionado
          _events[day] = [];

          for (var reminder in reminders) {
            _events[day]!.add({
              'message': reminder['reminder_message'],
              'reminder_id': reminder['reminder_id'],
            });
          }
        });
      } catch (e) {
        print('Error al cargar recordatorios para este día: $e');
      }
    }
  }

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
              onPressed: () async {
                if (reminderText.isNotEmpty && userId != null) {
                  try {
                    await CalendarService.addReminder(int.parse(userId!),
                        reminderText, day.toIso8601String());
                    await _loadReminders(); // Re-sync with the server
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error añadiendo recordatorio: $e');
                  }
                }
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  void _editReminder(DateTime day, String reminderId) {
    final reminder = _events[day]?.firstWhere(
      (event) => event['reminder_id'].toString() == reminderId,
      orElse: () => <String, dynamic>{}, // Empty map instead of null
    );
    if (reminder != null) {
      String updatedText = reminder['message'];
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Editar Recordatorio'),
            content: TextField(
              controller: TextEditingController(text: updatedText),
              onChanged: (value) {
                updatedText = value;
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await CalendarService.editReminder(
                      int.parse(reminderId),
                      updatedText,
                      day.toIso8601String(),
                    );
                    await _loadReminders(); // Re-sync after editing
                    Navigator.of(context).pop();
                  } catch (e) {
                    print('Error editando recordatorio: $e');
                  }
                },
                child: const Text('Guardar'),
              ),
            ],
          );
        },
      );
    } else {
      print('Recordatorio no encontrado.');
    }
  }

  void _deleteReminder(DateTime day, String reminderId) async {
    try {
      final reminder = _events[day]?.firstWhere(
        (event) => event['reminder_id'].toString() == reminderId,
        orElse: () => <String, dynamic>{}, // Empty map instead of null
      );

      if (reminder != null) {
        await CalendarService.deleteReminder(int.parse(reminderId));
        await _loadReminders(); // Re-sync after deleting
      } else {
        print('Recordatorio no encontrado.');
      }
    } catch (e) {
      print('Error eliminando recordatorio: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario', style: TextStyle(color: Colors.white)),
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

              if (_viewOption == 'Por día') {
                _loadRemindersByDay(selectedDay); // Solo afecta a la lista
              }
            },
            eventLoader: (day) {
              // Filtrar eventos basados en el reminder_date
              return _allReminders.where((reminder) {
                DateTime reminderDate = DateTime(reminder['date'].year,
                    reminder['date'].month, reminder['date'].day);
                return isSameDay(
                    reminderDate, day); // Comparación precisa por fecha
              }).toList();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: _viewOption,
              items: const [
                DropdownMenuItem(
                    value: 'Por día', child: Text('Recordatorios por día')),
                DropdownMenuItem(
                    value: 'Todos', child: Text('Todos los recordatorios')),
              ],
              onChanged: (value) {
                setState(() {
                  _viewOption = value!;
                });
              },
            ),
          ),
          Expanded(
            child: _viewOption == 'Por día'
                ? _selectedDay != null
                    ? (_events[_selectedDay]?.isNotEmpty ?? false)
                        ? ListView.builder(
                            itemCount: _events[_selectedDay]?.length ?? 0,
                            itemBuilder: (context, index) {
                              final reminder = _events[_selectedDay]![index];
                              return ListTile(
                                title: Text(reminder['message']),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _editReminder(_selectedDay!,
                                            reminder['reminder_id'].toString());
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _deleteReminder(_selectedDay!,
                                            reminder['reminder_id'].toString());
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : const Center(
                            child: Text("No hay recordatorios para este día."))
                    : const Center(
                        child: Text(
                            "Selecciona un día para ver los recordatorios."))
                : ListView.builder(
                    itemCount: _allReminders.length,
                    itemBuilder: (context, index) {
                      final reminder = _allReminders[index];
                      return ListTile(
                        title: Text(reminder['message']),
                        subtitle: Text(
                            'Fecha: ${reminder['date'].toString().split(' ')[0]}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _editReminder(reminder['date'],
                                    reminder['reminder_id'].toString());
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _deleteReminder(reminder['date'],
                                    reminder['reminder_id'].toString());
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_selectedDay != null) {
            _addReminder(_selectedDay!);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
