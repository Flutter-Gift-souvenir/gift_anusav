import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart'; 
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/shimmer_card.dart';
import '../../services/auth_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool _isLoading = true;
  bool _isUploadingPhoto = false; 


  String? _avatarUrl;


  File? _pickedImageFile;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _simulateLoad();
  }

  Future<void> _simulateLoad() async {
    try {
      final profile = await AuthService.getProfile();
      if (profile != null && mounted) {
        setState(() {
          _nameController.text = profile['full_name'] ?? '';
          _phoneController.text = profile['phone'] ?? '';
          _birthdayController.text = profile['birthday'] ?? '';
          _selectedGender = profile['gender'] ?? 'Female';
          _avatarUrl = profile['avatar_url']; 
        });
      }
    } catch (e) {
      // silently fail — fields stay empty
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- Controllers ---
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdayController = TextEditingController();

  String _selectedGender = 'Female';
  final List<String> _genderOptions = ['Female', 'Male', 'Other'];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }


  Future<void> _pickAndUploadAvatar() async {
    try {

      final XFile? picked = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (picked == null) return;

      final file = File(picked.path);


      setState(() {
        _pickedImageFile = file;
        _isUploadingPhoto = true;
      });

      final newUrl = await AuthService.uploadAvatar(file);

      if (!mounted) return;
      setState(() {
        _avatarUrl = newUrl;
        _isUploadingPhoto = false;
      });
      AppHelpers.showSnackBar(context, 'Profile photo updated!');
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isUploadingPhoto = false;
        _pickedImageFile = null; 
      });
      debugPrint('🔴 Avatar upload error: $e'); 
      AppHelpers.showSnackBar(context, 'Could not update photo. Try again.');
    }
  }

  // --- Date Picker ---
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1995, 10, 14),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDark
                ? const ColorScheme.dark(
                    primary: AppColors.primaryLight,
                    onPrimary: AppColors.white,
                    surface: AppColors.surfaceDark,
                    onSurface: AppColors.textPrimaryDark,
                  )
                : const ColorScheme.light(
                    primary: AppColors.primary,
                    onPrimary: AppColors.white,
                    onSurface: AppColors.textPrimaryLight,
                  ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text =
            '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  }

  Future<void> _saveChanges() async {
    final email = _emailController.text.trim();

    if (email.isNotEmpty) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      if (!emailRegex.hasMatch(email)) {
        AppHelpers.showSnackBar(context, 'Please enter a valid email address');
        return;
      }
    }

    try {
      await AuthService.updateProfile(
        fullName: _nameController.text.trim().isNotEmpty
            ? _nameController.text.trim()
            : null,
        phone: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
        birthday: _birthdayController.text.isNotEmpty
            ? _birthdayController.text
            : null,
        gender: _selectedGender,
      );

      if (!mounted) return;
      AppHelpers.showSnackBar(context, 'Profile updated successfully!');
      context.pop();
    } catch (e) {
      AppHelpers.showSnackBar(context, 'Failed to update profile. Try again.');
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
        child: Column(
          children: [
            // --- Header ---
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: textColor),
                    onPressed: () => context.pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Edit Profile',
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // --- Content ---
            Expanded(
              child: _isLoading
                  ? const _EditProfileShimmer()
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.defaultPadding,
                      ),
                      child: Column(
                        children: [
                          const Gap(8),

                          // --- Avatar ---
                          Stack(
                            children: [
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary
                                        .withValues(alpha: 0.3),
                                    width: 3,
                                  ),
                                ),
                                child: ClipOval(
                                  child: _buildAvatarImage(),
                                ),
                              ),
                              if (_isUploadingPhoto)
                                Positioned.fill(
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.black26,
                                    ),
                                    child: const Center(
                                      child: SizedBox(
                                        width: 28,
                                        height: 28,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: _isUploadingPhoto
                                      ? null
                                      : _pickAndUploadAvatar,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isDark
                                            ? AppColors.backgroundDark
                                            : AppColors.backgroundLight,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 18,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const Gap(12),

                          // --- Member Badge ---
                          Text(
                            'ANUSAV GOLD MEMBER',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.goldDark,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.2,
                            ),
                          ),

                          const Gap(24),

                          // --- Form Card ---
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.surfaceDark
                                  : AppColors.white,
                              borderRadius: BorderRadius.circular(
                                AppConstants.cardBorderRadius,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.black
                                      .withValues(alpha: 0.04),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Full Name
                                _buildLabel('Full Name', secondaryColor),
                                _buildTextField(
                                  controller: _nameController,
                                  hint: 'Sopheak Vuthy',
                                  isDark: isDark,
                                ),

                                const Gap(16),

                                // Email
                                _buildLabel('Email Address', secondaryColor),
                                _buildTextField(
                                  controller: _emailController,
                                  hint: 'sopheak.v@anusav.com',
                                  isDark: isDark,
                                  keyboardType: TextInputType.emailAddress,
                                ),

                                const Gap(16),

                                // Phone
                                _buildLabel('Phone Number', secondaryColor),
                                _buildTextField(
                                  controller: _phoneController,
                                  hint: '+855 12 345 678',
                                  isDark: isDark,
                                  keyboardType: TextInputType.phone,
                                ),

                                const Gap(16),

                                // Birthday + Gender row
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    // Birthday
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel(
                                              'Birthday', secondaryColor),
                                          _buildTextField(
                                            controller: _birthdayController,
                                            hint: '10/14/1995',
                                            isDark: isDark,
                                            readOnly: true,
                                            onTap: _pickDate,
                                            suffixIcon:
                                                Icons.calendar_today_outlined,
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Gap(12),

                                    // Gender
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          _buildLabel(
                                              'Gender', secondaryColor),
                                          _buildGenderDropdown(
                                              isDark, textColor),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const Gap(24),
                        ],
                      ),
                    ),
            ),

            // --- Save Button ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.save_outlined, size: 18),
                      const Gap(8),
                      Text(
                        'Save Changes',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAvatarImage() {
    if (_pickedImageFile != null) {
      return Image.file(_pickedImageFile!, fit: BoxFit.cover);
    }
    if (_avatarUrl != null && _avatarUrl!.isNotEmpty) {
      return Image.network(
        _avatarUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          color: AppColors.grey200,
          child: const Icon(
            Icons.person,
            size: 56,
            color: AppColors.grey400,
          ),
        ),
      );
    }
    return Container(
      color: AppColors.grey200,
      child: const Icon(
        Icons.person,
        size: 56,
        color: AppColors.grey400,
      ),
    );
  }

  // --- Field Label ---
  Widget _buildLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(color: color),
      ),
    );
  }

  // --- Text Field ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    TextInputType? keyboardType,
    bool readOnly = false,
    VoidCallback? onTap,
    IconData? suffixIcon,
  }) {
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: readOnly,
      onTap: onTap,
      style: AppTextStyles.bodyLarge.copyWith(color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyLarge.copyWith(
          color: isDark ? AppColors.grey600 : AppColors.grey400,
        ),
        filled: true,
        fillColor: isDark ? AppColors.grey800 : AppColors.grey100,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, color: AppColors.grey400, size: 20)
            : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // --- Gender Dropdown ---
  Widget _buildGenderDropdown(bool isDark, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey800 : AppColors.grey100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.grey400,
          ),
          style: AppTextStyles.bodyLarge.copyWith(color: textColor),
          dropdownColor: isDark ? AppColors.surfaceDark : AppColors.white,
          items: _genderOptions
              .map(
                (gender) => DropdownMenuItem(
                  value: gender,
                  child: Text(gender),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() => _selectedGender = value);
            }
          },
        ),
      ),
    );
  }
}

// --- Shimmer Loading Placeholder ---
class _EditProfileShimmer extends StatelessWidget {
  const _EditProfileShimmer();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
      ),
      child: Column(
        children: [
          const Gap(8),
          const Center(child: ShimmerCard(height: 110, width: 110)),
          const Gap(12),
          const Center(child: ShimmerCard(height: 16, width: 160)),
          const Gap(24),
          const ShimmerCard(height: 320),
          const Gap(24),
        ],
      ),
    );
  }
}