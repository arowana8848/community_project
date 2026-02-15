import 'package:community/features/feed/data/datasources/post_remote_datasource.dart';
import 'package:community/features/feed/data/repositories/post_repository.dart';
import 'package:community/features/feed/domain/entities/post_model.dart';

class PostRepositoryImpl implements IPostRepository {
  final IPostRemoteDatasource remoteDatasource;

  PostRepositoryImpl({required this.remoteDatasource});

  @override
  Future<List<PostModel>> fetchPostsByCommunity(String communityId) {
    return remoteDatasource.fetchPostsByCommunity(communityId);
  }

  @override
  Future<PostModel> createPost({
    required String communityId,
    required String text,
  }) {
    return remoteDatasource.createPost(communityId: communityId, text: text);
  }

  @override
  Future<PostModel> reactToPost({
    required String postId,
    required String reaction,
  }) {
    return remoteDatasource.reactToPost(
      postId: postId,
      reaction: reaction,
    );
  }
}
