import 'package:club_libertad_front/features/shared/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:club_libertad_front/features/auth/presentation/providers/register_form_provider.dart';

class RegisterForm extends ConsumerWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(registerFormProvider);
    final formNotifier = ref.read(registerFormProvider.notifier);
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;

    bool obscureText = ref.watch(passwordVisibilityProvider);
    final obscureNotifier = ref.read(passwordVisibilityProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                label: 'Nombre',
                initialValue: formState.nombre.value,
                onChanged: formNotifier.nombreChanged,
                errorMessage: formState.isFormPosted
                    ? formState.nombre.errorMessage
                    : null,
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: CustomTextFormField(
                label: 'Apellido',
                initialValue: formState.apellido.value,
                onChanged: formNotifier.apellidoChanged,
                errorMessage: formState.isFormPosted
                    ? formState.apellido.errorMessage
                    : null,
                prefixIcon: const Icon(Icons.person_outline),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        CustomTextFormField(
          label: 'Correo electrónico',
          initialValue: formState.correo.value,
          onChanged: formNotifier.correoChanged,
          errorMessage:
              formState.isFormPosted ? formState.correo.errorMessage : null,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.email_outlined),
        ),
        const SizedBox(height: 12),
        CustomTextFormField(
          label: 'Contraseña',
          initialValue: formState.password.value,
          onChanged: formNotifier.passwordChanged,
          errorMessage:
              formState.isFormPosted ? formState.password.errorMessage : null,
          obscureText: obscureText,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
            ),
            tooltip: obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña',
            onPressed: () {
              obscureNotifier.state = !obscureText;
            },
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () {
            formNotifier.onFormSubmitted();
          },
          style: FilledButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 167, 12, 1),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: textStyles.titleMedium,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text("Registrarse"),
        ),
      ],
    );
  }
}
