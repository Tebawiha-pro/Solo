import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() async {
  await Supabase.initialize(
    url: 'https://mwrxecqizhuumiyjwpzo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.[STRIPPED 127 bytes].QUD2ApGMuREdk4rMqY6Vuep8hKg5AkZXt8ktNMkwXEY',
  );
}

final supabase = Supabase.instance.client;
