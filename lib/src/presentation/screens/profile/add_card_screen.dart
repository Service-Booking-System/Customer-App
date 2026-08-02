import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/src/data/repositories/profile_repository_impl.dart';
import 'package:customer_app/src/domain/entities/payment_card.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({super.key});

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  bool _isDefault = true;
  CardBrand _detectedBrand = CardBrand.visa;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _cardNumberController.addListener(_onCardNumberChanged);
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _onCardNumberChanged() {
    final text = _cardNumberController.text;
    if (text.startsWith('5')) {
      setState(() => _detectedBrand = CardBrand.mastercard);
    } else if (text.startsWith('3')) {
      setState(() => _detectedBrand = CardBrand.amex);
    } else {
      setState(() => _detectedBrand = CardBrand.visa);
    }
  }

  Future<void> _submitCard() async {
    final rawNumber = _cardNumberController.text.replaceAll(' ', '');
    final name = _cardHolderController.text.trim();
    final expiry = _expiryController.text.trim();
    final cvv = _cvvController.text.trim();

    if (rawNumber.length < 15 || name.isEmpty || expiry.isEmpty || cvv.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please complete all card details correctly.',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    HapticFeedback.mediumImpact();

    final lastFour = rawNumber.substring(rawNumber.length - 4);
    final card = PaymentCard(
      id: 'card_${DateTime.now().millisecondsSinceEpoch}',
      cardholderName: name,
      lastFourDigits: lastFour,
      expiryDate: expiry,
      brand: _detectedBrand,
      isDefault: _isDefault,
      gradientColors: _detectedBrand == CardBrand.mastercard
          ? [0xFF636B2F, 0xFFBAC095]
          : [0xFF3D4127, 0xFF636B2F],
    );

    await ProfileRepositoryImpl().addPaymentCard(card);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Card added successfully!',
            style: GoogleFonts.plusJakartaSans(color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkHeaderBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Add Payment Card',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Live Interactive Credit Card Preview
            _buildInteractiveCardPreview(),
            SizedBox(height: 28.h),

            // Cardholder Name Field
            _buildInputField(
              label: 'Cardholder Name',
              controller: _cardHolderController,
              hint: 'e.g. Alex Johnson',
              icon: Icons.person_outline_rounded,
            ),
            SizedBox(height: 16.h),

            // Card Number Field
            _buildInputField(
              label: 'Card Number',
              controller: _cardNumberController,
              hint: '4111 2222 3333 4920',
              icon: Icons.credit_card_rounded,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ],
            ),
            SizedBox(height: 16.h),

            // Expiry Date & CVV Row
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    label: 'Expiry Date',
                    controller: _expiryController,
                    hint: 'MM/YY',
                    icon: Icons.calendar_today_rounded,
                    keyboardType: TextInputType.datetime,
                    inputFormatters: [LengthLimitingTextInputFormatter(5)],
                  ),
                ),
                SizedBox(width: 14.w),
                Expanded(
                  child: _buildInputField(
                    label: 'CVV Security',
                    controller: _cvvController,
                    hint: '123',
                    icon: Icons.lock_outline_rounded,
                    keyboardType: TextInputType.number,
                    obscureText: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),

            // Set as Default Switch Tile
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.borderUnselected),
              ),
              child: Row(
                children: [
                  Icon(Icons.star_rounded, color: AppColors.primary, size: 22.r),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Set as default payment method',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textHeadline,
                      ),
                    ),
                  ),
                  Switch.adaptive(
                    value: _isDefault,
                    activeTrackColor: AppColors.primary,
                    onChanged: (val) => setState(() => _isDefault = val),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Add Card Button
            SizedBox(
              width: double.infinity,
              height: 54.h,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitCard,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonBackground,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(27.r),
                  ),
                  elevation: 2,
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Save Card Details',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractiveCardPreview() {
    final numberText = _cardNumberController.text;
    final formattedNumber = numberText.isEmpty
        ? '•••• •••• •••• ••••'
        : numberText.replaceAllMapped(
            RegExp(r".{4}"), (match) => "${match.group(0)} ");

    return Container(
      width: double.infinity,
      height: 200.h,
      padding: EdgeInsets.all(22.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _detectedBrand == CardBrand.mastercard
              ? const [AppColors.primary, AppColors.primaryDark]
              : const [AppColors.primaryDark, Color(0xFF636B2F)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryDark.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42.w,
                height: 30.h,
                decoration: BoxDecoration(
                  color: AppColors.accentLime,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Icon(Icons.nfc_rounded, color: AppColors.primaryDark, size: 20.r),
              ),
              Text(
                _detectedBrand.name.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  color: AppColors.accentLime,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          Text(
            formattedNumber,
            style: GoogleFonts.shareTechMono(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 2.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARDHOLDER',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFC7CBC0),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _cardHolderController.text.isEmpty
                        ? 'ALEX JOHNSON'
                        : _cardHolderController.text.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'EXPIRES',
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFFC7CBC0),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    _expiryController.text.isEmpty ? 'MM/YY' : _expiryController.text,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textHeadline,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: AppColors.borderUnselected, width: 1.2),
          ),
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Row(
            children: [
              Icon(icon, size: 20.r, color: AppColors.primary),
              SizedBox(width: 10.w),
              Expanded(
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  obscureText: obscureText,
                  inputFormatters: inputFormatters,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textHeadline,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: AppColors.textMuted,
                      fontSize: 14.sp,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 14.h),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
