// login_form_provider.dart

import 'package:club_libertad_front/features/auth/presentation/providers/auth_provider.dart';
import 'package:club_libertad_front/features/shared/infrastructure/inputs/password.dart';
import 'package:club_libertad_front/features/shared/infrastructure/inputs/user.dart';
import 'package:club_libertad_front/features/shared/infrastructure/services/key_value_storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final loginFormProvider = StateNotifierProvider.autoDispose<LoginFormNotifier, LoginFormState>((ref) {
  final keyValueStorageService = ref.watch(keyValueStorageServiceProvider);
  final loginUserCallBack = ref.read(authProvider.notifier).loginUser;

  return LoginFormNotifier(
    loginUserCallBack: loginUserCallBack,
    keyValueStorageService: keyValueStorageService,
  );
});

final obscuretextProvider = StateProvider<bool>((ref) => true);

class LoginFormNotifier extends StateNotifier<LoginFormState> {
  final Future<void> Function(String, String) loginUserCallBack;
  final KeyValueStorageService keyValueStorageService;

  LoginFormNotifier({
    required this.loginUserCallBack,
    required this.keyValueStorageService,
  }) : super(LoginFormState()) {
    _loadInitialEmail();
  }

  Future<void> _loadInitialEmail() async {
    final lastUsername = await keyValueStorageService.getValue<String>('last_logged_email');
    if (lastUsername != null && lastUsername.isNotEmpty) {
      final username = Username.dirty(lastUsername);
      state = state.copyWith(
        username: username,
        isValid: Formz.validate([username, state.password]),
      );
    }
  }

  void userChanged(String value) {
    final newUser = Username.dirty(value);
    state = state.copyWith(
      username: newUser,
      isValid: Formz.validate([newUser, state.password]),
    );
  }

  void passwordChanged(String value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.username]),
    );
  }

  Future<void> onFormSubmitted() async {
    _touchEveryField();
    if (!state.isValid) return;

    state = state.copyWith(isPosting: true);

    await loginUserCallBack(state.username.value, state.password.value);

    state = state.copyWith(isPosting: false);
  }

  void _touchEveryField() {
    final user = Username.dirty(state.username.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      username: user,
      password: password,
      isValid: Formz.validate([user, password]),
    );
  }
}

class LoginFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Username username;
  final Password password;

  LoginFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.username = const Username.pure(),
    this.password = const Password.pure(),
  });

  LoginFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Username? username,
    Password? password,
  }) =>
      LoginFormState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        username: username ?? this.username,
        password: password ?? this.password,
      );

  @override
  String toString() {
    return 'LoginFormState(isPosting: $isPosting, isFormPosted: $isFormPosted, isValid: $isValid, username: $username, password: $password)';
  }
}
