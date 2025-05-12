import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  String selectedIntake = 'APU2F2409CS(AI)';
  String selectedGroup = 'G1';
  DateTime selectedDate = DateTime.now();

  Map<String, List<Map<String, String>>> scheduleByGroup = {
    'G1': [
      {'time': '11:45AM - 12:45PM', 'location': 'D-08-02'},
      {'time': '1:30PM - 3:30PM', 'location': 'E-09-02'},
    ],
    'G2': [
      {'time': '9:00AM - 10:00AM', 'location': 'B-05-04'},
      {'time': '2:00PM - 4:00PM', 'location': 'D-06-01'},
    ],
  };

  void _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  void _showAttendanceNotification(bool attended) {
    final snackBar = SnackBar(
      content: Text(
        attended ? 'Marked as attended ✅' : 'Marked as not attended ❌',
      ),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final scheduleItems = scheduleByGroup[selectedGroup] ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Schedule')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ...scheduleItems.map(
              (item) => Card(
                child: ListTile(
                  title: Text('${item['location']} | APU Campus'),
                  subtitle: Text(item['time']!),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        onPressed: () => _showAttendanceNotification(true),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: const Icon(Icons.cancel, color: Colors.red),
                        onPressed: () => _showAttendanceNotification(false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text("Select Intake: "),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedIntake,
                  items: const [
                    DropdownMenuItem(
                      value: 'APU2F2409CS(AI)',
                      child: Text('APU2F2409CS(AI)'),
                    ),
                    DropdownMenuItem(
                      value: 'APU2F2409BM',
                      child: Text('APU2F2409BM'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedIntake = value!;
                    });
                  },
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedGroup,
                  items: const [
                    DropdownMenuItem(value: 'G1', child: Text('G1')),
                    DropdownMenuItem(value: 'G2', child: Text('G2')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedGroup = value!;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _pickDate,
                  child: const Text('Pick Date'),
                ),
                const SizedBox(width: 10),
                Text(
                  '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
