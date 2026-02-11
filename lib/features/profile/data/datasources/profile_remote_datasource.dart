import 'dart:io';
import 'package:community/features/profile/domain/entities/profile_entity.dart';

abstract class IProfileRemoteDatasource {
  Future<ProfileEntity?> fetchProfile(String token, String customerId);
  Future<bool> uploadProfilePicture(File imageFile, String token, String customerId);
}
