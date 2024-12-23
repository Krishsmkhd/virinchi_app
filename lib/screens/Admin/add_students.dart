import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/models/course.dart';

import '../../utils/utils.dart';

class AddStudentForm extends StatefulWidget {
  const AddStudentForm({super.key});

  @override
  _AddStudentFormState createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  final _formKey = GlobalKey<FormState>();
  String _matrixNumber = "";
  String _name = "";
  String _semester = "";
  String _section = "";
  String _email = "";
  String _password = "";
  String _address = "";
  String? _imageUrl;

  List<Course> courses = [];
  bool coursesLoading = true;

  Future<void> getCourses() async {
    courses = await Utils.getSemester();
    setState(() {
      coursesLoading = false;
    });
  }

  DateTime? _dob = DateTime.now();
  List<String> months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

  @override
  void initState() {
    super.initState();
    getCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Student'),
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
                      : const Icon(Icons.camera_alt, size: 50, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter full name';
                  }
                  return null;
                },
                onChanged: (value) => setState(() => _name = value),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Matrix Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter matrix number';
                  }
                  return null;
                },
                onChanged: (value) => setState(() => _matrixNumber = value),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Course>(
                validator: (value) {
                  if (value == null) {
                    return 'Please select a semester';
                  }
                  return null;
                },
                decoration: const InputDecoration(labelText: 'Semester'),
                items: courses.map((Course value) {
                  return DropdownMenuItem<Course>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _semester = value.name;
                  });
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Section'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a section';
                  }
                  return null;
                },
                onChanged: (value) => setState(() => _section = value),
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address'),
                onChanged: (value) => setState(() => _address = value),
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
                    setState(() {
                      _dob = pickedDate;
                    });
                  }
                },
                child: IgnorePointer(
                  child: TextFormField(
                    decoration: const InputDecoration(labelText: 'Date of Birth'),
                    controller: TextEditingController(text: _dob != null ? "${_dob?.day}/${_dob?.month}/${_dob?.year}" : ""),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_imageUrl == null) {
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please upload an image')));
                      return;
                    }

                    FirebaseFirestore.instance.collection("students").add(
                      {
                        'matrixNumber': _matrixNumber,
                        'name': _name,
                        'section': _section,
                        'email': _email,
                        'password': _password,
                        'address': _address,
                        'dob': "${_dob?.day} ${months[_dob!.month - 1]}, ${_dob?.year}",
                        if (_imageUrl != null) "imageUrl": _imageUrl,
                        'semester': _semester,
                        'role': 'Student'
                      },
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
