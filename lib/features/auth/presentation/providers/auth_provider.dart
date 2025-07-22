import 'dart:convert';
import 'dart:io';
import 'package:club_libertad_front/features/auth/domain/entities/user.dart';
import 'package:club_libertad_front/features/auth/domain/repositories/auth_repositorie.dart';
import 'package:club_libertad_front/features/auth/infrastructure/errors/auth_errors.dart';
import 'package:club_libertad_front/features/auth/infrastructure/mappers/user_mapper.dart';
import 'package:club_libertad_front/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:club_libertad_front/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:club_libertad_front/features/shared/infrastructure/services/key_value_storage_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final keyValueStorageServiceProvider = Provider<KeyValueStorageService>((ref) {
  return KeyValueStorageServiceImpl();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageService = ref.watch(keyValueStorageServiceProvider);

  return AuthNotifier(
    authRepository: authRepository,
    keyValueStorageService: keyValueStorageService,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;

  AuthNotifier(
      {required this.authRepository, required this.keyValueStorageService})
      : super(AuthState()) {
    checkAuthStatus();
  }
  Future<void> registerUser(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: '');

    try {
      final user = await authRepository.register(username, password);
      await _setLoggedUser(user);
    } on CustomError catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.message);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, errorMessage: 'Error inesperado al registrar');
    }
  }

  Future<void> loginUser(String username, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.none) {
      print('[Login Error] No internet connection');

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Revisar conexión a internet',
        authStatus: AuthStatus.notAuthenticated,
      );
      return;
    }

    try {
      final user = await authRepository.login(username, password);
      print('[Login Success] Usuario autenticado: ${user.username}');
      await _setLoggedUser(user);
    } on CustomError catch (e) {
      print('[Login CustomError] ${e.message}');
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.message,
      );
    } on SocketException {
      print('[Login SocketException] Problema de red');
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Revisar conexión a internet',
      );
    } catch (e, stackTrace) {
      print('[Login Unknown Error] $e');
      print('[StackTrace] $stackTrace');

      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error inesperado durante el login',
      );
    }
  }

  Future<void> _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.token);
    final userJson = UserMapper.userEntityToJson(user);
    await keyValueStorageService.setKeyValue(
        'user_session_data', jsonEncode(userJson));

    state = state.copyWith(
        errorMessage: '',
        authStatus: AuthStatus.authenticated,
        isLoading: false,
        user: user);
  }

  Future<void> logoutUser({String? errorMessage}) async {
    await keyValueStorageService.removeKey('token');
    await keyValueStorageService.removeKey('user_session_data');

    state = state.copyWith(
        errorMessage: errorMessage,
        authStatus: AuthStatus.notAuthenticated,
        isLoading: false,
        user: null);
  }

  void checkAuthStatus() async {
    state = state.copyWith(authStatus: AuthStatus.cheking, isLoading: true);

    final token = await keyValueStorageService.getValue<String>('token');

    if (token == null || token.isEmpty) {
      return logoutUser();
    }

    try {
      final userSessionData =
          await keyValueStorageService.getValue<String>('user_session_data');
      if (userSessionData != null && userSessionData.isNotEmpty) {
        final userMap = jsonDecode(userSessionData);
        final user = UserMapper.userJsonToEntity(userMap); // Usa tu mapper

        state = state.copyWith(
            authStatus: AuthStatus.authenticated,
            user: user,
            isLoading: false,
            errorMessage: '');
      } else {
        logoutUser(
            errorMessage:
                'Sesión inválida. Por favor, inicia sesión de nuevo.');
      }
    } catch (e) {
      logoutUser(errorMessage: 'Ocurrió un error al verificar tu sesión.');
    }
  }
}

enum AuthStatus {
  authenticated,
  notAuthenticated,
  cheking,
}

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String? errorMessage;
  final bool isLoading;

  AuthState(
      {this.authStatus = AuthStatus.cheking,
      this.isLoading = false,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith(
      {AuthStatus? authStatus,
      bool? isLoading,
      User? user,
      bool forceUserNull = false,
      String? errorMessage}) {
    return AuthState(
        authStatus: authStatus ?? this.authStatus,
        isLoading: isLoading ?? this.isLoading,
        user: forceUserNull ? null : (user ?? this.user),
        errorMessage: errorMessage ?? this.errorMessage);
  }

  @override
  String toString() {
    return 'AuthState(authStatus: $authStatus, isLoading: $isLoading, errorMessage: $errorMessage)';
  }
}
