import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:iconsax/iconsax.dart';
import 'package:school_management_app/constant/color_const.dart';
import 'package:school_management_app/screens/news_feed_details.dart';
import 'package:school_management_app/screens/result_new/result_page.dart';
import 'package:school_management_app/screens/subject/subject_page.dart';
import '../../models/feed.dart';
import '../admin/banner_and_feed_management.dart';
import '../assignment/assignment_body.dart';
import '../profile/profile.dart';
import 'widget/banner.dart';

import '../../models/student.dart';

class DashboardNew extends StatefulWidget {
  const DashboardNew({super.key});

  @override
  State<DashboardNew> createState() => _DashboardNewState();
}

class _DashboardNewState extends State<DashboardNew> {
  late Student student;

  bool loading = true;

  getStudentInfo(String userId) async {
    final res = await FirebaseFirestore.instance.collection("students").doc(userId).get();
    setState(() {
      student = Student.fromMap(res.data()!, userId);
      box.put("userId", userId);
      box.put("studentName", student.name);
    });

    setState(() {
      loading = false;
    });
  }

  Box box = Hive.box("user_data");
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      String userId = ModalRoute.of(context)!.settings.arguments as String;
      getStudentInfo(userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const Scaffold(body: Center(child: CircularProgressIndicator()))
        : Scaffold(
            backgroundColor: Colors.grey[200],
            drawer: IDCardPage(student: student),
            body: IndexedStack(
              index: _selectedIndex,
              children: [
                Homescreen(loading: loading, name: student.name),
                SubjectPage(student: student),
                AssignmentBody(student: student),
                ResultPage(student: student),
                ProfilePage(student: student),
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
                BottomNavigationBarItem(icon: Icon(Iconsax.book), label: "Subject"),
                BottomNavigationBarItem(icon: Icon(Iconsax.archive), label: "Assignment"),
                BottomNavigationBarItem(icon: Icon(Iconsax.note), label: "Result"),
                BottomNavigationBarItem(icon: Icon(Iconsax.user), label: "Profile"),
              ],
            ),
          );
  }
}

class IDCardPage extends StatelessWidget {
  final Student student;
  const IDCardPage({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      width: MediaQuery.sizeOf(context).width,
      child: Column(
        children: [
          AppBar(
            title: const Text('Student Identity Card'),
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
                    backgroundImage: NetworkImage(student.imageUrl),
                  ),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                  Text(student.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                  Text(student.matrixNumber, style: TextStyle(fontSize: 16)),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                  RichText(
                      text: TextSpan(style: TextStyle(color: Colors.black), children: [
                    TextSpan(text: "Address: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextSpan(text: student.address, style: TextStyle(fontSize: 16)),
                  ])),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                  RichText(
                      text: TextSpan(style: TextStyle(color: Colors.black), children: [
                    TextSpan(text: "Date of Birth: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextSpan(text: student.dob, style: TextStyle(fontSize: 16)),
                  ])),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                  RichText(
                      text: TextSpan(style: TextStyle(color: Colors.black), children: [
                    TextSpan(text: "Semester: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextSpan(text: student.semester, style: TextStyle(fontSize: 16)),
                  ])),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.01),
                  RichText(
                      text: TextSpan(style: TextStyle(color: Colors.black), children: [
                    TextSpan(text: "Section: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    TextSpan(text: student.section, style: TextStyle(fontSize: 16)),
                  ])),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.05),
                  RichText(
                      text: TextSpan(style: TextStyle(color: Colors.black), children: [
                    TextSpan(text: "Valid upto: ", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    TextSpan(text: '2025/04/06', style: TextStyle(fontSize: 12)),
                  ])),
                  SizedBox(height: MediaQuery.sizeOf(context).height * 0.02),
                ],
              ),
            ),
          ),
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
