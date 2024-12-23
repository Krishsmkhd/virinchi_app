import 'package:flutter/material.dart';
import 'package:school_management_app/constant/color_const.dart';
import 'package:school_management_app/models/student.dart';

import '../../../widgets/text_normal.dart';

class ProfileInfo extends StatelessWidget {
  final Student student;
  const ProfileInfo({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.96,
          decoration: BoxDecoration(color: AppColor.primary.withAlpha(100), borderRadius: BorderRadius.circular(10)),
          child: Container(
              margin: EdgeInsets.all(MediaQuery.of(context).size.height * 0.005),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  InfoRow(title: "Semester", subtitle: student.semester.toString()),
                  InfoRow(title: "Section", subtitle: student.section),
                  InfoRow(title: "Email", subtitle: student.email),
                  InfoRow(title: "Address", subtitle: student.address),
                  InfoRow(title: "Date of Birth", subtitle: student.dob),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                ],
              )),
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  const InfoRow({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5),
      child: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: TextNormal(
              text: title,
              size: 15,
              color: Colors.black,
              textAlign: TextAlign.left,
            ),
          ),
          Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4),
              child: TextNormal(
                text: subtitle,
                size: 15,
                color: Colors.black,
                textAlign: TextAlign.left,
              )),
        ],
      ),
    );
  }
}
