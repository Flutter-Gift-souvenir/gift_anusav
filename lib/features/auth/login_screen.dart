import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // --- Controllers ---
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  // --- Mock Credentials ---
  static const String _mockEmail = 'sopheak.v@anusav.com';
  static const String _mockPassword = 'password123';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- Login Logic ---
  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Basic validation
    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));

    if (email == _mockEmail && password == _mockPassword) {
      if (!mounted) return;
      AppHelpers.showSnackBar(context, 'Welcome back!');
      context.go('/');
    } else {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Invalid email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final secondaryColor =
        isDark ? AppColors.textSecondaryDark : AppColors.grey600;

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.defaultPadding,
          ),
          child: Column(
            children: [
              const Gap(40),

              // --- Logo ---
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.card_giftcard,
                  size: 44,
                  color: AppColors.primary,
                ),
              ),

              const Gap(16),

              // --- App Name ---
              Text(
                'Anusav',
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const Gap(8),

              // --- Subtitle ---
              Text(
                'Welcome back to authentic Cambodian crafts',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: secondaryColor,
                ),
                textAlign: TextAlign.center,
              ),

              const Gap(32),

              // --- Email Field ---
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Email Address',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Gap(6),
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: AppTextStyles.bodyLarge.copyWith(color: textColor),
                decoration: InputDecoration(
                  hintText: 'name@example.com',
                  hintStyle: AppTextStyles.bodyLarge.copyWith(
                    color: isDark ? AppColors.grey600 : AppColors.grey400,
                  ),
                  prefixIcon: Icon(Icons.mail_outline, color: secondaryColor),
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceDark : AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.grey800 : AppColors.grey200,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.grey800 : AppColors.grey200,
                    ),
                  ),
                ),
              ),

              const Gap(16),

              // --- Password Field ---
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Password',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Gap(6),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: AppTextStyles.bodyLarge.copyWith(color: textColor),
                decoration: InputDecoration(
                  hintText: '••••••••',
                  hintStyle: AppTextStyles.bodyLarge.copyWith(
                    color: isDark ? AppColors.grey600 : AppColors.grey400,
                  ),
                  prefixIcon: Icon(Icons.lock_outline, color: secondaryColor),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: secondaryColor,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                  filled: true,
                  fillColor: isDark ? AppColors.surfaceDark : AppColors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.grey800 : AppColors.grey200,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: isDark ? AppColors.grey800 : AppColors.grey200,
                    ),
                  ),
                ),
              ),

              // --- Error Message ---
              if (_errorMessage != null) ...[
                const Gap(8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _errorMessage!,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ],

              const Gap(8),

              // --- Forgot Password ---
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () =>
                      AppHelpers.showComingSoon(context, 'Forgot Password'),
                  child: Text(
                    'Forgot Password?',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const Gap(20),

              // --- Log In Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.white,
                          ),
                        )
                      : Text(
                          'Log In',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              ),

              const Gap(24),

              // --- Divider ---
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark ? AppColors.grey800 : AppColors.grey200,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'OR CONTINUE WITH',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: secondaryColor,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark ? AppColors.grey800 : AppColors.grey200,
                    ),
                  ),
                ],
              ),

              const Gap(24),

              // --- Social Buttons ---
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          AppHelpers.showComingSoon(context, 'Google login'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textColor,
                        side: BorderSide(
                          color: isDark ? AppColors.grey800 : AppColors.grey200,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('G', style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: Color(0xFF4285F4),
                          )),
                          const Gap(8),
                          Text(
                            'Google',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const Gap(12),

                  Expanded(
                    child: OutlinedButton(
                      onPressed: () =>
                          AppHelpers.showComingSoon(context, 'Facebook login'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: textColor,
                        side: BorderSide(
                          color: isDark ? AppColors.grey800 : AppColors.grey200,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.facebook,
                            color: Color(0xFF1877F2),
                            size: 20,
                          ),
                          const Gap(8),
                          Text(
                            'Facebook',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const Gap(28),

              // --- Sign Up Link ---
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: secondaryColor,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => AppHelpers.showComingSoon(context, 'Sign Up'),
                    child: Text(
                      'Sign Up',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const Gap(24),

              // --- Hint for mock credentials ---
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Demo: $_mockEmail / $_mockPassword',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.goldDark,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Gap(24),
            ],
          ),
        ),
      ),
    );
  }
}