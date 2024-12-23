import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart' hide Banner;

import '../../../models/banner.dart';
import '../../admin/banner_and_feed_management.dart';

StreamBuilder banner(BuildContext context) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance.collection('banners_feeds').where('type', isEqualTo: 'banner').snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) return ErrorView(message: snapshot.error.toString());
      if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

      final banner = snapshot.data!.docs.map((doc) => Banner.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
      if (banner.isEmpty) return const EmptyStateView(type: 'banner');

      return SizedBox(
        height: 200,
        width: double.infinity,
        child: CarouselSlider.builder(
            itemCount: banner.length,
            itemBuilder: (context, index, realIndex) {
              return CachedNetworkImage(
                width: double.infinity,
                imageUrl: banner[index].imageUrl,
                fit: BoxFit.cover,
              );
            },
            options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 8),
              aspectRatio: 16 / 9,
              enlargeCenterPage: true,
            )),
      );
    },
  );
}
