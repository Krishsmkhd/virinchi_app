import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../constant/color_const.dart';
import '../widgets/text_normal.dart';
import '../widgets/text_title.dart';

class StoryOnboarding extends StatefulWidget {
  const StoryOnboarding({super.key});

  @override
  State<StoryOnboarding> createState() => _StoryOnboardingState();
}

class _StoryOnboardingState extends State<StoryOnboarding> {
  List titles = [
    "Assignment",
    "Results",
    "Identity Card",
    "News Feed and Banner",
  ];

  List subTitles = [
    "Get the Assignment in hand",
    "View your results",
    "View your Identity Card",
    "View latest news to stay updated",
  ];
  final pageController = PageController();
  int? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    pageController.addListener(() {
      setState(() {
        _currentPage = pageController.page?.toInt();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Positioned(
            //     child: Container(
            //   decoration: const BoxDecoration(
            //       image: DecorationImage(
            //     image: AssetImage("assets/images/onboarding_background.png"),
            //     fit: BoxFit.cover,
            //   )),
            // )),
            Positioned(
                child: Container(
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.width * 0.2),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      children: [
                        for (int i = 0; i < titles.length; i++) _buildPage(title: titles[i], subTitle: subTitles[i], page: i),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.12,
              left: 0,
              right: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.53,
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2),
                child: TextButton(
                    onPressed: () async {
                      if (_currentPage == 3) {
                        var setting = Hive.box("settings");
                        setting.put("firstTimeInit", false);

                        Navigator.pushReplacementNamed(
                          context,
                          "loginPage",
                        );
                      } else {
                        pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                      }
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: _currentPage == titles.length - 1 ? const Color(0xff00606C) : Colors.transparent,
                        shape: RoundedRectangleBorder(
                            side: BorderSide(color: _currentPage == titles.length - 1 ? Colors.transparent : AppColor.buttonColor, width: 2),
                            borderRadius: BorderRadius.circular(30))),
                    child: Text(_currentPage == titles.length - 1 ? "Get Started" : "Next",
                        style: TextStyle(color: _currentPage == titles.length - 1 ? Colors.white : AppColor.buttonColor, fontSize: 20))),
              ),
            ),
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.05,
              left: 0,
              right: 0,
              child: Center(
                child: SmoothPageIndicator(
                    controller: pageController,
                    count: 4,
                    effect: const ExpandingDotsEffect(
                      spacing: 5,
                      dotColor: AppColor.primary,
                    ),
                    onDotClicked: (index) =>
                        pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut)),
              ),
            ),
            if (_currentPage != 3)
              Positioned(
                top: MediaQuery.of(context).size.height * 0.08,
                right: MediaQuery.of(context).size.width * 0.04,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.2,
                  margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.2),
                  child: TextButton(
                      onPressed: () {
                        pageController.animateToPage(3, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      },
                      style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              side: const BorderSide(color: AppColor.buttonColor, width: 2), borderRadius: BorderRadius.circular(30))),
                      child: Text("Skip", style: TextStyle(color: AppColor.buttonColor, fontSize: MediaQuery.of(context).size.height * 0.02))),
                ),
              ),
          ],
        ));
  }

  _buildPage({title, subTitle, required int page}) {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.25,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/onboarding$page.png"),
            )),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          TextTitle(
            text: title,
            size: 20,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.01),
          TextNormal(
            text: subTitle,
            size: 18,
          ),
        ],
      ),
    );
  }
}
