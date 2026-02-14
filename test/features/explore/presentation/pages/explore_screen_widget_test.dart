import 'package:flutter_test/flutter_test.dart';
import 'package:community/features/explore/presentation/pages/explore_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community/features/community/presentation/provider/community_provider.dart';
import 'package:community/features/community/presentation/view_model/community_view_model.dart';

void main() {
  testWidgets('ExploreScreen renders', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          communityProvider.overrideWith(() => MockCommunityViewModel()),
        ],
        child: const MaterialApp(
          home: ExploreScreen(),
        ),
      ),
    );
    expect(find.byType(ExploreScreen), findsOneWidget);
  });
}

class MockCommunityViewModel extends CommunityViewModel {
  @override
  CommunityState build() {
    return CommunityState();
  }
}
