import 'dart:io';
import 'package:community/features/profile/domain/entities/profile_entity.dart';

abstract class UploadProfilePictureUsecase {
  Future<bool> call({required File imageFile, required String token, required String customerId});
}
