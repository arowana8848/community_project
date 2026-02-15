import 'package:community/features/explore/domain/entities/explore_community_entity.dart';

abstract class IExploreRepository {
  Future<List<ExploreCommunityEntity>> fetchCommunities();
  Future<void> joinCommunity(String communityId);
}
