import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../constant/color_const.dart';

class TabBuilder extends StatelessWidget {
  final String class_;
  const TabBuilder({super.key, required this.class_});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: MediaQuery.of(context).size.height * 0.008),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        tabBuilder(context, Icon(Iconsax.book, color: AppColor.primary, size: MediaQuery.of(context).size.width * 0.12), "Assignments", "assignment",
            arguments: class_),
      ]),
    ]);
  }

  Column tabBuilder(BuildContext context, Icon icon, String text, String route, {Object? arguments}) {
    return Column(
      children: [
        InkWell(
          onTap: () => Navigator.pushNamed(context, route, arguments: arguments),
          child: Card(
            elevation: 0,
            // color: DarkMode.isDarkMode ? Colors.black : Colors.white10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(color: Colors.black),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                    width: MediaQuery.of(context).size.width * 0.1,
                    child: IconButton(
                        padding: const EdgeInsets.all(0),
                        // padding: EdgeInsets.all(3.0),
                        onPressed: () {
                          Navigator.pushNamed(context, route, arguments: arguments);
                        },
                        icon: icon,
                        color: Colors.black),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.015, fontFamily: "Lato", fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
