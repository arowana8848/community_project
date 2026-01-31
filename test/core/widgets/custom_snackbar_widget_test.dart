import 'package:flutter_test/flutter_test.dart';
import 'package:community/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('CustomSnackBar.error shows error', (tester) async {
    final widget = MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar.error('err'));
            },
            child: const Text('Show'),
          ),
        ),
      ),
    );
    await tester.pumpWidget(widget);
    await tester.tap(find.text('Show'));
    await tester.pump();
    expect(find.text('err'), findsOneWidget);
  });
}
