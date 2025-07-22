import 'package:club_libertad_front/features/auth/presentation/providers/auth_provider.dart';
import 'package:club_libertad_front/features/auth/presentation/providers/login_form_provider.dart';
import 'package:club_libertad_front/features/auth/presentation/screen/login_screen.dart';
import 'package:club_libertad_front/features/shared/widgets/custom_text_form_field.dart';
import 'package:club_libertad_front/ui/inicio/inicio_screen.dart';
import 'package:club_libertad_front/ui/widgets/border_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginForm extends ConsumerWidget {
  final TextEditingController usernameController;
  final FocusNode usernameFocusNode;
  final FocusNode passwordFocusNode;
  final Animation<double> usernameHighlightAnimation;

  const LoginForm({
    super.key,
    required this.usernameController,
    required this.usernameFocusNode,
    required this.passwordFocusNode,
    required this.usernameHighlightAnimation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginForm = ref.watch(loginFormProvider);
    final authState = ref.watch(authProvider);
    final obscureText = ref.watch(obscureTextProvider);
    final isEmailAutofilled = ref.watch(emailAutofilledProvider);
    final loginFormNotifier = ref.read(loginFormProvider.notifier);
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    ref.listen(authProvider, (prev, next) {
      if (next.authStatus == AuthStatus.authenticated) {
        context.go('/inicio'); // <-- redirección automática
      }
    });
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Campo Usuario con animación si está autollenado
        AnimatedBuilder(
          animation: usernameHighlightAnimation,
          builder: (context, child) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: isEmailAutofilled
                    ? Border.all(
                        color: Colors.amber.withOpacity(
                            usernameHighlightAnimation.value * 0.5),
                        width: 2.0,
                      )
                    : null,
                boxShadow: isEmailAutofilled
                    ? [
                        BoxShadow(
                          color: colors.primary.withOpacity(
                              usernameHighlightAnimation.value * 0.2),
                          blurRadius: 8,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
              child: child,
            );
          },
          child: Stack(
            children: [
              CustomTextFormField(
                controller: usernameController,
                focusNode: usernameFocusNode,
                label: 'Usuario',
                prefixIcon: const Icon(Icons.account_circle_outlined),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  ref.read(loginFormProvider.notifier).userChanged(value);
                  ref.read(lastEmailEditTimeProvider.notifier).state =
                      DateTime.now();
                  ref.read(emailAutofilledProvider.notifier).state = false;
                },
                errorMessage: loginForm.isFormPosted
                    ? loginForm.username.errorMessage
                    : null,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(passwordFocusNode);
                },
                suffixIcon: usernameController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        tooltip: 'Borrar usuario',
                        onPressed: () {
                          usernameController.clear();
                          ref.read(loginFormProvider.notifier).userChanged('');
                          ref.read(emailAutofilledProvider.notifier).state =
                              false;
                        },
                      )
                    : null,
              ),
              if (isEmailAutofilled)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Tooltip(
                    message: 'Usuario guardado anteriormente',
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: colors.primary.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Icon(
                        Icons.history,
                        size: 16,
                        color: colors.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (isEmailAutofilled)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 8),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    size: 14, color: colors.onSurface.withOpacity(0.6)),
                const SizedBox(width: 4),
                Text(
                  'Usuario recuperado de tu último ingreso',
                  style: textStyles.bodySmall?.copyWith(
                    color: colors.onSurface.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16.0),

        // Campo Contraseña
        CustomTextFormField(
          label: 'Contraseña',
          focusNode: passwordFocusNode,
          obscureText: obscureText,
          onChanged: loginFormNotifier.passwordChanged,
          errorMessage:
              loginForm.isFormPosted ? loginForm.password.errorMessage : null,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              obscureText
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              size: 21,
            ),
            tooltip: obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña',
            onPressed: () {
              ref.read(obscureTextProvider.notifier).state = !obscureText;
            },
          ),
          keyboardType: TextInputType.visiblePassword,
          onFieldSubmitted: (_) {
            if (!authState.isLoading) {
              loginFormNotifier.onFormSubmitted();
            }
          },
          textInputAction: TextInputAction.done,
        ),
        const SizedBox(height: 24.0),
// Recordarme y ¿Olvidaste tu contraseña?
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value:
                      false, // puedes conectar a un `StateProvider` si lo deseas
                  onChanged: (value) {
                    // lógica de recordarme aquí
                  },
                ),
                const Text('Recordarme'),
              ],
            ),
            TextButton(
              onPressed: authState.isLoading
                  ? null
                  : () {
                      // lógica para recuperación
                    },
              child: Text(
                "¿Olvidaste tu contraseña?",
                style: textStyles.bodyMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12.0),

        // Botón de login
        FilledButton(
          onPressed: authState.isLoading
              ? null
              : () {
                  loginFormNotifier.onFormSubmitted();
                },
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: textStyles.titleMedium,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: authState.isLoading
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.0,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text("Ingresando..."),
                  ],
                )
              : const Text("Iniciar sesión"),
        ),
        const SizedBox(height: 16),

        Row(
          children: [
            const Expanded(child: Divider(thickness: 1)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                "o continúa con",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            const Expanded(child: Divider(thickness: 1)),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BorderIconButton(
              icon: FontAwesomeIcons.facebookF,
              backgroundColor: Color(0xFF1877F2),
              iconColor: Colors.white,
              onTap: () {
                // Facebook login
              },
            ),
            const SizedBox(width: 20),
            BorderIconButton(
              icon: FontAwesomeIcons.google,
              backgroundColor: Color(0xFFDB4437),
              iconColor: Colors.white,
              onTap: () {
                // Google login
              },
            ),
            const SizedBox(width: 20),
            BorderIconButton(
              icon: FontAwesomeIcons.apple,
              backgroundColor: Colors.black,
              iconColor: Colors.white,
              onTap: () {
                // Apple login
              },
            ),
          ],
        ),

        // Opción de olvido de contraseña
      ],
    );
  }
}
