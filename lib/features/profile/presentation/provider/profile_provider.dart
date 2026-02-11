import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:community/features/profile/domain/entities/profile_entity.dart';

final profileProvider = NotifierProvider<ProfileViewModel, ProfileState>(
  ProfileViewModel.new,
);

class ProfileState {
  final ProfileEntity? profile;
  final bool isLoading;
  final String? errorMessage;

  ProfileState({
    this.profile,
    this.isLoading = false,
    this.errorMessage,
  });
}
