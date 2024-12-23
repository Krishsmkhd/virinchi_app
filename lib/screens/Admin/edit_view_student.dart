import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/models/student.dart';
import 'package:school_management_app/models/course.dart';
import '../../utils/utils.dart';

class ViewEditStudentScreen extends StatefulWidget {
  final Student student;

  const ViewEditStudentScreen({super.key, required this.student});

  @override
  _ViewEditStudentScreenState createState() => _ViewEditStudentScreenState();
}

class _ViewEditStudentScreenState extends State<ViewEditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _matrixNumber;
  late String _name;
  late String _semester;
  late String _section;
  late String _email;
  late String _address;
  late String _password;
  String? _imageUrl;
  DateTime? _dob;

  List<Course> courses = [];
  bool coursesLoading = true;
  final List<String> months = [
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

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _loadSemesters();
  }

  void _initializeForm() {
    final student = widget.student;
    _matrixNumber = student.matrixNumber;
    _name = student.name;
    _semester = student.semester;
    _section = student.section;
    _email = student.email;
    _address = student.address;
    _imageUrl = student.imageUrl;
    _password = student.password;

    // Parse existing date of birth
    if (student.dob.isNotEmpty) {
      final parts = student.dob.split(' ');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = months.indexOf(parts[1].replaceAll(',', '')) + 1;
        final year = int.parse(parts[2]);
        _dob = DateTime(year, month, day);
      }
    }
  }

  Future<void> _loadSemesters() async {
    courses = await Utils.getSemester();
    setState(() => coursesLoading = false);
  }

  Future<void> _updateStudent() async {
    if (_formKey.currentState!.validate()) {
      try {
        final data = {
          'name': _name,
          'semester': _semester,
          'section': _section,
          'email': _email,
          'address': _address,
          'dob': "${_dob?.day} ${months[_dob!.month - 1]}, ${_dob?.year}",
          'imageUrl': _imageUrl ?? widget.student.imageUrl,
          'password': _password,
        };

        await FirebaseFirestore.instance
            .collection('students')
            .doc(widget.student.id)
            .update(data);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Student updated successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating student: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _updateStudent,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () async {
                  final url = await Utils.uploadImage();
                  if (url != null) setState(() => _imageUrl = url);
                },
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_imageUrl ?? ''),
                  child: _imageUrl == null
                      ? const Icon(Icons.camera_alt, size: 40)
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              _buildReadOnlyField('Matrix Number', _matrixNumber),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter name' : null,
                onChanged: (value) => _name = value,
              ),
              const SizedBox(height: 16),
              coursesLoading
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                      value: _semester,
                      decoration: const InputDecoration(
                        labelText: 'Semester',
                        border: OutlineInputBorder(),
                      ),
                      items: courses
                          .map((course) => DropdownMenuItem<String>(
                                value: course.name,
                                child: Text(course.name),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _semester = value!),
                    ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _section,
                decoration: const InputDecoration(
                  labelText: 'Section',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter section' : null,
                onChanged: (value) => _section = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                    value!.contains('@') ? null : 'Invalid email',
                onChanged: (value) => _email = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _password,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _password = value,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _address,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => _address = value,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(_dob == null
                    ? 'Select Date of Birth'
                    : 'DOB: ${_dob!.day}/${_dob!.month}/${_dob!.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _dob ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) setState(() => _dob = date);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
        enabled: false,
      ),
    );
  }
}
