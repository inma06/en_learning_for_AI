import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/storage/local_storage.dart';

part 'auth_provider.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(false) bool isAuthenticated,
    @Default(false) bool isLoading,
    String? error,
    String? userId,
    String? userName,
    String? userEmail,
  }) = _AuthState;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final LocalStorage _localStorage;

  AuthNotifier(this._localStorage) : super(const AuthState()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    state = state.copyWith(isLoading: true);
    try {
      final token = _localStorage.getToken();
      if (token != null) {
        final userInfo = _localStorage.getUserInfo();
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          userId: userInfo['userId'],
          userName: userInfo['userName'],
          userEmail: userInfo['userEmail'],
        );
      } else {
        state = state.copyWith(
          isAuthenticated: false,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> login({
    required String userId,
    required String userName,
    required String userEmail,
    required String token,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await _localStorage.saveToken(token);
      await _localStorage.saveUserInfo(
        userId: userId,
        userName: userName,
        userEmail: userEmail,
      );
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        userId: userId,
        userName: userName,
        userEmail: userEmail,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(isLoading: true);
    try {
      await _localStorage.logout();
      state = const AuthState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final localStorage = ref.watch(localStorageProvider);
  return AuthNotifier(localStorage);
});

final localStorageProvider = Provider<LocalStorage>((ref) {
  throw UnimplementedError('LocalStorage must be initialized in main.dart');
});
