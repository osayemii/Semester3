import 'package:flutter/material.dart';

class DatePickerScreen extends StatefulWidget {
  const DatePickerScreen({super.key});

  @override
  State<DatePickerScreen> createState() =>
      _DatePickerScreenState();
}

class _DatePickerScreenState
    extends State<DatePickerScreen> {
  DateTime? selectedDate;

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Picker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: pickDate,
              child: const Text(
                'Select Date',
              ),
            ),

            const SizedBox(height: 20),

            Text(
              selectedDate == null
                  ? 'No date selected'
                  : selectedDate.toString(),
            ),
          ],
        ),
      ),
    );
  }
}