import 'package:community/features/dashboard/domain/entities/dashboard_user_entity.dart';

abstract class IDashboardRepository {
  Future<DashboardUserEntity?> fetchDashboardUser(String token);
}
