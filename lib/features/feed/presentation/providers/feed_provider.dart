import 'package:community/features/feed/domain/entities/post_model.dart';
import 'package:community/features/feed/presentation/view_model/feed_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final feedProvider = NotifierProvider<FeedViewModel, FeedState>(
  FeedViewModel.new,
);

class FeedState {
  final List<PostModel> posts;
  final bool isLoading;
  final String? errorMessage;

  FeedState({
    this.posts = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  FeedState copyWith({
    List<PostModel>? posts,
    bool? isLoading,
    String? errorMessage,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
