import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:iconsax/iconsax.dart';
import 'package:school_management_app/screens/admin/add_pdf_to_subject.dart';

import '../../constant/color_const.dart';
import '../../utils/utils.dart';
import 'banner_and_feed_management.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
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
                    onTap: () => (Navigator.pushNamed(context, 'addStudent')),
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
                            Text('Add Students', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, 'viewStudent'),
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
                    onTap: () => (Navigator.pushNamed(context, 'addTeacher')),
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
                            Text('Add Teachers', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: InkWell(
                    onTap: () => Navigator.pushNamed(context, 'viewTeacher'),
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
                            Text('View Teachers', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BannerAndFeedManagement())),
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
                            Text('Banners and Feed', textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: InkWell(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddPdfToSubject())),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Icon(
                              Icons.picture_as_pdf,
                              size: 64,
                              color: AppColor.primary,
                            ),
                            SizedBox(height: 16),
                            Text('Add PDF to Subjects', textAlign: TextAlign.center),
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
