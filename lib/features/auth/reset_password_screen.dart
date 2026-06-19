import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasNumber => RegExp(r'[0-9]').hasMatch(_passwordController.text);
  bool get _hasSpecialChar =>
      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_passwordController.text);

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _handleReset() async {
    if (!_hasMinLength || !_hasNumber || !_hasSpecialChar) {
      AppHelpers.showSnackBar(context, 'Password does not meet all requirements');
      return;
    }
    if (_passwordController.text != _confirmController.text) {
      AppHelpers.showSnackBar(context, 'Passwords do not match');
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    setState(() => _isLoading = false);

    context.push('/reset-success');
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
      body: Column(
        children: [
          // --- Header ---
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 24,
              bottom: 28,
            ),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.card_giftcard,
                    size: 34,
                    color: AppColors.primary,
                  ),
                ),
                const Gap(12),
                Text(
                  'Anusav',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Gap(4),
                Text(
                  'HERITAGE HEARTH',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white.withOpacity(0.7),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),

          // --- Content ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                children: [
                  const Gap(24),

                  Text(
                    'Create New Password',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w800,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Gap(10),

                  Text(
                    'Your new password must be different from previous ones.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: secondaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Gap(24),

                  // --- New Password ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'New Password',
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
                      hintText: 'Enter new password',
                      hintStyle: AppTextStyles.bodyLarge.copyWith(
                        color: isDark ? AppColors.grey600 : AppColors.grey400,
                      ),
                      prefixIcon:
                          Icon(Icons.lock_outline, color: secondaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: secondaryColor,
                        ),
                        onPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword),
                      ),
                      filled: true,
                      fillColor:
                          isDark ? AppColors.grey800 : AppColors.grey100,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const Gap(16),

                  // --- Confirm Password ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Confirm New Password',
                      style: AppTextStyles.labelMedium.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Gap(6),
                  TextField(
                    controller: _confirmController,
                    obscureText: _obscureConfirm,
                    style: AppTextStyles.bodyLarge.copyWith(color: textColor),
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
                      hintStyle: AppTextStyles.bodyLarge.copyWith(
                        color: isDark ? AppColors.grey600 : AppColors.grey400,
                      ),
                      prefixIcon:
                          Icon(Icons.lock_outline, color: secondaryColor),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirm
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: secondaryColor,
                        ),
                        onPressed: () => setState(
                            () => _obscureConfirm = !_obscureConfirm),
                      ),
                      filled: true,
                      fillColor:
                          isDark ? AppColors.grey800 : AppColors.grey100,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const Gap(16),

                  // --- Requirements Checklist ---
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _RequirementRow(
                          met: _hasMinLength,
                          label: 'At least 8 characters',
                          textColor: textColor,
                        ),
                        const Gap(6),
                        _RequirementRow(
                          met: _hasNumber,
                          label: 'Contains a number',
                          textColor: textColor,
                        ),
                        const Gap(6),
                        _RequirementRow(
                          met: _hasSpecialChar,
                          label: 'Contains a special character',
                          textColor: textColor,
                        ),
                      ],
                    ),
                  ),

                  const Gap(24),

                  // --- Reset Password Button ---
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _handleReset,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        disabledBackgroundColor:
                            AppColors.primary.withOpacity(0.6),
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
                              'Reset Password',
                              style: AppTextStyles.labelLarge.copyWith(
                                color: AppColors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),

                  const Gap(20),

                  // --- Back to Log In ---
                  GestureDetector(
                    onTap: () => context.go('/login'),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back, size: 16, color: AppColors.goldDark),
                        const Gap(6),
                        Text(
                          'Back to Log In',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.goldDark,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Gap(24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Requirement Checklist Row ---
class _RequirementRow extends StatelessWidget {
  final bool met;
  final String label;
  final Color textColor;

  const _RequirementRow({
    required this.met,
    required this.label,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          met ? Icons.check_circle : Icons.check_circle_outline,
          size: 18,
          color: met ? AppColors.success : AppColors.grey400,
        ),
        const Gap(8),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: met ? textColor : AppColors.grey400,
            fontWeight: met ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}