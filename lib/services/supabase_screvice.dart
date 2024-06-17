import 'package:supabase_flutter/supabase_flutter.dart';



class SupabaseConfig {
  
  static const String supabaseUrl = 'https://kxgcasaqcnjksiodpxbr.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt4Z2Nhc2FxY25qa3Npb2RweGJyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTg1NTMwNzcsImV4cCI6MjAzNDEyOTA3N30.OZor3q3BTeGwIFrmJmBEhcBNN3T3e5FRVvLfRfOGoNk';

  static final supabase = SupabaseClient(supabaseUrl, supabaseAnonKey);

  static init() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }
}
