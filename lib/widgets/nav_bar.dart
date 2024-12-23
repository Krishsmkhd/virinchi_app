import 'package:flutter/material.dart';

import '../constant/color_const.dart';


class NavBar extends StatefulWidget {
  final List info;
  final int page;
  const NavBar({super.key, required this.info, required this.page});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    int pageIndex = widget.page;
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.01,
          bottom: MediaQuery.of(context).size.height * 0.01),
      height: MediaQuery.of(context).size.height * 0.11,
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: AppColor.buttonColor, width: 1.2),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 0;
              });
              Navigator.pushNamed(context, 'calendar', arguments: widget.info);
            },
            icon: pageIndex == 0
                ? const Icon(
                    Icons.calendar_month,
                    color: Colors.blue,
                    size: 35,
                  )
                : const Icon(
                    Icons.calendar_month_outlined,
                    color: Colors.black,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 1;
              });
              Navigator.pushNamed(context, 'dashboard', arguments: widget.info);
            },
            icon: pageIndex == 1
                ? const Icon(
                    Icons.class_,
                    color: Colors.blue,
                    size: 35,
                  )
                : const Icon(
                    Icons.class_outlined,
                    color: Colors.black,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 2;
              });
              Navigator.pushNamed(context, 'dashboard', arguments: widget.info);
            },
            icon: pageIndex == 2
                ? const Icon(
                    Icons.home,
                    color: Colors.blue,
                    size: 35,
                  )
                : const Icon(
                    Icons.home_outlined,
                    color: Colors.black,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 3;
              });
              Navigator.pushNamed(context, 'dashboard', arguments: widget.info);
            },
            icon: pageIndex == 3
                ? const Icon(
                    Icons.notifications_active,
                    color: Colors.blue,
                    size: 35,
                  )
                : const Icon(
                    Icons.notifications_outlined,
                    color: Colors.black,
                    size: 35,
                  ),
          ),
          IconButton(
            enableFeedback: false,
            onPressed: () {
              setState(() {
                pageIndex = 4;
              });
              Navigator.pushNamed(context, 'profilePage',
                  arguments: widget.info);
            },
            icon: pageIndex == 4
                ? const Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 35,
                  )
                : const Icon(
                    Icons.person_outline,
                    color: Colors.black,
                    size: 35,
                  ),
          ),
        ],
      ),
    );
  }
}
