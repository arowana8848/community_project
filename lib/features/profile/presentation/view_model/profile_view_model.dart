import 'dart:io';
import 'package:community/features/profile/presentation/provider/profile_provider.dart';
import 'package:community/features/profile/domain/entities/profile_entity.dart';
import 'package:community/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:community/features/profile/data/datasources/profile_remote_datasource_impl.dart';

class ProfileViewModel extends Notifier<ProfileState> {
  late final IProfileRepository _profileRepository;

  @override
  ProfileState build() {
    // Inject repository using implementation
    _profileRepository = ProfileRepositoryImpl(
      remoteDatasource: ProfileRemoteDatasourceImpl(),
    );
    return ProfileState();
  }

  Future<void> fetchProfile(String token, String customerId) async {
    state = ProfileState(isLoading: true);
    try {
      final profile = await _profileRepository.fetchProfile(token, customerId);
      state = ProfileState(profile: profile, isLoading: false);
    } catch (e) {
      state = ProfileState(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<void> uploadProfilePicture(File imageFile, String token, String customerId) async {
    state = ProfileState(isLoading: true, profile: state.profile);
    try {
      final oldUrl = state.profile?.photoUrl;
      final success = await _profileRepository.uploadProfilePicture(imageFile, token, customerId);
      if (success) {
        await fetchProfile(token, customerId);
        // Evict old image from cache
        if (oldUrl != null) {
          await NetworkImage(oldUrl).evict();
        }
      } else {
        state = ProfileState(isLoading: false, profile: state.profile, errorMessage: 'Upload failed');
      }
    } catch (e) {
      state = ProfileState(isLoading: false, profile: state.profile, errorMessage: e.toString());
    }
  }
}
