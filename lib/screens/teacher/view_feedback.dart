import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/color_const.dart';
import '../../models/feedback.dart';

class ViewFeedback extends StatefulWidget {
  const ViewFeedback({super.key});

  @override
  State<ViewFeedback> createState() => _ViewFeedbackState();
}

class _ViewFeedbackState extends State<ViewFeedback> {
  List<FeedbackModel> feedbacks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getFeedback();
  }

  void getFeedback() {
    setState(() {
      isLoading = true;
    });
    FirebaseFirestore.instance.collection("enquiry").get().then((value) => {
          setState(() {
            for (var element in value.docs) {
              feedbacks.add(FeedbackModel.fromMap(element.data()));
            }
            isLoading = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('FeedBack Details'),
        centerTitle: true,
        backgroundColor: AppColor.primary,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                Expanded(
                  child: SingleChildScrollView(
                    child: Wrap(
                      children: [
                        for (int i = 0; i < feedbacks.length; i++)
                          detailsBuilder(i),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Container detailsBuilder(int index) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
      margin: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      height: MediaQuery.of(context).size.height * 0.5,
      decoration: BoxDecoration(
          color: const Color(0xffF3F8F9),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "Feedback Title",
            style: GoogleFonts.lexend(
                textStyle: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold)),
          ),
          Divider(
            indent: MediaQuery.of(context).size.width * 0.05,
            endIndent: MediaQuery.of(context).size.width * 0.05,
            thickness: 1,
            color: Colors.black,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Student Name: ",
                style: GoogleFonts.lexend(
                    textStyle: const TextStyle(
                        fontSize: 14.0, fontWeight: FontWeight.bold)),
              ),
              Text(feedbacks.elementAt(index).studentName)
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Problem/Queries: ",
            style: GoogleFonts.lexend(
                textStyle: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold)),
          ),
          Text(feedbacks.elementAt(index).enquiry),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Suggestions: ",
            style: GoogleFonts.lexend(
                textStyle: const TextStyle(
                    fontSize: 14.0, fontWeight: FontWeight.bold)),
          ),
          Text(feedbacks.elementAt(index).suggestion)
        ],
      ),
    );
  }
}
