import 'package:flutter/material.dart' hide Banner;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_management_app/utils/utils.dart';
import 'dart:io';

import '../../models/banner.dart';
import '../../models/feed.dart';
import '../news_feed_details.dart';

class BannerAndFeedManagement extends StatefulWidget {
  const BannerAndFeedManagement({super.key});

  @override
  State<BannerAndFeedManagement> createState() => _BannerAndFeedManagementState();
}

class _BannerAndFeedManagementState extends State<BannerAndFeedManagement> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _addItem() async {
    final type = _tabController.index == 0 ? 'banner' : 'feed';
    final result = await showDialog(
      context: context,
      builder: (context) => type == 'banner' ? AddBannerDialog() : AddFeedDialog(),
    );

    if (result != null) {
      try {
        await _firestore.collection('banners_feeds').add(result.toMap());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${type.capitalize()} added successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding ${type}: $e')),
        );
      } finally {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banner & Feed Management'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: 'Banners', icon: Icon(Icons.collections)),
            Tab(text: 'Feeds', icon: Icon(Icons.feed)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _BannerList(firestore: _firestore),
          _FeedList(firestore: _firestore),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BannerList extends StatelessWidget {
  final FirebaseFirestore firestore;

  const _BannerList({required this.firestore});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('banners_feeds').where('type', isEqualTo: 'banner').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return ErrorView(message: snapshot.error.toString());
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final banners = snapshot.data!.docs.map((doc) => Banner.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

        if (banners.isEmpty) return const EmptyStateView(type: 'banner');

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: banners.length,
          itemBuilder: (context, index) {
            final banner = banners[index];
            return Card(
              child: Stack(
                children: [
                  if (banner.imageUrl.isNotEmpty)
                    Image.network(
                      banner.imageUrl,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final delete = await Utils.showDeleteConfirmationDialog(context);
                        if (delete == null || !delete) return;

                        await firestore.collection('banners_feeds').doc(banner.id).delete();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Banner deleted successfully')),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _FeedList extends StatelessWidget {
  final FirebaseFirestore firestore;

  const _FeedList({required this.firestore});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestore.collection('banners_feeds').where('type', isEqualTo: 'feed').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) return ErrorView(message: snapshot.error.toString());
        if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

        final feeds = snapshot.data!.docs.map((doc) => Feed.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();

        if (feeds.isEmpty) return const EmptyStateView(type: 'feed');

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: feeds.length,
          itemBuilder: (context, index) {
            final feed = feeds[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NewsFeedDetails(feed: feed, adminAccess: true),
                ),
              ),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              feed.title,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(feed.description),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class AddBannerDialog extends StatefulWidget {
  @override
  State<AddBannerDialog> createState() => _AddBannerDialogState();
}

class _AddBannerDialogState extends State<AddBannerDialog> {
  File? _imageFile;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Banner'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () {
              final res = ImagePicker().pickImage(source: ImageSource.gallery);
              res.then((value) {
                if (value != null) {
                  setState(() => _imageFile = File(value.path));
                }
              });
            },
            child: Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                image: _imageFile != null
                    ? DecorationImage(
                        image: FileImage(_imageFile!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: _imageFile == null ? const Icon(Icons.add_photo_alternate) : null,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: _imageFile == null
              ? null
              : () async {
                  setState(() => _isLoading = true);
                  try {
                    final imageUrl = await Utils.uploadSingleImage(_imageFile!.path);
                    if (imageUrl == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Error uploading image')),
                      );
                      return;
                    }

                    Navigator.pop(context, Banner(imageUrl: imageUrl));
                  } finally {
                    setState(() => _isLoading = false);
                  }
                },
          child: _isLoading ? const CircularProgressIndicator() : const Text('Add'),
        ),
      ],
    );
  }
}

class AddFeedDialog extends StatefulWidget {
  @override
  State<AddFeedDialog> createState() => _AddFeedDialogState();
}

class _AddFeedDialogState extends State<AddFeedDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Feed'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Please fill all fields')),
              );
              return;
            }
            Navigator.pop(
              context,
              Feed(
                title: _titleController.text,
                description: _descriptionController.text,
              ),
            );
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}

// Utility extension
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

// Error and Empty State Widgets
class ErrorView extends StatelessWidget {
  final String message;

  const ErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Error: $message'),
    );
  }
}

class EmptyStateView extends StatelessWidget {
  final String type;

  const EmptyStateView({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('No ${type}s available'),
    );
  }
}
