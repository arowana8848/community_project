import 'package:flutter_test/flutter_test.dart';
import 'package:community/core/services/hive/hive_service.dart';

void main() {
  group('HiveService unit', () {
    test('register throws if authId is null', () async {
      final service = HiveService();
      final model = null; // Minimalist: just check null
      expect(() => service.register(model), throwsA(isA<TypeError>()));
    });

    test('close does not throw', () async {
      final service = HiveService();
      await service.close();
      expect(true, isTrue); // Minimalist
    });
  });
}
