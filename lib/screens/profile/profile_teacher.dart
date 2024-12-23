import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_management_app/models/teacher.dart';
import '../../utils/utils.dart';
import '../../widgets/text_title.dart';
import 'widget/profile_teacher_info.dart';

class ProfileTeacher extends StatefulWidget {
  final Teacher teacher;
  const ProfileTeacher({super.key, required this.teacher});

  @override
  State<ProfileTeacher> createState() => _ProfileTeacherState();
}

class _ProfileTeacherState extends State<ProfileTeacher> {
  var info = [];
  @override
  void initState() {
    super.initState();
  }

  int pageIndex = 4;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Row(
                children: [
                  CircleAvatar(radius: 32, backgroundImage: NetworkImage(widget.teacher.imageUrl)),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextTitle(text: widget.teacher.name, size: 20),
                      TextTitle(
                        text: widget.teacher.email,
                        size: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade500,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              ProfileTeacherInfo(teacher: widget.teacher),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final logout = await Utils.showLogoutConfirmation(context);
                    if (logout == null || !logout) return;

                    final box = Hive.box("auth");
                    box.delete("type");
                    box.delete("id");
                    box.delete("email");
                    box.delete("password");

                    Navigator.pushReplacementNamed(context, "loginPage");
                  },
                  child: TextTitle(text: "Logout", size: 16, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
