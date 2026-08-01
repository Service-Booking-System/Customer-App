import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer_app/core/constants/app_assets.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/src/presentation/screens/auth/otp_verification_screen.dart';

class CountryCode {
  final String flag;
  final String name;
  final String code;

  const CountryCode({
    required this.flag,
    required this.name,
    required this.code,
  });

  static const List<CountryCode> supported = [
    CountryCode(flag: '🇱🇰', name: 'Sri Lanka', code: '+94'),
    CountryCode(flag: '🇺🇸', name: 'United States', code: '+1'),
    CountryCode(flag: '🇬🇧', name: 'United Kingdom', code: '+44'),
    CountryCode(flag: '🇮🇳', name: 'India', code: '+91'),
    CountryCode(flag: '🇦🇺', name: 'Australia', code: '+61'),
    CountryCode(flag: '🇸🇬', name: 'Singapore', code: '+65'),
    CountryCode(flag: '🇦🇪', name: 'UAE', code: '+971'),
  ];
}

class MobileNumberScreen extends StatefulWidget {
  const MobileNumberScreen({super.key});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _phoneFocusNode = FocusNode();

  CountryCode _selectedCountry = CountryCode.supported.first;
  bool _isValidNumber = false;
  bool _isFocused = false;

  late AnimationController _animController;
  late Animation<Offset> _sheetSlideAnimation;
  late Animation<double> _sheetFadeAnimation;
  late Animation<Offset> _contentSlideAnimation;
  late Animation<double> _contentFadeAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _sheetSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _sheetFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.60, curve: Curves.easeOut),
      ),
    );

    _contentSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.20, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _contentFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.20, 0.85, curve: Curves.easeOut),
      ),
    );

    _animController.forward();

    _phoneFocusNode.addListener(() {
      setState(() {
        _isFocused = _phoneFocusNode.hasFocus;
      });
    });

    _phoneController.addListener(_validatePhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _phoneFocusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _validatePhone() {
    final text = _phoneController.text.replaceAll(' ', '');
    final valid = text.length >= 9 && text.length <= 10;
    if (valid != _isValidNumber) {
      setState(() {
        _isValidNumber = valid;
      });
    }
  }

  void _showCountryPicker() {
    HapticFeedback.selectionClick();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E4DE),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Select Country / Region',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textHeadline,
                  ),
                ),
                SizedBox(height: 12.h),
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: CountryCode.supported.length,
                    separatorBuilder: (_, index) => Divider(
                      height: 1,
                      color: Colors.grey.shade200,
                    ),
                    itemBuilder: (context, index) {
                      final country = CountryCode.supported[index];
                      final isSelected = country.code == _selectedCountry.code;

                      return ListTile(
                        onTap: () {
                          setState(() {
                            _selectedCountry = country;
                          });
                          Navigator.pop(context);
                        },
                        leading: Text(
                          country.flag,
                          style: TextStyle(fontSize: 24.sp),
                        ),
                        title: Text(
                          country.name,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15.sp,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              country.code,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (isSelected) ...[
                              SizedBox(width: 8.w),
                              Icon(
                                Icons.check_circle_rounded,
                                color: AppColors.primary,
                                size: 20.r,
                              ),
                            ],
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleSendCode() {
    if (!_isValidNumber) return;

    HapticFeedback.mediumImpact();
    final fullNumber = '${_selectedCountry.code} ${_phoneController.text}';

    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => OtpVerificationScreen(
          phoneNumber: fullNumber,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.darkHeaderBg,
        body: Stack(
          children: [
            // Top Section - Header Photo Banner
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: (screenHeight * 0.38).clamp(200.0, 360.0),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    AppAssets.phoneHeader,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.darkHeaderBg,
                        child: const Center(
                          child: Icon(
                            Icons.phone_android_rounded,
                            size: 64,
                            color: Colors.white24,
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 100.h,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.45),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Top-Left Circular Back Button
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 10.h,
                  ),
                  child: Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.94),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.8),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        splashColor: AppColors.primary.withValues(alpha: 0.15),
                        highlightColor:
                            AppColors.primary.withValues(alpha: 0.08),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          Navigator.of(context).maybePop();
                        },
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(left: 3.w),
                            child: Icon(
                              Icons.arrow_back_ios_new_rounded,
                              size: 18.r,
                              color: AppColors.textHeadline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Section - Animated White Card Sheet
            Positioned(
              top: (screenHeight * 0.33).clamp(180.0, 320.0),
              left: 0,
              right: 0,
              bottom: 0,
              child: SlideTransition(
                position: _sheetSlideAnimation,
                child: FadeTransition(
                  opacity: _sheetFadeAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.sheetBackground,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36.r),
                        topRight: Radius.circular(36.r),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.16),
                          blurRadius: 24,
                          offset: const Offset(0, -6),
                        ),
                      ],
                    ),
                    child: SafeArea(
                      top: false,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: IntrinsicHeight(
                                child: SlideTransition(
                                  position: _contentSlideAnimation,
                                  child: FadeTransition(
                                    opacity: _contentFadeAnimation,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Top Grabber Pill
                                        Center(
                                          child: Container(
                                            margin: EdgeInsets.only(
                                              top: 12.h,
                                              bottom: 6.h,
                                            ),
                                            width: 38.w,
                                            height: 4.h,
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE2E4DE),
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                            ),
                                          ),
                                        ),

                                        SizedBox(height: 16.h),

                                        // Title
                                        Text(
                                          'Enter your\nMobile Number',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 30.sp,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.textHeadline,
                                            height: 1.15,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),

                                        // Subtitle
                                        Text(
                                          'We will send you a 4-digit verification code to confirm your number.',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 14.5.sp,
                                            fontWeight: FontWeight.w500,
                                            color: AppColors.textSecondary,
                                            height: 1.4,
                                            letterSpacing: -0.1,
                                          ),
                                        ),
                                        SizedBox(height: 28.h),

                                        // Phone Input Field Card
                                        _buildPhoneInputField(),

                                        SizedBox(height: 14.h),

                                        // SMS Security Badge
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.lock_outline_rounded,
                                              size: 15.r,
                                              color: AppColors.textSecondary,
                                            ),
                                            SizedBox(width: 6.w),
                                            Text(
                                              'Your info is safe and secured with us',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 12.5.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textSecondary,
                                              ),
                                            ),
                                          ],
                                        ),

                                        const Spacer(),

                                        // Terms Notice
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 12.h,
                                          ),
                                          child: Text.rich(
                                            TextSpan(
                                              text:
                                                  'By continuing, you agree to JobHive\'s ',
                                              style:
                                                  GoogleFonts.plusJakartaSans(
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.textSecondary,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: 'Terms of Service',
                                                  style: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.primary,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                                const TextSpan(text: ' & '),
                                                TextSpan(
                                                  text: 'Privacy Policy',
                                                  style: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.primary,
                                                    decoration: TextDecoration
                                                        .underline,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),

                                        // Send Code Action Button
                                        Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 20.h,
                                            top: 4.h,
                                          ),
                                          child: _buildSendCodeButton(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneInputField() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _isFocused
            ? Colors.white
            : const Color(0xFFF6F8F3),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: _isFocused
              ? AppColors.primary
              : (_isValidNumber
                  ? AppColors.primary.withValues(alpha: 0.6)
                  : AppColors.borderUnselected),
          width: _isFocused ? 2.0 : 1.2,
        ),
        boxShadow: _isFocused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  blurRadius: 14,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          // Country Selector Button
          InkWell(
            onTap: _showCountryPicker,
            borderRadius: BorderRadius.circular(12.r),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 10.h),
              child: Row(
                children: [
                  Text(
                    _selectedCountry.flag,
                    style: TextStyle(fontSize: 22.sp),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    _selectedCountry.code,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textHeadline,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 20.r,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          // Vertical Divider
          Container(
            height: 28.h,
            width: 1.2,
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            color: const Color(0xFFE2E4DE),
          ),

          // Phone Number Input
          Expanded(
            child: TextField(
              controller: _phoneController,
              focusNode: _phoneFocusNode,
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ],
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textHeadline,
                letterSpacing: 1.2,
              ),
              decoration: InputDecoration(
                hintText: '77 123 4567',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary.withValues(alpha: 0.5),
                  letterSpacing: 0.5,
                ),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 12.h),
              ),
            ),
          ),

          // Status / Clear Indicator
          if (_phoneController.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _phoneController.clear();
              },
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: Icon(
                  _isValidNumber
                      ? Icons.check_circle_rounded
                      : Icons.cancel_rounded,
                  color: _isValidNumber
                      ? AppColors.primary
                      : Colors.grey.shade400,
                  size: 22.r,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSendCodeButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: AnimatedElevatedButton(
        onPressed: _isValidNumber ? _handleSendCode : null,
        isEnabled: _isValidNumber,
      ),
    );
  }
}

class AnimatedElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isEnabled;

  const AnimatedElevatedButton({
    super.key,
    required this.onPressed,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28.r),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ]
            : [],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isEnabled
              ? AppColors.buttonBackground
              : const Color(0xFFE2E4DE),
          foregroundColor: isEnabled
              ? AppColors.buttonText
              : AppColors.textSecondary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Send Code',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: isEnabled ? Colors.white : AppColors.textSecondary,
                letterSpacing: 0.1,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_rounded,
              color: isEnabled ? Colors.white : AppColors.textSecondary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
