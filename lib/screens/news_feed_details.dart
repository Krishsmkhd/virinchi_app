import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:school_management_app/utils/utils.dart';

import '../constant/color_const.dart';
import '../models/feed.dart';

class NewsFeedDetails extends StatefulWidget {
  final Feed feed;
  final bool adminAccess;
  const NewsFeedDetails({super.key, required this.feed, this.adminAccess = false});

  @override
  State<NewsFeedDetails> createState() => _NewsFeedDetailsState();
}

class _NewsFeedDetailsState extends State<NewsFeedDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details'),
        elevation: 0,
        actions: [
          if (widget.adminAccess)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white, size: 24),
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) {
                    final titleController = TextEditingController(text: widget.feed.title);
                    final descriptionController = TextEditingController(text: widget.feed.description);
                    return AlertDialog(
                      title: const Text('Edit Feed'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextField(
                            controller: titleController,
                            decoration: const InputDecoration(
                              labelText: 'Title',
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: descriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Description',
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            final title = titleController.text;
                            final description = descriptionController.text;

                            if (title.isEmpty || description.isEmpty) {
                              ScaffoldMessenger.of(context).clearSnackBars();
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text(
                                'Please fill all fields',
                                style: TextStyle(color: Colors.white),
                              )));
                              return;
                            }

                            await FirebaseFirestore.instance.collection('banners_feeds').doc(widget.feed.id).update({
                              'title': title,
                              'description': description,
                            });
                            if (!context.mounted) return;

                            Navigator.pop(context);
                          },
                          child: const Text('Update'),
                        ),
                      ],
                    );
                  },
                );
                if (!context.mounted) return;
                Navigator.pop(context);
              },
            ),
          if (widget.adminAccess)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.white, size: 24),
              onPressed: () async {
                final delete = await Utils.showDeleteConfirmationDialog(context);
                if (delete == null || !delete) return;
                await FirebaseFirestore.instance.collection('banners_feeds').doc(widget.feed.id).delete();
                if (!context.mounted) return;
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.feed.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.feed.description,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
