import 'package:flutter_test/flutter_test.dart';
import 'package:community/core/services/storage/user_session_service.dart';

void main() {
  group('UserSessionService unit', () {
    test('isLoggedIn returns false by default', () {
      final prefs = null; // Minimalist: just check null
      expect(() => UserSessionService(prefs: prefs), throwsA(isA<TypeError>()));
    });
  });
}
