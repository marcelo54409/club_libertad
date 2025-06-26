import 'package:club_libertad_front/features/auth/presentation/providers/auth_provider.dart';
import 'package:club_libertad_front/features/auth/presentation/providers/login_form_provider.dart';
import 'package:club_libertad_front/features/shared/widgets/custom_text_form_field.dart';
import 'package:club_libertad_front/ui/inicio/inicio_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

// Provider para el estado de obscureText
final obscureTextProvider = StateProvider<bool>((ref) => true);

// Provider para controlar si el email fue autocompletado
final emailAutofilledProvider = StateProvider<bool>((ref) => false);

// Provider para almacenar el tiempo de la última edición del email
final lastEmailEditTimeProvider = StateProvider<DateTime?>((ref) => null);

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomShapeAppBar(),
      body: const SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: _LoginView(),
        ),
      ),
    );
  }
}

class CustomShapeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomShapeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(
        color: colors.primaryContainer,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(120.0);
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..lineTo(0, size.height * 0.65)
      ..quadraticBezierTo(
          size.width * 0.5, size.height * 1.0, size.width, size.height * 0.65)
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _LoginView extends ConsumerStatefulWidget {
  const _LoginView();
  @override
  ConsumerState<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<_LoginView>
    with SingleTickerProviderStateMixin {
  late final TextEditingController _usernameController;
  late final FocusNode _usernameFocusNode;
  late final FocusNode _passwordFocusNode;
  late final AnimationController _usernameAnimationController;
  late final Animation<double> _usernameHighlightAnimation;

  @override
  void initState() {
    super.initState();

    // Inicializar los controladores y nodos de foco
    final initialEmail = ref.read(loginFormProvider).username.value;
    _usernameController = TextEditingController(text: initialEmail);
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

    // Configurar la animación para el campo de email
    _usernameAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _usernameHighlightAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _usernameAnimationController,
      curve: Curves.easeInOut,
    ));

    // Si hay un email guardado, activar la animación y marcar como autollenado
    if (initialEmail.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(emailAutofilledProvider.notifier).state = true;
        _usernameAnimationController.forward().then((_) {
          _usernameAnimationController.reverse();
        });
      });
    }

    // Listener para el nodo de foco del email
    _usernameFocusNode.addListener(() {
      if (_usernameFocusNode.hasFocus) {
        // Al recibir el foco, si no se ha editado recientemente, seleccionar todo
        final lastEditTime = ref.read(lastEmailEditTimeProvider);
        final now = DateTime.now();
        if (lastEditTime == null ||
            now.difference(lastEditTime).inSeconds > 2) {
          _usernameController.selection = TextSelection(
              baseOffset: 0, extentOffset: _usernameController.text.length);
        }
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _usernameFocusNode.dispose();
    _passwordFocusNode.dispose();
    _usernameAnimationController.dispose();
    super.dispose();
  }

  void showAuthErrorSnackbar(BuildContext context, String message) {
    if (message.isEmpty) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade700,
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loginForm = ref.watch(loginFormProvider);
    final authState = ref.watch(authProvider);
    final obscureText = ref.watch(obscureTextProvider);
    final isEmailAutofilled = ref.watch(emailAutofilledProvider);
    final loginFormNotifier = ref.read(loginFormProvider.notifier);
    final textStyles = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

    final currentEmailValue = loginForm.username.value;
    if (currentEmailValue != _usernameController.text) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _usernameController.text = currentEmailValue;
          _usernameController.selection = TextSelection.fromPosition(
              TextPosition(offset: _usernameController.text.length));
        }
      });
    }

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage != null &&
          next.errorMessage!.isNotEmpty &&
          !next.isLoading) {
        showAuthErrorSnackbar(context, next.errorMessage!);
      }

      if (next.authStatus == AuthStatus.authenticated) {
        if (Navigator.canPop(context)) {
          context.pop();
        }
      }
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Logo con animación de entrada
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: Center(
              child: Image.asset(
                'assets/images/escudo.png',
                width: size.width * 0.50,
              ),
            ),
          ),
          const SizedBox(height: 24.0),

          // Título con animación de desvanecimiento
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Text(
              'Iniciar sesión',
              style: textStyles.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 32.0),

          // Campo Usuario con animación si está autollenado
          AnimatedBuilder(
            animation: _usernameHighlightAnimation,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: isEmailAutofilled
                      ? Border.all(
                          color: Colors.amber.withOpacity(
                              _usernameHighlightAnimation.value * 0.5),
                          width: 2.0)
                      : null,
                  boxShadow: isEmailAutofilled
                      ? [
                          BoxShadow(
                            color: colors.primary.withOpacity(
                                _usernameHighlightAnimation.value * 0.2),
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
                  controller: _usernameController,
                  focusNode: _usernameFocusNode,
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
                    FocusScope.of(context).requestFocus(_passwordFocusNode);
                  },
                  suffixIcon: _usernameController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          tooltip: 'Borrar usuario',
                          onPressed: () {
                            _usernameController.clear();
                            ref
                                .read(loginFormProvider.notifier)
                                .userChanged('');
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
                  Icon(
                    Icons.info_outline,
                    size: 14,
                    color: colors.onSurface.withOpacity(0.6),
                  ),
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
            focusNode: _passwordFocusNode,
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
              tooltip:
                  obscureText ? 'Mostrar contraseña' : 'Ocultar contraseña',
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

          // Botón de Iniciar Sesión con efecto de presión
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: 0.95 + (0.05 * value),
                child: Opacity(
                  opacity: value,
                  child: child,
                ),
              );
            },
            child: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                textStyle: textStyles.titleMedium,
                // Añadir elevación y efecto de pulsación
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: authState.isLoading
                  ? null
                  : () {
                      // Añadir feedback háptico si está disponible
                      /* HapticFeedback.mediumImpact();
                      loginFormNotifier.onFormSubmitted();*/

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const InicioScreen(),
                        ),
                      );
                    },
              child: authState.isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
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
          ),
          const SizedBox(height: 16.0),

          // Opciones adicionales con animación sutil
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: child,
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: authState.isLoading
                      ? null
                      : () {
                          // Implementar lógica de olvido de contraseña
                        },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
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
          ),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}

// Asegúrate de añadir este import en la parte superior
