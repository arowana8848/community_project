import 'package:community/features/dashboard/domain/entities/dashboard_user_entity.dart';

abstract class FetchDashboardUserUsecase {
  Future<DashboardUserEntity?> call({required String token});
}
