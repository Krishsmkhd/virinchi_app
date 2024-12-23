import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:school_management_app/screens/admin/admin_dashboard.dart';
import 'login_page.dart';

import '../constant/color_const.dart';
import 'story_onboarding.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> check() async {
    await Hive.initFlutter();
    await Hive.openBox("settings");
    await Hive.openBox("user_data");
    await Hive.openBox("auth");
    final firstTimeInit = await Hive.box("settings").get("firstTimeInit", defaultValue: true);

    final isLoggedIn = await Hive.box("auth").get("type");

    if (firstTimeInit) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const StoryOnboarding()));
    } else if (isLoggedIn != null) {
      switch (isLoggedIn) {
        case "admin":
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AdminDashboard()));
          break;
        case "teacher":
          Navigator.pushReplacementNamed(context, 'teacherDashboard', arguments: await Hive.box("auth").get("id"));
          break;
        case "student":
          Navigator.pushReplacementNamed(context, 'newDashboard', arguments: await Hive.box("auth").get("id"));
          break;
        default:
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
      }
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 1), () {
      check();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(alignment: Alignment.center, children: [
        Positioned(
          top: MediaQuery.of(context).size.height * 0.01,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/logo.png"),
            )),
          ),
        ),
        Positioned(
          bottom: MediaQuery.of(context).size.height * 0.15,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.16,
            height: MediaQuery.of(context).size.height * 0.08,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColor.sliderColor),
            ),
          ),
        ),
      ]),
    );
  }
}
