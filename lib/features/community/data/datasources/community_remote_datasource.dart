import 'package:community/features/community/domain/entities/community_entity.dart';

abstract class ICommunityRemoteDatasource {
  Future<List<CommunityEntity>> fetchCommunities();
  Future<List<CommunityEntity>> fetchMyCommunities();
  Future<void> joinCommunity(String communityId);
  Future<void> leaveCommunity(String communityId);
}
