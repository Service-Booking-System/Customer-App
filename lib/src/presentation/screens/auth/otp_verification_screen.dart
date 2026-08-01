import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer_app/core/constants/app_assets.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/src/presentation/screens/auth/customer_details_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  int _resendCountdown = 30;
  Timer? _timer;
  bool _canResend = false;
  bool _isComplete = false;
  bool _isVerifying = false;

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

    _startResendTimer();

    // Auto focus first OTP input box
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) {
        _focusNodes[0].requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    _animController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendCountdown = 30;
      _canResend = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 1) {
        setState(() {
          _resendCountdown--;
        });
      } else {
        setState(() {
          _resendCountdown = 0;
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _checkOtpCompletion() {
    final code = _controllers.map((c) => c.text).join();
    final complete = code.length == 6;
    if (complete != _isComplete) {
      setState(() {
        _isComplete = complete;
      });
    }

    if (complete) {
      _verifyOtp();
    }
  }

  void _onDigitEntered(int index, String value) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
    }
    _checkOtpCompletion();
  }

  void _verifyOtp() async {
    if (_isVerifying) return;
    HapticFeedback.mediumImpact();

    setState(() {
      _isVerifying = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    if (!mounted) return;

    setState(() {
      _isVerifying = false;
    });

    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => const CustomerDetailsScreen(),
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
                    AppAssets.otpHeader,
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: AppColors.darkHeaderBg,
                        child: const Center(
                          child: Icon(
                            Icons.mark_email_read_rounded,
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
                                          'Verification Code',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 30.sp,
                                            fontWeight: FontWeight.w800,
                                            color: AppColors.textHeadline,
                                            height: 1.15,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                        SizedBox(height: 10.h),

                                        // Subtitle & Edit Link
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text.rich(
                                                TextSpan(
                                                  text:
                                                      'Enter the 6-digit code sent to ',
                                                  style: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontSize: 14.sp,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.textSecondary,
                                                    height: 1.4,
                                                  ),
                                                  children: [
                                                    TextSpan(
                                                      text: widget.phoneNumber,
                                                      style: GoogleFonts
                                                          .plusJakartaSans(
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors
                                                            .textHeadline,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () =>
                                                  Navigator.of(context).pop(),
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w,
                                                  vertical: 4.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: AppColors.primary
                                                      .withValues(alpha: 0.08),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                child: Text(
                                                  'Edit',
                                                  style: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontSize: 12.5.sp,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.primary,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(height: 28.h),

                                        // 6 OTP Digit Input Boxes
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: List.generate(6, (index) {
                                            return _buildOtpBox(index);
                                          }),
                                        ),

                                        SizedBox(height: 24.h),

                                        // Resend Code Row
                                        Center(
                                          child: _canResend
                                              ? InkWell(
                                                  onTap: () {
                                                    HapticFeedback.lightImpact();
                                                    _startResendTimer();
                                                    ScaffoldMessenger.of(context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          'Resent a new code to ${widget.phoneNumber}',
                                                          style: GoogleFonts
                                                              .plusJakartaSans(
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                        backgroundColor:
                                                            AppColors
                                                                .primaryDark,
                                                        behavior: SnackBarBehavior
                                                            .floating,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      12.r),
                                                        ),
                                                        duration: const Duration(
                                                            seconds: 2),
                                                      ),
                                                    );
                                                  },
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.r),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                      horizontal: 8.w,
                                                      vertical: 4.h,
                                                    ),
                                                    child: Text(
                                                      'Didn\'t receive code? Resend Code',
                                                      style: GoogleFonts
                                                          .plusJakartaSans(
                                                        fontSize: 13.5.sp,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: AppColors.primary,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Text(
                                                  'Resend code in 00:${_resendCountdown.toString().padLeft(2, '0')}',
                                                  style: GoogleFonts
                                                      .plusJakartaSans(
                                                    fontSize: 13.5.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        AppColors.textSecondary,
                                                  ),
                                                ),
                                        ),

                                        const Spacer(),

                                        // Verify Action Button
                                        Padding(
                                          padding: EdgeInsets.only(
                                            bottom: 20.h,
                                            top: 16.h,
                                          ),
                                          child: _buildVerifyButton(),
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

  Widget _buildOtpBox(int index) {
    final controller = _controllers[index];
    final focusNode = _focusNodes[index];
    final isFocused = focusNode.hasFocus;
    final hasValue = controller.text.isNotEmpty;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 44.w,
      height: 52.h,
      decoration: BoxDecoration(
        color: isFocused ? Colors.white : const Color(0xFFF6F8F3),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isFocused
              ? AppColors.primary
              : (hasValue
                  ? AppColors.primary.withValues(alpha: 0.5)
                  : AppColors.borderUnselected),
          width: isFocused ? 2.0 : 1.2,
        ),
        boxShadow: isFocused
            ? [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Center(
        child: KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: (event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.backspace &&
                controller.text.isEmpty &&
                index > 0) {
              _focusNodes[index - 1].requestFocus();
            }
          },
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(1),
            ],
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textHeadline,
            ),
            onChanged: (value) => _onDigitEntered(index, value),
            decoration: const InputDecoration(
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVerifyButton() {
    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          boxShadow: _isComplete
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
          onPressed: _isComplete ? _verifyOtp : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isComplete
                ? AppColors.buttonBackground
                : const Color(0xFFE2E4DE),
            foregroundColor: _isComplete
                ? AppColors.buttonText
                : AppColors.textSecondary,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
          ),
          child: _isVerifying
              ? SizedBox(
                  width: 24.r,
                  height: 24.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.white,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Verify & Continue',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color:
                            _isComplete ? Colors.white : AppColors.textSecondary,
                        letterSpacing: 0.1,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color:
                          _isComplete ? Colors.white : AppColors.textSecondary,
                      size: 22,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
