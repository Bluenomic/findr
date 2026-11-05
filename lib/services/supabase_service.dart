import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class SupabaseService {
  static SupabaseClient get _client => SupabaseConfig.client;

  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    final response = await _client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': phone ?? '',
      },
    );

    if (response.user != null) {
      await _client.from('profiles').upsert({
        'id': response.user!.id,
        'full_name': fullName,
        'phone': phone ?? '',
      });
    }

    return response;
  }

  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  static Future<void> signOut() async {
    await _client.auth.signOut();
  }

  static User? get currentUser =>
      SupabaseConfig.isInitialized ? _client.auth.currentUser : null;

  static bool get isAuthenticated => currentUser != null;

  static Future<List<Map<String, dynamic>>> fetchItems({
    String? city,
    String? filter,
    String? search,
  }) async {
    var query = _client.from('items').select().eq('status', 'aktif');

    if (city != null && city.isNotEmpty) {
      query = query.ilike('city', city);
    }

    if (filter == 'Ditemukan') {
      query = query.eq('is_found', true);
    } else if (filter == 'Hilang') {
      query = query.eq('is_found', false);
    }

    if (search != null && search.trim().isNotEmpty) {
      query = query.or(
        'title.ilike.%$search%,description.ilike.%$search%,location.ilike.%$search%',
      );
    }

    final response = await query.order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<String?> uploadPhoto(File file) async {
    try {
      final fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${file.path.split(Platform.pathSeparator).last}';
      final path = 'uploads/$fileName';

      await _client.storage.from('item-photos').upload(path, file);
      return _client.storage.from('item-photos').getPublicUrl(path);
    } catch (e) {
      debugPrint('Gagal mengunggah foto: $e');
      return null;
    }
  }

  static Future<void> createItem({
    required String title,
    required String category,
    required String city,
    required String location,
    required String description,
    required bool isFound,
    String? photoUrl,
  }) async {
    final user = currentUser;
    await _client.from('items').insert({
      'title': title,
      'category': category,
      'city': city,
      'location': location,
      'description': description,
      'is_found': isFound,
      'photo_url': photoUrl,
      'reporter_id': user?.id,
      'reporter_name': user?.userMetadata?['full_name'] ?? 'Anggota Komunitas',
    });
  }

  static Future<void> submitClaim({
    required String itemId,
    required String evidence,
  }) async {
    final user = currentUser;
    if (user == null) throw Exception('Harus masuk untuk mengajukan klaim.');

    await _client.from('claims').insert({
      'item_id': itemId,
      'claimant_id': user.id,
      'claimant_name': user.userMetadata?['full_name'] ?? 'Pengguna Findr',
      'evidence': evidence,
    });
  }
}
