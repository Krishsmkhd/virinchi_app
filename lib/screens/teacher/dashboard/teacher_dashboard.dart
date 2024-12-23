import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:iconsax/iconsax.dart';
import 'package:school_management_app/constant/color_const.dart';
import 'package:school_management_app/screens/teacher/view_assignment.dart';

import '../../../models/feed.dart';
import '../../../models/teacher.dart';
import '../../admin/banner_and_feed_management.dart';
import '../../dashboard/widget/banner.dart';
import '../../news_feed_details.dart';
import '../../profile/profile_teacher.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  late Teacher teacher;
  bool loading = true;

  getTeacherInfo(String userId) async {
    final res = await FirebaseFirestore.instance.collection("teachers").doc(userId).get();
    teacher = Teacher.fromMap(res.data()!, userId);
    box.put("userId", userId);
    box.put("teacherName", teacher.name);

    setState(() {
      loading = false;
    });
  }

  Box box = Hive.box("user_data");
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      String userId = ModalRoute.of(context)!.settings.arguments as String;
      getTeacherInfo(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            backgroundColor: Colors.grey[200],
            drawer: TeacherIDCardPage(teacher: teacher),
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                Homescreen(loading: loading, name: teacher.name),
                ViewAssignment(teacher: teacher),
                ProfileTeacher(teacher: teacher),
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedIconTheme: const IconThemeData(color: Colors.grey),
              selectedIconTheme: const IconThemeData(color: AppColor.primary),
              selectedFontSize: 12,
              selectedItemColor: AppColor.primary,
              unselectedItemColor: Colors.grey,
              showUnselectedLabels: true,
              currentIndex: _selectedIndex,
              onTap: (value) => setState(() => _selectedIndex = value),
              items: const [
                BottomNavigationBarItem(icon: Icon(Iconsax.home), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Iconsax.archive), label: "Assignment"),
                BottomNavigationBarItem(icon: Icon(Iconsax.user), label: "Profile"),
              ],
            ),
          );
  }
}

class Homescreen extends StatelessWidget {
  const Homescreen({
    super.key,
    required this.loading,
    required this.name,
  });

  final bool loading;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: RichText(
            text: const TextSpan(children: [
          TextSpan(text: 'Virinchi ', style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.w300)),
          TextSpan(text: "App", style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600))
        ])),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              loading
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          "Welcome, $name",
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 14),
                      ],
                    ),
              banner(context),
              SizedBox(height: 20),
              Text('News Feed', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('banners_feeds').where('type', isEqualTo: 'feed').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) return ErrorView(message: snapshot.error.toString());
                  if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

                  final feed = snapshot.data!.docs.map((doc) => Feed.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

                  if (feed.isEmpty) return const EmptyStateView(type: 'feed');

                  return ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(height: 10),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: feed.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewsFeedDetails(feed: feed.elementAt(index)))),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        title: Text(feed.elementAt(index).title),
                        subtitle: Text(
                          feed.elementAt(index).description,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TeacherIDCardPage extends StatelessWidget {
  final Teacher teacher;
  const TeacherIDCardPage({
    super.key,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          AppBar(
            title: const Text('Teacher Identity Card'),
            automaticallyImplyLeading: false,
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SizedBox(height: 60),
          Card(
            color: Colors.white,
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                  SizedBox(
                    height: 10,
                    width: MediaQuery.sizeOf(context).width * 0.8,
                  ),
                  Image.asset("assets/images/logo.png", width: 200),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(teacher.imageUrl),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                  Text(teacher.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                  RichText(
                      text: TextSpan(style: TextStyle(color: Colors.black), children: [
                    TextSpan(text: "Email: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextSpan(text: teacher.email, style: TextStyle(fontSize: 16)),
                  ])),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                  RichText(
                      text: TextSpan(style: TextStyle(color: Colors.black), children: [
                    TextSpan(text: "Subject: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextSpan(text: teacher.subject, style: TextStyle(fontSize: 16)),
                  ])),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.06),
                  RichText(
                      text: TextSpan(style: TextStyle(color: Colors.black), children: [
                    TextSpan(text: "Valid upto: ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    TextSpan(text: '2025/04/06', style: TextStyle(fontSize: 12)),
                  ])),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
