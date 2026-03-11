import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '/core/widgets/app_gradient_button.dart';
import '/core/widgets/dismiss_keyboard.dart';
import '/features/auth/presentation/pages/sign_in/sign_in_widget.dart';
import '/features/auth/presentation/pages/sign_up/sign_up_widget.dart';

class WelcomeWidget extends StatefulWidget {
  const WelcomeWidget({super.key});

  static String routeName = 'welcome';
  static String routePath = 'welcome';

  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget>
    with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _itController;
  late final AnimationController _taglineController;
  late final AnimationController _ctaController;

  // Logo: scale down from large + fade in
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;

  // "it": fade in + slide from right
  late final Animation<double> _itFade;
  late final Animation<Offset> _itSlide;

  // Tagline: typewriter reveal
  late final Animation<double> _taglineReveal;

  // CTA: fade in + slide up
  late final Animation<double> _ctaFade;
  late final Animation<Offset> _ctaSlide;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _itController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _taglineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _ctaController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoScale = Tween<double>(begin: 2.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutCubic),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    _itFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _itController, curve: Curves.easeOut),
    );
    _itSlide = Tween<Offset>(
      begin: const Offset(0.3, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _itController, curve: Curves.easeOutCubic),
    );

    _taglineReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineController, curve: Curves.easeOut),
    );

    _ctaFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ctaController, curve: Curves.easeOut),
    );
    _ctaSlide = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _ctaController, curve: Curves.easeOutCubic),
    );

    _startAnimationSequence();

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      await actions.initPasswordResetDeepLink(context);
    });
  }

  Future<void> _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    _itController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    if (!mounted) return;
    _taglineController.forward();
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    _ctaController.forward();
  }

  @override
  void dispose() {
    _logoController.dispose();
    _itController.dispose();
    _taglineController.dispose();
    _ctaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: PopScope(
        canPop: false,
        child: Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                const Spacer(),
                _buildLogo(),
                const SizedBox(height: 12.0),
                _buildTagline(),
                const Spacer(),
                _buildCta(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return AnimatedBuilder(
      animation: Listenable.merge([_logoController, _itController]),
      builder: (context, _) {
        return FadeTransition(
          opacity: _logoFade,
          child: ScaleTransition(
            scale: _logoScale,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // "Get" with 3D shadow effect
                Stack(
                  children: [
                    // Shadow layer (darker purple, offset)
                    Transform.translate(
                      offset: const Offset(3, 3),
                      child: Text(
                        'Get',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w900,
                          fontSize: 72.0,
                          height: 1.0,
                          color: const Color(0xFF4A2DB3),
                        ),
                      ),
                    ),
                    // Main layer (brand purple)
                    Text(
                      'Get',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w900,
                        fontSize: 72.0,
                        height: 1.0,
                        color: AppColors.brandPurple,
                      ),
                    ),
                  ],
                ),
                // "it" - white superscript
                SlideTransition(
                  position: _itSlide,
                  child: FadeTransition(
                    opacity: _itFade,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2.0),
                      child: Text(
                        'it',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w800,
                          fontSize: 28.0,
                          height: 1.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTagline() {
    const words = ['Snap.', 'Catalog.', 'Organize'];
    return AnimatedBuilder(
      animation: _taglineController,
      builder: (context, _) {
        final progress = _taglineReveal.value;
        final wordsToShow = (progress * words.length).ceil();

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(wordsToShow, (i) {
            final wordStart = i / words.length;
            final wordEnd = (i + 1) / words.length;
            final wordProgress =
                ((progress - wordStart) / (wordEnd - wordStart)).clamp(0.0, 1.0);
            // Slide from left (-20px to 0) + fade in
            final offsetX = (1.0 - wordProgress) * -20.0;

            return Transform.translate(
              offset: Offset(offsetX, 0),
              child: Opacity(
                opacity: wordProgress,
                child: Padding(
                  padding: EdgeInsets.only(left: i > 0 ? 6.0 : 0.0),
                  child: Text(
                    words[i],
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildCta() {
    return SlideTransition(
      position: _ctaSlide,
      child: FadeTransition(
        opacity: _ctaFade,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: AppGradientButton(
                text: 'Create Account',
                onPressed: () async {
                  context.pushNamed(SignUpWidget.routeName);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: InkWell(
                onTap: () async {
                  context.pushNamed(SignInWidget.routeName);
                },
                child: RichText(
                  textScaler: MediaQuery.of(context).textScaler,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Already have an account?',
                        style: Theme.of(context).textTheme.labelMedium!,
                      ),
                      TextSpan(
                        text: ' Sign In',
                        style: GoogleFonts.inter(
                          color: AppColors.brandPurpleLight,
                        ),
                      ),
                    ],
                    style: Theme.of(context).textTheme.bodyMedium!,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
