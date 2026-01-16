import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:community/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:community/features/auth/presentation/state/auth_state.dart';

/// AuthProvider bridges your UI and AuthViewModel using Riverpod.
final authProvider = NotifierProvider<AuthViewModel, AuthState>(
  AuthViewModel.new,
);
