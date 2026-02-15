import 'package:community/features/explore/domain/entities/explore_community_entity.dart';
import 'package:community/features/explore/presentation/view_model/explore_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final exploreProvider = NotifierProvider<ExploreViewModel, ExploreState>(
  ExploreViewModel.new,
);

class ExploreState {
  final List<ExploreCommunityEntity> communities;
  final bool isLoading;
  final String? errorMessage;

  ExploreState({
    this.communities = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  ExploreState copyWith({
    List<ExploreCommunityEntity>? communities,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ExploreState(
      communities: communities ?? this.communities,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
