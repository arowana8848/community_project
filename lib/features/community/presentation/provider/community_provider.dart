import 'package:community/features/community/domain/entities/community_entity.dart';
import 'package:community/features/community/presentation/view_model/community_view_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final communityProvider = NotifierProvider<CommunityViewModel, CommunityState>(
  CommunityViewModel.new,
);

class CommunityState {
  final List<CommunityEntity> allCommunities;
  final List<CommunityEntity> myCommunities;
  final bool isLoading;
  final String? errorMessage;

  CommunityState({
    this.allCommunities = const [],
    this.myCommunities = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  CommunityState copyWith({
    List<CommunityEntity>? allCommunities,
    List<CommunityEntity>? myCommunities,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CommunityState(
      allCommunities: allCommunities ?? this.allCommunities,
      myCommunities: myCommunities ?? this.myCommunities,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}
