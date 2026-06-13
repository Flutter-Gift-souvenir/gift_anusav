import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  // --- Controllers ---
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _districtController = TextEditingController();
  final _streetController = TextEditingController();
  final MapController _mapController = MapController();

  String _selectedLabel = 'Home';
  String? _selectedProvince;
  bool _setAsDefault = false;

  final List<String> _provinces = [
    'Phnom Penh',
    'Siem Reap',
    'Battambang',
    'Kampot',
    'Sihanoukville',
    'Kampong Cham',
    'Kampong Thom',
    'Takeo',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _districtController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  void _saveAddress() {
    AppHelpers.showSnackBar(context, 'Address saved successfully!');
    context.pop();
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
                    icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                    onPressed: () => context.pop(),
                  ),
                  Text(
                    'Add New Address',
                    style: AppTextStyles.headlineMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            // --- Content ---
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- Form Card ---
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : AppColors.white,
                        borderRadius: BorderRadius.circular(
                          AppConstants.cardBorderRadius,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- Address Label Chips ---
                          _buildLabel('Address Label', textColor),
                          const Gap(8),
                          Row(
                            children: [
                              _LabelChip(
                                label: 'Home',
                                icon: Icons.home_outlined,
                                isSelected: _selectedLabel == 'Home',
                                isDark: isDark,
                                onTap: () =>
                                    setState(() => _selectedLabel = 'Home'),
                              ),
                              const Gap(8),
                              _LabelChip(
                                label: 'Work',
                                icon: Icons.work_outline,
                                isSelected: _selectedLabel == 'Work',
                                isDark: isDark,
                                onTap: () =>
                                    setState(() => _selectedLabel = 'Work'),
                              ),
                              const Gap(8),
                              _LabelChip(
                                label: 'Other',
                                icon: Icons.add,
                                isSelected: _selectedLabel == 'Other',
                                isDark: isDark,
                                onTap: () =>
                                    setState(() => _selectedLabel = 'Other'),
                              ),
                            ],
                          ),

                          const Gap(16),

                          // --- Recipient Name ---
                          _buildLabel('Recipient Name', textColor),
                          _buildTextField(
                            controller: _nameController,
                            hint: 'e.g., Serey Rath',
                            isDark: isDark,
                          ),

                          const Gap(16),

                          // --- Phone Number ---
                          _buildLabel('Phone Number', textColor),
                          Container(
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.grey800
                                  : AppColors.grey100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                  ),
                                  child: Text(
                                    '+855',
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 24,
                                  color: isDark
                                      ? AppColors.grey600
                                      : AppColors.grey400,
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: textColor,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: '12 345 678',
                                      hintStyle: AppTextStyles.bodyLarge
                                          .copyWith(
                                        color: isDark
                                            ? AppColors.grey600
                                            : AppColors.grey400,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Gap(16),

                          // --- City/Province ---
                          _buildLabel('City / Province', textColor),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.grey800
                                  : AppColors.grey100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedProvince,
                                isExpanded: true,
                                hint: Text(
                                  'Select Province',
                                  style: AppTextStyles.bodyLarge.copyWith(
                                    color: isDark
                                        ? AppColors.grey600
                                        : AppColors.grey400,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.grey400,
                                ),
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: textColor,
                                ),
                                dropdownColor: isDark
                                    ? AppColors.surfaceDark
                                    : AppColors.white,
                                items: _provinces
                                    .map(
                                      (province) => DropdownMenuItem(
                                        value: province,
                                        child: Text(province),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  setState(() => _selectedProvince = value);
                                },
                              ),
                            ),
                          ),

                          const Gap(16),

                          // --- Sangkat/District ---
                          _buildLabel('Sangkat / District', textColor),
                          _buildTextField(
                            controller: _districtController,
                            hint: 'Enter District',
                            isDark: isDark,
                          ),

                          const Gap(16),

                          // --- Street Address ---
                          _buildLabel('Street Address / House Number', textColor),
                          _buildTextField(
                            controller: _streetController,
                            hint: 'e.g., St. 123, House #45A',
                            isDark: isDark,
                            maxLines: 2,
                          ),

                          const Gap(16),

                          // --- Set as Default ---
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Set as Default Address',
                                      style: AppTextStyles.titleSmall.copyWith(
                                        color: textColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      'Use this as your primary shipping address',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: secondaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                value: _setAsDefault,
                                activeColor: AppColors.primary,
                                onChanged: (value) {
                                  setState(() => _setAsDefault = value);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const Gap(16),

                    // --- Map Preview ---
                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(AppConstants.cardBorderRadius),
                      child: SizedBox(
                        height: 180,
                        child: Stack(
                          children: [
                            FlutterMap(
                              mapController: _mapController,
                              options: MapOptions(
                                initialCenter: LatLng(
                                  AppConstants.defaultLatitude,
                                  AppConstants.defaultLongitude,
                                ),
                                initialZoom: AppConstants.defaultZoom,
                                interactionOptions: const InteractionOptions(
                                  flags: InteractiveFlag.all,
                                ),
                              ),
                              children: [
                                TileLayer(
                                  urlTemplate:
                                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                  userAgentPackageName: 'com.giftanusav.app',
                                ),
                                MarkerLayer(
                                  markers: [
                                    Marker(
                                      point: LatLng(
                                        AppConstants.defaultLatitude,
                                        AppConstants.defaultLongitude,
                                      ),
                                      width: 40,
                                      height: 40,
                                      child: const Icon(
                                        Icons.location_on,
                                        color: AppColors.primary,
                                        size: 36,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // Location button
                            Positioned(
                              top: 12,
                              right: 12,
                              child: GestureDetector(
                                onTap: () => _mapController.move(
                                  LatLng(
                                    AppConstants.defaultLatitude,
                                    AppConstants.defaultLongitude,
                                  ),
                                  AppConstants.defaultZoom,
                                ),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.black
                                            .withOpacity(0.12),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.my_location,
                                    size: 18,
                                    color: AppColors.textPrimaryLight,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
                  onPressed: _saveAddress,
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
                        'Save Address',
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

  // --- Field Label ---
  Widget _buildLabel(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: AppTextStyles.labelMedium.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // --- Text Field ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    int maxLines = 1,
  }) {
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: AppTextStyles.bodyLarge.copyWith(color: textColor),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyLarge.copyWith(
          color: isDark ? AppColors.grey600 : AppColors.grey400,
        ),
        filled: true,
        fillColor: isDark ? AppColors.grey800 : AppColors.grey100,
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
}

// --- Label Chip ---
class _LabelChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _LabelChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.grey600 : AppColors.grey400),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppColors.primary : textColor,
              ),
              const Gap(6),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? AppColors.primary : textColor,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}