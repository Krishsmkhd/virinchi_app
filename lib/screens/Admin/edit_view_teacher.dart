import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/models/course.dart';
import 'package:school_management_app/models/teacher.dart';
import '../../utils/utils.dart';

class EditViewTeacher extends StatefulWidget {
  final Teacher teacher;

  const EditViewTeacher({super.key, required this.teacher});

  @override
  _EditViewTeacherState createState() => _EditViewTeacherState();
}

class _EditViewTeacherState extends State<EditViewTeacher> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
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
    final teacher = widget.teacher;
    _name = teacher.name;
    _email = teacher.email;
    _imageUrl = teacher.imageUrl;
    _password = teacher.password;

    // Parse existing date of birth
    if (teacher.dob.isNotEmpty) {
      final parts = teacher.dob.split(' ');
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

  Future<void> _udpateTeacher() async {
    if (_formKey.currentState!.validate()) {
      try {
        final data = {
          'name': _name,
          'email': _email,
          'imageUrl': _imageUrl ?? widget.teacher.imageUrl,
          'dob': "${_dob?.day} ${months[_dob!.month - 1]}, ${_dob?.year}",
          'password': _password,
        };

        await FirebaseFirestore.instance
            .collection('teachers')
            .doc(widget.teacher.id)
            .update(data);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Teacher updated successfully')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating teacher: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Teacher'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _udpateTeacher,
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
}
