import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../models/routine.dart';
import '../../widgets/text_normal.dart';
import '../../widgets/text_title.dart';
import '../../constant/color_const.dart';

class SubjectRoutine extends StatefulWidget {
  const SubjectRoutine({super.key});

  @override
  State<SubjectRoutine> createState() => _SubjectRoutineState();
}

class _SubjectRoutineState extends State<SubjectRoutine> {
  List<Routine> routine = [];
  var isLoading = true;
  bool first = true;
  String selectedDay = "Sunday";

  void getRoutine(int class_) {
    FirebaseFirestore.instance.collection("routines").where("class", isEqualTo: class_).get().then((value) => {
          setState(() {
            for (var element in value.docs) {
              routine.add(Routine.fromMap(element.data()));
            }
            isLoading = false;
          })
        });
  }

  @override
  Widget build(BuildContext context) {
    final int class_ = ModalRoute.of(context)!.settings.arguments as int;
    if (first) {
      getRoutine(class_);
      first = false;
    }
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Subject Routine', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              // Dropdown to select day
              Container(
                margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.04),
                decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedDay,
                    icon: const Icon(Icons.arrow_drop_down),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDay = newValue!;
                      });
                    },
                    items: <String>[
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: TextNormal(text: value, size: 16),
                      );
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Row(children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.04),
              ]),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.96,
                  decoration: BoxDecoration(color: const Color(0xff7BA9B1), borderRadius: BorderRadius.circular(10)),
                  child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(boxShadow: const [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 5,
                        )
                      ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: Column(children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: const [
                          TextTitle(text: "Subject", size: 16),
                          TextTitle(text: "Time", size: 16),
                        ]),
                        Divider(
                          thickness: MediaQuery.of(context).size.height * 0.001,
                          color: AppColor.buttonColor,
                        ),
                        for (int i = 0; i < routine.length; i++) ...[
                          if (routine[i].day == selectedDay) ...[
                            for (int j = 0; j < routine[i].subjects.length; j++) rowBuilder(i, routine[i].subjects[j]),
                          ]
                        ],
                      ])),
                ),
              ),
            ]),
    );
  }

  Container rowBuilder(int i, Subject subject) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.height * 0.04, vertical: MediaQuery.of(context).size.height * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.4),
            child: TextNormal(text: subject.name, size: 14, color: Colors.black, textAlign: TextAlign.start),
          ),
          TextNormal(
              text: "${subject.startTime.format(context)} - ${subject.endTime.format(context)}",
              size: 14,
              color: Colors.black,
              textAlign: TextAlign.start),
        ],
      ),
    );
  }
}
