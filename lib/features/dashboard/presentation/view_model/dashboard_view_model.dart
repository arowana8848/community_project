import 'package:community/features/dashboard/presentation/provider/dashboard_provider.dart';
import 'package:community/features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardViewModel extends Notifier<DashboardState> {
  late final IDashboardRepository _dashboardRepository;

  @override
  DashboardState build() {
    // TODO: Inject repository using Riverpod
    throw UnimplementedError('Repository injection needed');
  }

  Future<void> fetchDashboardUser(String token) async {
    state = DashboardState(isLoading: true);
    try {
      final user = await _dashboardRepository.fetchDashboardUser(token);
      state = DashboardState(user: user, isLoading: false);
    } catch (e) {
      state = DashboardState(isLoading: false, errorMessage: e.toString());
    }
  }
}
