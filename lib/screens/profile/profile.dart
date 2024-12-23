import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:school_management_app/constant/color_const.dart';
import 'package:school_management_app/models/student.dart';
import '../../utils/utils.dart';
import 'widget/profile_info.dart';
import '../../widgets/text_title.dart';

class ProfilePage extends StatefulWidget {
  final Student student;
  const ProfilePage({super.key, required this.student});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),
              Row(
                children: [
                  CircleAvatar(radius: 32, backgroundImage: NetworkImage(widget.student.imageUrl)),
                  SizedBox(width: MediaQuery.of(context).size.width * 0.03),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextTitle(text: widget.student.name, size: 20),
                      TextTitle(
                        text: widget.student.email,
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  color: AppColor.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        TextTitle(
                            text: "${int.parse(widget.student.semester.split(" (").first.split(" ").last) * 20}/160",
                            size: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primary),
                        TextTitle(text: 'Credit earns', size: 16, color: AppColor.primary),
                      ],
                    ),
                    Column(
                      children: [
                        TextTitle(
                            text: widget.student.semester.split('(').last.split(')').first.split(" ").last,
                            size: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColor.primary),
                        TextTitle(text: 'Year student', size: 16, color: AppColor.primary),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              ProfileInfo(student: widget.student),
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
