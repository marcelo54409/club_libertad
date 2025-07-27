import 'package:club_libertad_front/features/shared/infrastructure/inputs/email.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:club_libertad_front/features/auth/presentation/providers/auth_provider.dart';
import 'package:club_libertad_front/features/shared/infrastructure/inputs/password.dart';
import 'package:club_libertad_front/features/shared/infrastructure/inputs/user.dart'; // Asume que tienes input validators similares
import 'package:club_libertad_front/features/shared/infrastructure/services/key_value_storage_service.dart';

final registerFormProvider =
    StateNotifierProvider.autoDispose<RegisterFormNotifier, RegisterFormState>(
        (ref) {
  final keyValueStorageService = ref.watch(keyValueStorageServiceProvider);
  final registerCallback = ref.read(authProvider.notifier).registerUser;
  return RegisterFormNotifier(
    registerCallback: registerCallback,
    keyValueStorageService: keyValueStorageService,
  );
});

final passwordVisibilityProvider = StateProvider<bool>((ref) => true);

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String) registerCallback;
  final KeyValueStorageService keyValueStorageService;

  RegisterFormNotifier({
    required this.registerCallback,
    required this.keyValueStorageService,
  }) : super(RegisterFormState());

  void usernameChanged(String value) {
    final username = Username.dirty(value); // puedes usar tu propia clase
    state = state.copyWith(
        username: username, isValid: _validateAll(username: username));
  }

  void apellidoChanged(String value) {
    final apellido = Username.dirty(value);
    state = state.copyWith(
        apellido: apellido, isValid: _validateAll(apellido: apellido));
  }

  void correoChanged(String value) {
    final correo = Email.dirty(value); // ✅ usar el validador correcto
    state =
        state.copyWith(correo: correo, isValid: _validateAll(correo: correo));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    state = state.copyWith(
        password: password, isValid: _validateAll(password: password));
  }

 Future<bool> onFormSubmitted() async {
  _touchFields();
  if (!state.isValid) return false;

  try {
    await registerCallback(state.username.value, state.password.value);
    return true; // ✅ Registro exitoso
  } catch (e) {
    // Puedes loguear si quieres: print(e);
    rethrow; // ⛔️ Propaga el error para que la UI lo muestre
  }
}


  void _touchFields() {
    final username = Username.dirty(state.username.value);
    final apellido = Username.dirty(state.apellido.value);
    final correo = Email.dirty(state.correo.value); // ← esto es lo correcto
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      username: username,
      apellido: apellido,
      correo: correo,
      password: password,
      isValid: Formz.validate([username, apellido, correo, password]),
    );
  }

  bool _validateAll({
    Username? username,
    Username? apellido,
    Email? correo, // <- CAMBIA esto
    Password? password,
  }) {
    return Formz.validate([
      username ?? state.username,
      apellido ?? state.apellido,
      correo ?? state.correo, // <- ya se usa Email aquí
      password ?? state.password,
    ]);
  }
}

class RegisterFormState {
  final Username username;
  final Username apellido;
  final Email correo;
  final Password password;
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  RegisterFormState({
    this.username = const Username.pure(),
    this.apellido = const Username.pure(),
    this.correo = const Email.pure(), // ✅ aquí también
    this.password = const Password.pure(),
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
  });
  RegisterFormState copyWith({
    Username? username,
    Username? apellido,
    Email? correo, // ← CAMBIA esto, debe ser Email
    Password? password,
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
  }) {
    return RegisterFormState(
      username: username ?? this.username,
      apellido: apellido ?? this.apellido,
      correo: correo ?? this.correo,
      password: password ?? this.password,
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
    );
  }
}
