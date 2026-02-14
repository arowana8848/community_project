import 'package:community/core/api/api_client.dart';
import 'package:community/features/community/data/datasources/community_remote_datasource_impl.dart';
import 'package:community/features/community/data/repositories/community_repository.dart';
import 'package:community/features/community/data/repositories/community_repository_impl.dart';
import 'package:community/features/community/presentation/provider/community_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommunityViewModel extends Notifier<CommunityState> {
  late final ICommunityRepository _communityRepository;

  @override
  CommunityState build() {
    final apiClient = ref.read(apiClientProvider);
    _communityRepository = CommunityRepositoryImpl(
      remoteDatasource: CommunityRemoteDatasourceImpl(apiClient: apiClient),
    );
    return CommunityState();
  }

  Future<void> fetchCommunities() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final communities = await _communityRepository.fetchCommunities();
      state = state.copyWith(
        isLoading: false,
        allCommunities: communities,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> fetchMyCommunities() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final communities = await _communityRepository.fetchMyCommunities();
      state = state.copyWith(
        isLoading: false,
        myCommunities: communities,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> joinCommunity(String communityId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _communityRepository.joinCommunity(communityId);
      final communities = await _communityRepository.fetchMyCommunities();
      state = state.copyWith(
        isLoading: false,
        myCommunities: communities,
      );
      return true;
    } catch (e) {
      String errorMessage = e.toString();
      
      // Handle "already joined" scenario
      if (errorMessage.contains('400') || 
          errorMessage.toLowerCase().contains('already') ||
          errorMessage.toLowerCase().contains('exists')) {
        errorMessage = 'You have already joined this community';
      }
      
      state = state.copyWith(isLoading: false, errorMessage: errorMessage);
      return false;
    }
  }

  Future<bool> leaveCommunity(String communityId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _communityRepository.leaveCommunity(communityId);
      final communities = await _communityRepository.fetchMyCommunities();
      state = state.copyWith(
        isLoading: false,
        myCommunities: communities,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      return false;
    }
  }
}
