import 'package:community/features/feed/domain/entities/post_model.dart';

abstract class IPostRepository {
  Future<List<PostModel>> fetchPostsByCommunity(String communityId);
  Future<PostModel> createPost({
    required String communityId,
    required String text,
  });
  Future<PostModel> reactToPost({
    required String postId,
    required String reaction,
  });
}
