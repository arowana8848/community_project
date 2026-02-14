import 'package:community/features/community/data/datasources/community_remote_datasource.dart';
import 'package:community/features/community/data/repositories/community_repository.dart';
import 'package:community/features/community/domain/entities/community_entity.dart';

class CommunityRepositoryImpl implements ICommunityRepository {
  final ICommunityRemoteDatasource remoteDatasource;

  CommunityRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<CommunityEntity>> fetchCommunities() {
    return remoteDatasource.fetchCommunities();
  }

  @override
  Future<List<CommunityEntity>> fetchMyCommunities() {
    return remoteDatasource.fetchMyCommunities();
  }

  @override
  Future<void> joinCommunity(String communityId) {
    return remoteDatasource.joinCommunity(communityId);
  }

  @override
  Future<void> leaveCommunity(String communityId) {
    return remoteDatasource.leaveCommunity(communityId);
  }
}
