import 'package:flutter/material.dart';

class AppColors {
  static const green = Color(0xFF176B46);
  static const buttonGreen = Color(0xFF356D50);
  static const darkGreen = Color(0xFF19382F);
  static const ink = Color(0xFF173D30);
  static const muted = Color(0xFF718078);
  static const cream = Color(0xFFF5F7F2);
  static const lime = Color(0xFFE1F3B5);
  static const badgeBg = Color(0xFFE8EEE4);
  static const divider = Color(0xFFE3E9DF);
  static const lostBadge = Color(0xFF995126);
  static const danger = Color(0xFFAE4439);
  static const photoBg = Color(0xFFEAEDE7);
}

class Item {
  final String? id;
  final String title;
  final String category;
  final String location;
  final bool found;
  final String photo;
  final String description;
  final String city;
  final String? reporterId;
  final String? reporterName;
  final String? reporterPhone;
  final DateTime? createdAt;

  const Item({
    this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.found,
    required this.photo,
    required this.description,
    this.city = 'Balikpapan',
    this.reporterId,
    this.reporterName,
    this.reporterPhone,
    this.createdAt,
  });

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id']?.toString(),
      title: map['title'] as String? ?? '',
      category: map['category'] as String? ?? 'Lainnya',
      location: map['location'] as String? ?? '',
      found: (map['is_found'] as bool?) ?? true,
      photo: (map['photo_url'] as String?) ?? '',
      description: map['description'] as String? ?? '',
      city: map['city'] as String? ?? 'Balikpapan',
      reporterId: map['reporter_id']?.toString(),
      reporterName: map['reporter_name'] as String?,
      reporterPhone: map['reporter_phone'] as String?,
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'category': category,
      'location': location,
      'is_found': found,
      'photo_url': photo,
      'description': description,
      'city': city,
      if (reporterId != null) 'reporter_id': reporterId,
      if (reporterName != null) 'reporter_name': reporterName,
      if (reporterPhone != null) 'reporter_phone': reporterPhone,
    };
  }
}

final List<Item> sampleItems = [];

final ValueNotifier<bool> isSignedInNotifier = ValueNotifier<bool>(false);
