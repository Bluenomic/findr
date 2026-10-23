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
  final String title;
  final String category;
  final String location;
  final bool found;
  final String photo;
  final String description;
  final String city;

  const Item({
    required this.title,
    required this.category,
    required this.location,
    required this.found,
    required this.photo,
    required this.description,
    this.city = 'Balikpapan',
  });
}

final List<Item> sampleItems = [
  const Item(
    title: 'Dompet kulit cokelat',
    category: 'Dompet',
    location: 'Jalan Jenderal Sudirman',
    found: true,
    photo: 'assets/images/sample_wallet.webp',
    description: 'Dompet lipat Fossil berwarna cokelat dengan jahitan di tepinya.',
    city: 'Balikpapan',
  ),
  const Item(
    title: 'Headphone wireless',
    category: 'Elektronik',
    location: 'Jalan Ahmad Yani',
    found: false,
    photo: 'assets/images/sample_headphone.jpg',
    description: 'Headphone wireless biru dengan bantalan telinga empuk.',
    city: 'Balikpapan',
  ),
  const Item(
    title: 'Kunci motor Honda',
    category: 'Kunci',
    location: 'Area parkir Sepinggan',
    found: true,
    photo: 'assets/images/sample_key.jpg',
    description: 'Kunci Honda dengan gantungan karabiner hitam.',
    city: 'Balikpapan',
  ),
  const Item(
    title: 'Tumbler hijau',
    category: 'Lainnya',
    location: 'Kafe di kawasan Klandasan',
    found: false,
    photo: 'assets/images/sample_tumbler.jpg',
    description: 'Botol AquaFlask hijau dengan pegangan dan tali hitam.',
    city: 'Balikpapan',
  ),
];

final ValueNotifier<bool> isSignedInNotifier = ValueNotifier<bool>(true);
