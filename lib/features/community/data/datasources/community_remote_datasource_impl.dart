import 'package:community/core/api/api_client.dart';
import 'package:community/core/api/api_endpoint.dart';
import 'package:community/features/community/data/datasources/community_remote_datasource.dart';
import 'package:community/features/community/domain/entities/community_entity.dart';

class CommunityRemoteDatasourceImpl implements ICommunityRemoteDatasource {
  final ApiClient _apiClient;

  CommunityRemoteDatasourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<List<CommunityEntity>> fetchCommunities() async {
    final response = await _apiClient.get(ApiEndpoints.communities);
    return _parseCommunities(response.data);
  }

  @override
  Future<List<CommunityEntity>> fetchMyCommunities() async {
    final response = await _apiClient.get(ApiEndpoints.communityMy);
    return _parseCommunities(response.data);
  }

  @override
  Future<void> joinCommunity(String communityId) async {
    await _apiClient.post(ApiEndpoints.communityJoin(communityId));
  }

  @override
  Future<void> leaveCommunity(String communityId) async {
    await _apiClient.delete(ApiEndpoints.communityJoin(communityId));
  }

  List<CommunityEntity> _parseCommunities(dynamic data) {
    final payload = data is Map<String, dynamic> ? (data['data'] ?? data) : data;
    if (payload is! List) {
      return [];
    }

    return payload
        .whereType<Map<String, dynamic>>()
        .map(
          (item) => CommunityEntity(
            id: item['_id']?.toString() ?? item['id']?.toString(),
            title: item['title']?.toString(),
            image: item['image']?.toString(),
            description: item['description']?.toString(),
          ),
        )
        .toList();
  }
}
