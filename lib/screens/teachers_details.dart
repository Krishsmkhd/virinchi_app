import 'package:flutter/material.dart';

import '../constant/color_const.dart';

class TeachersDetails extends StatefulWidget {
  const TeachersDetails({super.key});

  @override
  State<TeachersDetails> createState() => _TeachersDetailsState();
}

class _TeachersDetailsState extends State<TeachersDetails> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.buttonColor,
        appBar: AppBar(
          title: const Text('Teachers Details'),
          centerTitle: true,
          backgroundColor: AppColor.buttonColor,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Positioned(
                top: 5,
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    color: Color(0xff0091A4),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 4,
                          color: Colors.black54,
                          offset: Offset(0, 0))
                    ],
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50)),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Wrap(
                            children: [
                              for (int i = 0; i < 4; i++) detailsBuilder(i),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }

  Container detailsBuilder(int index) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.01),
      width: MediaQuery.of(context).size.width * 0.3,
      decoration: BoxDecoration(
          color: const Color(0xffF3F8F9),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: MediaQuery.of(context).size.width * 0.1,
            backgroundImage: const NetworkImage(
                'https://www.kindpng.com/picc/m/451-4517876_default-profile-hd-png-download.png'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          const Text(
            "Teachers detail",
          ),
          const Text("gender")
        ],
      ),
    );
  }
}
