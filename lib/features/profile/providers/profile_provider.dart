import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

final profileFormProvider =
StateNotifierProvider<ProfileFormNotifier, AsyncValue<int?>>(
        (ref) => ProfileFormNotifier());

class ProfileFormNotifier extends StateNotifier<AsyncValue<int?>> {
  ProfileFormNotifier() : super(const AsyncValue.data(null));

  static const _prefsKey = 'profile_form_data';

  // Save form data locally, excluding passwords
  Future<void> saveFormData(Map<String, dynamic> data) async {
    final safeData = Map.of(data)
      ..remove('password')
      ..remove('confirmPassword');

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_prefsKey, jsonEncode(safeData));
  }

  // Load persisted data
  Future<Map<String, dynamic>?> loadFormData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_prefsKey);
    if (jsonStr != null) {
      return Map<String, dynamic>.from(jsonDecode(jsonStr));
    }
    return null;
  }

  // Submit form to API
  Future<void> submitForm(Map<String, dynamic> data) async {
    state = const AsyncValue.loading();
    try {
      final response = await http.post(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        body: jsonEncode(data),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 201) {
        final res = jsonDecode(response.body);
        final id = res['id'] as int;
        state = AsyncValue.data(id);

        // Clear persisted local data after successful submission
        final prefs = await SharedPreferences.getInstance();
        prefs.remove(_prefsKey);
      } else {
        throw Exception('Failed to submit form');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
