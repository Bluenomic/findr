import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://bjtdjaellqkejacuqnsg.supabase.co';
  static const String supabasePublishableKey =
      'sb_publishable_D0OKjbJYMCyUi7di4MsmpA_mdj1f_Ag';

  static Future<void> initialize() async {
    if (supabaseUrl.contains('YOUR_PROJECT_ID') ||
        supabasePublishableKey.contains('YOUR_ANON_KEY')) {
      debugPrint('Supabase credentials belum diisi. Mode demo aktif.');
      return;
    }

    await Supabase.initialize(
      url: supabaseUrl,
      publishableKey: supabasePublishableKey,
    );
  }

  static bool get isInitialized {
    try {
      return Supabase.instance.isInitialized;
    } catch (_) {
      return false;
    }
  }

  static SupabaseClient get client => Supabase.instance.client;
}

SupabaseClient get supabase => SupabaseConfig.client;
