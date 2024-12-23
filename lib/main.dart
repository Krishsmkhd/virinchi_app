import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:school_management_app/constant/color_const.dart';
import 'package:school_management_app/screens/result/result.dart';
import 'package:school_management_app/screens/teacher/give_result.dart';
import 'package:school_management_app/screens/teacher/view_result.dart';
import 'firebase_options.dart';
import 'screens/admin/add_routine.dart';
import 'screens/admin/add_students.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/admin/view_student.dart';
import 'screens/admin/add_teacher.dart';
import 'screens/admin/view_teacher.dart';
import 'screens/dashboard/dashboard_new.dart';
import 'screens/splash_screen.dart';
import 'screens/teacher/dashboard/teacher_dashboard.dart';
import 'screens/teacher/view_students.dart';
import 'screens/teachers_details.dart';
import 'screens/routine/routine.dart';
import 'screens/login_page.dart';
import 'screens/story_onboarding.dart';
import 'screens/teacher/view_feedback.dart';
import 'screens/view_teachers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await Hive.openBox("settings");
  await Hive.openBox("api_data");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    EasyLoading.instance
      ..maskType = EasyLoadingMaskType.black
      ..userInteractions = false;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: 'splashScreen',
      builder: EasyLoading.init(),
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: AppColor.primary,
            iconTheme: IconThemeData(color: Colors.white, size: 24),
            titleTextStyle: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            actionsIconTheme: IconThemeData(color: Colors.white, size: 32),
          ),
          inputDecorationTheme: InputDecorationTheme(
            fillColor: Colors.grey.shade200,
            focusedBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: AppColor.inputDecorationColor, width: 2),
            ),
            enabledBorder: OutlineInputBorder(),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              foregroundColor: WidgetStatePropertyAll(Colors.white),
              fixedSize: WidgetStatePropertyAll(const Size(210, 48)),
              shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )),
              backgroundColor: WidgetStatePropertyAll(AppColor.primary),
            ),
          )),
      routes: {
        'splashScreen': (context) => const SplashScreen(),
        'storyOnboarding': (context) => const StoryOnboarding(),
        'loginPage': (context) => const LoginPage(),
        'newDashboard': (context) => const DashboardNew(),
        'teachersDetails': (context) => const TeachersDetails(),
        'subjectRoutine': (context) => const SubjectRoutine(),
        'viewFeedback': (context) => const ViewFeedback(),
        'teacherDashboard': (context) => const TeacherDashboard(),
        'adminDashboard': (context) => const AdminDashboard(),
        'addStudent': (context) => const AddStudentForm(),
        'viewStudent': (context) => const StudentListScreen(),
        'addTeacher': (context) => const AddTeacherForm(),
        'viewTeacher': (context) => const TeacherListScreen(),
        'resultPage': (context) => const ResultPage(),
        'addResult': (context) => const GiveResult(),
        'addRoutine': (context) => const AddRoutineForm(),
        'viewResults': (context) => const ViewResult(),
        'viewStudents': (context) => const ViewStudents(),
        'viewTeachers': (context) => const ViewTeachers(),
      },
    );
  }
}
