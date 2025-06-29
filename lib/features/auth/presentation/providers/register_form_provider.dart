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
  final loginCallback =
      ref.read(authProvider.notifier).loginUser; // reutiliza login para prueba
  return RegisterFormNotifier(
    loginCallback: loginCallback,
    keyValueStorageService: keyValueStorageService,
  );
});

final passwordVisibilityProvider = StateProvider<bool>((ref) => true);

class RegisterFormNotifier extends StateNotifier<RegisterFormState> {
  final Function(String, String) loginCallback;
  final KeyValueStorageService keyValueStorageService;

  RegisterFormNotifier({
    required this.loginCallback,
    required this.keyValueStorageService,
  }) : super(RegisterFormState());

  void nombreChanged(String value) {
    final nombre = Username.dirty(value); // puedes usar tu propia clase
    state =
        state.copyWith(nombre: nombre, isValid: _validateAll(nombre: nombre));
  }

  void apellidoChanged(String value) {
    final apellido = Username.dirty(value);
    state = state.copyWith(
        apellido: apellido, isValid: _validateAll(apellido: apellido));
  }

  void correoChanged(String value) {
    final correo = Username.dirty(value); // o Email si tienes
    state =
        state.copyWith(correo: correo, isValid: _validateAll(correo: correo));
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    state = state.copyWith(
        password: password, isValid: _validateAll(password: password));
  }

  Future<void> onFormSubmitted() async {
    _touchFields();
    if (!state.isValid) return;
    await loginCallback(state.correo.value,
        state.password.value); // reemplaza luego por register
  }

  void _touchFields() {
    final nombre = Username.dirty(state.nombre.value);
    final apellido = Username.dirty(state.apellido.value);
    final correo = Username.dirty(state.correo.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      nombre: nombre,
      apellido: apellido,
      correo: correo,
      password: password,
      isValid: Formz.validate([nombre, apellido, correo, password]),
    );
  }

  bool _validateAll({
    Username? nombre,
    Username? apellido,
    Username? correo,
    Password? password,
  }) {
    return Formz.validate([
      nombre ?? state.nombre,
      apellido ?? state.apellido,
      correo ?? state.correo,
      password ?? state.password,
    ]);
  }
}

class RegisterFormState {
  final Username nombre;
  final Username apellido;
  final Username correo;
  final Password password;
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;

  RegisterFormState({
    this.nombre = const Username.pure(),
    this.apellido = const Username.pure(),
    this.correo = const Username.pure(),
    this.password = const Password.pure(),
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
  });

  RegisterFormState copyWith({
    Username? nombre,
    Username? apellido,
    Username? correo,
    Password? password,
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
  }) {
    return RegisterFormState(
      nombre: nombre ?? this.nombre,
      apellido: apellido ?? this.apellido,
      correo: correo ?? this.correo,
      password: password ?? this.password,
      isPosting: isPosting ?? this.isPosting,
      isFormPosted: isFormPosted ?? this.isFormPosted,
      isValid: isValid ?? this.isValid,
    );
  }
}
