import 'package:community/core/api/api_client.dart';
import 'package:community/features/explore/data/datasources/explore_remote_datasource_impl.dart';
import 'package:community/features/explore/data/repositories/explore_repository.dart';
import 'package:community/features/explore/data/repositories/explore_repository_impl.dart';
import 'package:community/features/explore/presentation/providers/explore_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExploreViewModel extends Notifier<ExploreState> {
  late final IExploreRepository _exploreRepository;

  @override
  ExploreState build() {
    final apiClient = ref.read(apiClientProvider);
    _exploreRepository = ExploreRepositoryImpl(
      remoteDatasource: ExploreRemoteDatasourceImpl(apiClient: apiClient),
    );
    return ExploreState();
  }

  Future<void> fetchCommunities() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final communities = await _exploreRepository.fetchCommunities();
      state = state.copyWith(isLoading: false, communities: communities);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> joinCommunity(String communityId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _exploreRepository.joinCommunity(communityId);
      final communities = await _exploreRepository.fetchCommunities();
      state = state.copyWith(isLoading: false, communities: communities);
      return true;
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains('400') ||
          errorMessage.toLowerCase().contains('already') ||
          errorMessage.toLowerCase().contains('exists')) {
        errorMessage = 'You have already joined this community';
      }
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return false;
    }
  }
}
