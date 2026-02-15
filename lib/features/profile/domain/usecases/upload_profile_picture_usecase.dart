import 'dart:io';

abstract class UploadProfilePictureUsecase {
  Future<bool> call({required File imageFile, required String token, required String customerId});
}
