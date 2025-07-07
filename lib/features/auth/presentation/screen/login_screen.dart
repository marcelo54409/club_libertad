import 'package:club_libertad_front/features/auth/presentation/providers/auth_provider.dart';
import 'package:club_libertad_front/features/auth/presentation/providers/login_form_provider.dart';
import 'package:club_libertad_front/features/shared/widgets/custom_text_form_field.dart';
import 'package:club_libertad_front/ui/inicio/inicio_screen.dart';
import 'package:club_libertad_front/ui/widgets/toggle_form_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'login_form.dart';
import 'register_form.dart';

final obscureTextProvider = StateProvider<bool>((ref) => true);
final emailAutofilledProvider = StateProvider<bool>((ref) => false);
final lastEmailEditTimeProvider = StateProvider<DateTime?>((ref) => null);
final isLoginFormProvider = StateProvider<bool>((ref) => true);

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
    return ClipPath(
      clipper: MyCustomClipper(),
      child: Container(),
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

    final initialEmail = ref.read(loginFormProvider).username.value;
    _usernameController = TextEditingController(text: initialEmail);
    _usernameFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();

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

    if (initialEmail.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(emailAutofilledProvider.notifier).state = true;
        _usernameAnimationController.forward().then((_) {
          _usernameAnimationController.reverse();
        });
      });
    }

    _usernameFocusNode.addListener(() {
      if (_usernameFocusNode.hasFocus) {
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
    final authState = ref.watch(authProvider);
    final isLogin = ref.watch(isLoginFormProvider);
    final colors = Theme.of(context).colorScheme;
    final size = MediaQuery.of(context).size;

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
          const SizedBox(height: 48), // 👈 Esto da espacio superior

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
            child: Column(
              children: [
                Image.asset(
                  'assets/images/escudo.png',
                  width: size.width * 0.30,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Club Libertad',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Tenis Trujillo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
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
            child: Column(
              children: [
                ToggleFormSelector(
                  options: const ['Iniciar Sesión', 'Registrarse'],
                  selectedIndex: isLogin ? 0 : 1,
                  onChanged: (index) {
                    ref.read(isLoginFormProvider.notifier).state = index == 0;
                  },
                  selectedColor: Colors.red,
                  selectedTextColor: Colors.white,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          const SizedBox(height: 32.0),
          isLogin
              ? LoginForm(
                  usernameController: _usernameController,
                  usernameFocusNode: _usernameFocusNode,
                  passwordFocusNode: _passwordFocusNode,
                  usernameHighlightAnimation: _usernameHighlightAnimation,
                )
              : const RegisterForm(),
          const SizedBox(height: 24.0),
        ],
      ),
    );
  }
}
