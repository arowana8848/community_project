import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community/features/dashboard/presentation/view_model/dashboard_view_model.dart';
import 'package:community/features/dashboard/domain/entities/dashboard_user_entity.dart';

final dashboardProvider = NotifierProvider<DashboardViewModel, DashboardState>(
  DashboardViewModel.new,
);

class DashboardState {
  final DashboardUserEntity? user;
  final bool isLoading;
  final String? errorMessage;

  DashboardState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });
}
