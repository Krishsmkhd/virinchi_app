import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../models/routine.dart';

class AddRoutineForm extends StatefulWidget {
  const AddRoutineForm({super.key});

  @override
  _AddRoutineFormState createState() => _AddRoutineFormState();
}

class _AddRoutineFormState extends State<AddRoutineForm> {
  final _formKey = GlobalKey<FormState>();

  late String _selectedClass = "1";
  late String _selectedSection = "A";
  late String _selectedDay = "Sunday";
  final List<Subject> _subjects = [];

  void _addSubject() {
    setState(() {
      _subjects.add(
        Subject(
          name: '',
          startTime: TimeOfDay.now(),
          endTime: TimeOfDay.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Routine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedClass,
                decoration: const InputDecoration(labelText: 'Class'),
                items: const [
                  DropdownMenuItem(value: '1', child: Text('Class 1')),
                  DropdownMenuItem(value: '2', child: Text('Class 2')),
                  DropdownMenuItem(value: '3', child: Text('Class 3')),
                  DropdownMenuItem(value: '4', child: Text('Class 4')),
                  DropdownMenuItem(value: '5', child: Text('Class 5')),
                  DropdownMenuItem(value: '6', child: Text('Class 6')),
                  DropdownMenuItem(value: '7', child: Text('Class 7')),
                  DropdownMenuItem(value: '8', child: Text('Class 8')),
                  DropdownMenuItem(value: '9', child: Text('Class 9')),
                  DropdownMenuItem(value: '10', child: Text('Class 10')),
                ],
                onChanged: (value) => setState(() => _selectedClass = value!),
                validator: (value) => value == null ? 'Class is required' : null,
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedSection,
                decoration: const InputDecoration(labelText: 'Section'),
                items: const [
                  DropdownMenuItem(value: 'A', child: Text('A')),
                  DropdownMenuItem(value: 'B', child: Text('B')),
                  DropdownMenuItem(value: 'C', child: Text('C')),
                ],
                onChanged: (value) => setState(() => _selectedSection = value!),
                validator: (value) => value == null ? 'Section is required' : null,
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                value: _selectedDay,
                decoration: const InputDecoration(labelText: 'Day'),
                items: const [
                  DropdownMenuItem(value: 'Monday', child: Text('Monday')),
                  DropdownMenuItem(value: 'Tuesday', child: Text('Tuesday')),
                  DropdownMenuItem(value: 'Wednesday', child: Text('Wednesday')),
                  DropdownMenuItem(value: 'Thursday', child: Text('Thursday')),
                  DropdownMenuItem(value: 'Friday', child: Text('Friday')),
                ],
                onChanged: (value) => setState(() => _selectedDay = value!),
                validator: (value) => value == null ? 'Day is required' : null,
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: ListView.builder(
                  itemCount: _subjects.length,
                  itemBuilder: (context, index) {
                    final subject = _subjects[index];
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              decoration: const InputDecoration(
                                labelText: 'Subject name',
                              ),
                              initialValue: subject.name,
                              onChanged: (value) => setState(() => subject.name = value),
                              validator: (value) => value!.isEmpty ? 'Subject name is required' : null,
                            ),
                            const SizedBox(height: 16.0),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'Start Time',
                                    ),
                                    onTap: () async {
                                      final timeOfDay = await showTimePicker(
                                        context: context,
                                        initialTime: subject.startTime,
                                      );
                                      setState(() {
                                        subject.startTime = timeOfDay!;
                                      });
                                    },
                                    readOnly: true,
                                    controller: TextEditingController(
                                      text: subject.startTime.format(context),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Expanded(
                                  child: TextFormField(
                                    decoration: const InputDecoration(
                                      labelText: 'End Time',
                                    ),
                                    onTap: () async {
                                      final timeOfDay = await showTimePicker(
                                        context: context,
                                        initialTime: subject.endTime,
                                      );
                                      setState(() {
                                        subject.endTime = timeOfDay!;
                                      });
                                    },
                                    readOnly: true,
                                    controller: TextEditingController(
                                      text: subject.endTime.format(context),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _addSubject,
                child: const Text('Add Subject'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                child: const Text('Save Routine'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    FirebaseFirestore.instance.collection("routines").add({
                      "class": int.parse(_selectedClass),
                      "section": _selectedSection,
                      "day": _selectedDay,
                      "subjects": _subjects
                          .map((subject) => {
                                "name": subject.name,
                                "startTime": subject.startTime.format(context),
                                "endTime": subject.endTime.format(context),
                              })
                          .toList(),
                    });
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
