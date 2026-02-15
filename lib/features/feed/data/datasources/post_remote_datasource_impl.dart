import 'package:community/core/api/api_client.dart';
import 'package:community/core/api/api_endpoint.dart';
import 'package:community/features/feed/data/datasources/post_remote_datasource.dart';
import 'package:community/features/feed/domain/entities/post_model.dart';

class PostRemoteDatasourceImpl implements IPostRemoteDatasource {
  final ApiClient _apiClient;

  PostRemoteDatasourceImpl({required ApiClient apiClient})
      : _apiClient = apiClient;

  @override
  Future<List<PostModel>> fetchPostsByCommunity(String communityId) async {
    final response = await _apiClient.get(ApiEndpoints.postsByCommunity(communityId));
    final payload = response.data is Map<String, dynamic>
        ? (response.data['data'] ?? response.data)
        : response.data;
    if (payload is! List) {
      return [];
    }

    return payload
        .whereType<Map<String, dynamic>>()
        .map(PostModel.fromJson)
        .toList();
  }

  @override
  Future<PostModel> createPost({
    required String communityId,
    required String text,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.posts,
      data: {
        'text': text,
        'communityId': communityId,
      },
    );
    final payload = response.data is Map<String, dynamic>
        ? (response.data['data'] ?? response.data)
        : response.data;
    if (payload is! Map<String, dynamic>) {
      throw Exception('Invalid response while creating post');
    }
    return PostModel.fromJson(payload);
  }

  @override
  Future<PostModel> reactToPost({
    required String postId,
    required String reaction,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.postReaction(postId),
      data: {
        'type': reaction,
      },
    );
    final payload = response.data is Map<String, dynamic>
        ? (response.data['data'] ?? response.data)
        : response.data;
    if (payload is! Map<String, dynamic>) {
      throw Exception('Invalid response while reacting to post');
    }
    return PostModel.fromJson(payload);
  }
}
