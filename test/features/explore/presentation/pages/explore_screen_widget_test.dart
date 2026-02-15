import 'package:flutter_test/flutter_test.dart';
import 'package:community/features/explore/presentation/pages/explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community/features/explore/presentation/providers/explore_provider.dart';
import 'package:community/features/explore/presentation/view_model/explore_view_model.dart';

void main() {
  testWidgets('ExploreScreen renders', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          exploreProvider.overrideWith(() => MockExploreViewModel()),
        ],
        child: const MaterialApp(
          home: ExploreScreen(),
        ),
      ),
    );
    expect(find.byType(ExploreScreen), findsOneWidget);
  });
}

class MockExploreViewModel extends ExploreViewModel {
  @override
  ExploreState build() {
    return ExploreState();
  }

  @override
  Future<void> fetchCommunities() async {
    return;
  }
}
