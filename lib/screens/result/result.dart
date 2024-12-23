import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import '../../constant/color_const.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool loading = false;
  Box box = Hive.box("user_data");
  List<Map> marks = [];

  @override
  void initState() {
    getMarks();
    super.initState();
  }

  getMarks() async {
    String userId = box.get("userId");
    setState(() {});
    await FirebaseFirestore.instance.collection("students").doc(userId).collection("results").get().then((value) {
      for (var item in value.docs) {
        marks.add(item.data());
      }
    });
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColor.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  marks.isEmpty
                      ? SizedBox(height: MediaQuery.of(context).size.height * 0.8, child: const Center(child: Text("No Result Found")))
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: marks.length,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                title: Text(marks[index]["subject"]),
                                trailing: Text(marks[index]["marks"]),
                              ),
                            );
                          }),
                ],
              ),
            ),
    );
  }
}
