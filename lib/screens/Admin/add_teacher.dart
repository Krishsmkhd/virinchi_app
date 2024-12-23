import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class AddTeacherForm extends StatefulWidget {
  const AddTeacherForm({super.key});

  @override
  _AddTeacherFormState createState() => _AddTeacherFormState();
}

class _AddTeacherFormState extends State<AddTeacherForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _password;
  late String _subject;
  String? _imageUrl;
  DateTime? _dob = DateTime.now();
  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  late List<String> subjects;
  bool subjectsLoading = true;

  @override
  void initState() {
    super.initState();
    subjects = [];
    getSubject();
  }

  Future<void> getSubject() async {
    subjects = await Utils.getSubject();
    setState(() {
      subjectsLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Teacher'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              GestureDetector(
                onTap: () async {
                  final url = await Utils.uploadImage();
                  if (url == null) return;
                  setState(() => _imageUrl = url);
                },
                child: CircleAvatar(
                  backgroundColor: Colors.grey[400],
                  radius: 50,
                  child: _imageUrl != null
                      ? ClipOval(
                          child: Image.network(
                            _imageUrl!,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.camera_alt,
                          size: 50, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (value) => setState(() => _name = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onChanged: (value) => setState(() => _email = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a password';
                  }
                  return null;
                },
                onChanged: (value) => setState(() => _password = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == null) {
                    return 'Please subject for the teacher';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Subject'),
                items: subjects.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _subject = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context, // add context argument
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() => _dob = pickedDate);
                  }
                },
                child: IgnorePointer(
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Date of Birth'),
                    controller: TextEditingController(
                        text: _dob != null
                            ? "${_dob?.day}/${_dob?.month}/${_dob?.year}"
                            : ""),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_imageUrl == null) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please upload an image')));
                      return;
                    }

                    FirebaseFirestore.instance.collection("teachers").add(
                      {
                        'name': _name,
                        'email': _email,
                        'password': _password,
                        'role': 'Teacher',
                        'subject': _subject,
                        'dob':
                            "${_dob?.day} ${months[_dob!.month - 1]}, ${_dob?.year}",
                        if (_imageUrl != null) 'imageUrl': _imageUrl,
                      },
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Teacher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
