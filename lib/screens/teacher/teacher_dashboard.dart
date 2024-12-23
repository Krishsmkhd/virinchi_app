import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:school_management_app/utils/utils.dart';

import '../../constant/color_const.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teachers Dashboard'),
        centerTitle: true,
        backgroundColor: AppColor.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Iconsax.logout_1),
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
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, 'viewStudents'),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Icon(
                              Icons.add_box,
                              size: 64,
                              color: AppColor.primary,
                            ),
                            SizedBox(height: 16),
                            Text('View Students', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: InkWell(
                    onTap: () => (Navigator.pushNamed(context, 'viewFeedback')),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Icon(
                              Icons.feedback,
                              size: 64,
                              color: AppColor.primary,
                            ),
                            SizedBox(height: 16),
                            Text('View Feedback', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, 'giveAssignment'),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Icon(
                              Icons.add_box,
                              size: 64,
                              color: AppColor.primary,
                            ),
                            SizedBox(height: 16),
                            Text('Give Assignment', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, 'viewAssignment'),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Icon(
                              Icons.view_compact_alt_outlined,
                              size: 64,
                              color: AppColor.primary,
                            ),
                            SizedBox(height: 16),
                            Text('View Assignment', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, 'addResult'),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Icon(
                              Icons.add,
                              size: 64,
                              color: AppColor.primary,
                            ),
                            SizedBox(height: 16),
                            Text('Add Result', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, 'viewResults'),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Icon(
                              Icons.view_array,
                              size: 64,
                              color: AppColor.primary,
                            ),
                            SizedBox(height: 16),
                            Text('View Results', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
