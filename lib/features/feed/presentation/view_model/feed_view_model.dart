import 'package:community/core/api/api_client.dart';
import 'package:community/features/feed/data/datasources/post_remote_datasource_impl.dart';
import 'package:community/features/feed/data/repositories/post_repository.dart';
import 'package:community/features/feed/data/repositories/post_repository_impl.dart';
import 'package:community/features/feed/domain/entities/post_model.dart';
import 'package:community/features/feed/presentation/providers/feed_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedViewModel extends Notifier<FeedState> {
  late final IPostRepository _postRepository;

  @override
  FeedState build() {
    final apiClient = ref.read(apiClientProvider);
    _postRepository = PostRepositoryImpl(
      remoteDatasource: PostRemoteDatasourceImpl(apiClient: apiClient),
    );
    return FeedState();
  }

  Future<void> fetchPosts(String communityId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final posts = await _postRepository.fetchPostsByCommunity(communityId);
      state = state.copyWith(posts: posts, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<PostModel> createPost({
    required String communityId,
    required String text,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final post = await _postRepository.createPost(
        communityId: communityId,
        text: text,
      );
      state = state.copyWith(isLoading: false);
      return post;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      rethrow;
    }
  }

  Future<void> reactToPost({
    required String postId,
    required String reaction,
  }) async {
    try {
      final updated = await _postRepository.reactToPost(
        postId: postId,
        reaction: reaction,
      );
      final posts = state.posts.map((post) {
        return post.id == updated.id ? updated : post;
      }).toList();
      state = state.copyWith(posts: posts);
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      rethrow;
    }
  }
}
