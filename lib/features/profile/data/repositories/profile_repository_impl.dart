import 'dart:io';
import 'package:community/features/profile/domain/entities/profile_entity.dart';
import 'package:community/features/profile/data/repositories/profile_repository.dart';
import 'package:community/features/profile/data/datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements IProfileRepository {
  final IProfileRemoteDatasource remoteDatasource;
  ProfileRepositoryImpl({required this.remoteDatasource});

  @override
  Future<ProfileEntity?> fetchProfile(String token, String customerId) {
    return remoteDatasource.fetchProfile(token, customerId);
  }

  @override
  Future<bool> uploadProfilePicture(File imageFile, String token, String customerId) {
    return remoteDatasource.uploadProfilePicture(imageFile, token, customerId);
  }
}
