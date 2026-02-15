import 'package:community/features/explore/data/datasources/explore_remote_datasource.dart';
import 'package:community/features/explore/data/repositories/explore_repository.dart';
import 'package:community/features/explore/domain/entities/explore_community_entity.dart';

class ExploreRepositoryImpl implements IExploreRepository {
  final IExploreRemoteDatasource remoteDatasource;

  ExploreRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<ExploreCommunityEntity>> fetchCommunities() {
    return remoteDatasource.fetchCommunities();
  }

  @override
  Future<void> joinCommunity(String communityId) {
    return remoteDatasource.joinCommunity(communityId);
  }
}
