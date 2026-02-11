import 'package:community/features/profile/domain/entities/profile_entity.dart';

abstract class FetchProfileUsecase {
  Future<ProfileEntity?> call({required String token, required String customerId});
}
