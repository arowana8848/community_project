import 'package:community/core/api/api_client.dart';
import 'package:community/core/api/api_endpoint.dart';
import 'package:community/features/explore/data/datasources/explore_remote_datasource.dart';
import 'package:community/features/explore/domain/entities/explore_community_entity.dart';

class ExploreRemoteDatasourceImpl implements IExploreRemoteDatasource {
  final ApiClient _apiClient;

  ExploreRemoteDatasourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<ExploreCommunityEntity>> fetchCommunities() async {
    final response = await _apiClient.get(ApiEndpoints.communities);
    return _parseCommunities(response.data);
  }

  @override
  Future<void> joinCommunity(String communityId) async {
    await _apiClient.post(ApiEndpoints.communityJoin(communityId));
  }

  List<ExploreCommunityEntity> _parseCommunities(dynamic data) {
    final payload = data is Map<String, dynamic> ? (data['data'] ?? data) : data;
    if (payload is! List) {
      return [];
    }

    return payload
        .whereType<Map<String, dynamic>>()
        .map(
          (item) => ExploreCommunityEntity(
            id: item['_id']?.toString() ?? item['id']?.toString(),
            title: item['title']?.toString(),
            image: item['image']?.toString(),
            description: item['description']?.toString(),
          ),
        )
        .toList();
  }
}
