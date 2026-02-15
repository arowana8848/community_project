import 'package:flutter_test/flutter_test.dart';
import 'package:community/features/feed/presentation/pages/feed_screen.dart';
import 'package:flutter/material.dart';
import 'package:community/features/feed/data/local/feed_dummy_data.dart';
import 'package:community/features/feed/domain/entities/community_model.dart';
import 'package:community/features/community/presentation/provider/community_provider.dart';
import 'package:community/features/community/presentation/view_model/community_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community/features/feed/presentation/providers/feed_provider.dart';
import 'package:community/features/feed/presentation/view_model/feed_view_model.dart';

void main() {
  testWidgets('FeedScreen renders', (tester) async {
    final CommunityModel community = getDefaultCommunity();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          communityProvider.overrideWith(() => MockCommunityViewModel()),
          feedProvider.overrideWith(() => MockFeedViewModel()),
        ],
        child: MaterialApp(
          home: FeedScreen(
            communityId: community.id,
            communityName: community.name,
          ),
        ),
      ),
    );
    expect(find.byType(FeedScreen), findsOneWidget);
  });
}

class MockCommunityViewModel extends CommunityViewModel {
  @override
  CommunityState build() {
    return CommunityState();
  }
}

class MockFeedViewModel extends FeedViewModel {
  @override
  FeedState build() {
    return FeedState();
  }

  @override
  Future<void> fetchPosts(String communityId) async {
    return;
  }
}
