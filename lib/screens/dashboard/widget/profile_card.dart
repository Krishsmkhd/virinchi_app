import 'package:flutter/material.dart';
import '../../../models/student.dart';
import '../../../widgets/text_title.dart';
import '../../profile/profile.dart';

InkWell profileCard(BuildContext context, Student student) {
  return InkWell(
    onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfilePage(student: student),
        )),
    child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 2,
              spreadRadius: 1,
            ),
          ],
        ),
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextTitle(
                      text: student.name,
                      size: 16,
                      fontWeight: FontWeight.w700,
                    ),
                    TextTitle(
                      text: student.dob,
                      size: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    TextTitle(
                      text: student.address,
                      size: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ],
                ),
                Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Image.network(student.imageUrl, height: 80, width: 80, fit: BoxFit.cover),
                )
              ],
            )
          ],
        )),
  );
}
