import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/src/data/repositories/profile_repository_impl.dart';
import 'package:customer_app/src/domain/entities/payment_card.dart';
import 'package:customer_app/src/presentation/screens/profile/add_card_screen.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ProfileRepositoryImpl();

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
          'Payment Methods & Wallet',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.accentLime),
            onPressed: () {
              HapticFeedback.lightImpact();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const AddCardScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<PaymentCard>>(
        stream: repository.watchPaymentCards(),
        builder: (context, snapshot) {
          final cards = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Label
                Text(
                  'Card Wallet Pouch',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16.5.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textHeadline,
                  ),
                ),
                SizedBox(height: 12.h),

                if (cards.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(color: AppColors.borderUnselected),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.credit_card_off_rounded,
                            size: 48.r, color: AppColors.textMuted),
                        SizedBox(height: 12.h),
                        Text(
                          'No Cards in Pouch',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textHeadline,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'Add a card to view your interactive wallet pouch stack.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.sp,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  _WalletPouchWidget(cards: cards, repository: repository),

                SizedBox(height: 28.h),

                // Section: Payment Next / Service Bills (Matching User Reference Image)
                Text(
                  'Payment Next',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textHeadline,
                  ),
                ),
                SizedBox(height: 14.h),

                _buildPaymentItemTile(
                  title: 'HVAC Air Conditioning Service',
                  provider: 'Cool Breeze Repair Co.',
                  amount: '\$836.94',
                  dueDate: 'Due date 18',
                  installmentInfo: '1 of 4 installment',
                  buttonLabel: 'Pay Now',
                  icon: Icons.ac_unit_rounded,
                ),
                SizedBox(height: 12.h),

                _buildPaymentItemTile(
                  title: 'Plumbing & Water Leak Repair',
                  provider: 'QuickFix Plumbing',
                  amount: '\$563.04',
                  dueDate: 'Due date 18',
                  installmentInfo: '3 of 4 installment',
                  buttonLabel: 'Pay Now',
                  icon: Icons.plumbing_rounded,
                ),
                SizedBox(height: 12.h),

                _buildPaymentItemTile(
                  title: 'Smart Lock & Security Install',
                  provider: 'SafeHome Security',
                  amount: '\$246.94',
                  dueDate: 'Due date 24',
                  installmentInfo: 'Completed',
                  buttonLabel: 'Receipt',
                  icon: Icons.security_rounded,
                  isPaid: true,
                ),
                SizedBox(height: 24.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaymentItemTile({
    required String title,
    required String provider,
    required String amount,
    required String dueDate,
    required String installmentInfo,
    required String buttonLabel,
    required IconData icon,
    bool isPaid = false,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.borderUnselected, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.cardSelectedBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: AppColors.primary, size: 22.r),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14.5.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHeadline,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      provider,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textHeadline,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    dueDate,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.sp,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12.h),
          const Divider(height: 1, color: AppColors.borderUnselected),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.info_outline_rounded, size: 14.r, color: AppColors.textMuted),
                  SizedBox(width: 4.w),
                  Text(
                    installmentInfo,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.sp,
                      color: AppColors.textMuted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                },
                child: Text(
                  buttonLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w800,
                    color: isPaid ? AppColors.textMuted : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WalletPouchWidget extends StatefulWidget {
  final List<PaymentCard> cards;
  final ProfileRepositoryImpl repository;

  const _WalletPouchWidget({
    required this.cards,
    required this.repository,
  });

  @override
  State<_WalletPouchWidget> createState() => _WalletPouchWidgetState();
}

class _WalletPouchWidgetState extends State<_WalletPouchWidget> {
  late String _activeCardId;

  @override
  void initState() {
    super.initState();
    final defaultCard = widget.cards.firstWhere(
      (c) => c.isDefault == true,
      orElse: () => widget.cards.first,
    );
    _activeCardId = defaultCard.id;
  }

  @override
  void didUpdateWidget(covariant _WalletPouchWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.cards.any((c) => c.id == _activeCardId) && widget.cards.isNotEmpty) {
      _activeCardId = widget.cards.first.id;
    }
  }

  PaymentCard get _activeCard {
    return widget.cards.firstWhere(
      (c) => c.id == _activeCardId,
      orElse: () => widget.cards.first,
    );
  }

  List<PaymentCard> get _otherCards {
    return widget.cards.where((c) => c.id != _activeCardId).toList();
  }

  void _selectCard(String id) {
    HapticFeedback.mediumImpact();
    setState(() {
      _activeCardId = id;
    });
    widget.repository.setDefaultPaymentCard(id);
  }

  @override
  Widget build(BuildContext context) {
    final activeCard = _activeCard;
    final otherCards = _otherCards;

    final isFrozen = activeCard.isFrozen;
    final limit = activeCard.cardLimit;

    return Column(
      children: [
        // 1. Stacked Pouch Visual Container
        Container(
          width: double.infinity,
          height: 250.h,
          decoration: BoxDecoration(
            color: const Color(0xFF23271D), // Stitched dark leather pouch background
            borderRadius: BorderRadius.circular(28.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Stacked Non-Primary Cards (Peeking from behind inside pouch)
              ...List.generate(otherCards.length, (index) {
                final card = otherCards[index];
                final topOffset = 14.h + (index * 24.h);
                final scale = 0.94 - (index * 0.03);

                return Positioned(
                  top: topOffset,
                  left: 20.w + (index * 8.w),
                  right: 20.w + (index * 8.w),
                  child: Transform.scale(
                    scale: scale,
                    alignment: Alignment.topCenter,
                    child: GestureDetector(
                      onTap: () => _selectCard(card.id),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        height: 140.h,
                        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.r),
                          gradient: LinearGradient(
                            colors: card.brand == CardBrand.visa
                                ? const [Color(0xFF636B2F), Color(0xFFBAC095)]
                                : const [Color(0xFF4A4E38), Color(0xFF23271D)],
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                _buildBrandIcon(card.brand),
                                SizedBox(width: 10.w),
                                Text(
                                  '•••• ${card.lastFourDigits}',
                                  style: GoogleFonts.shareTechMono(
                                    color: Colors.white,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.18),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'Tap to Select',
                                style: GoogleFonts.plusJakartaSans(
                                  color: AppColors.accentLime,
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // Front Primary Card (Top of Pouch)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 185.h,
                  margin: EdgeInsets.all(12.w),
                  padding: EdgeInsets.all(20.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.r),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: activeCard.brand == CardBrand.mastercard
                          ? const [Color(0xFF3D4127), Color(0xFF636B2F)]
                          : const [Color(0xFF636B2F), Color(0xFF3D4127)],
                    ),
                    border: Border.all(
                        color: AppColors.accentLime.withValues(alpha: 0.4), width: 1.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
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
                          _buildBrandIcon(activeCard.brand),
                          Row(
                            children: [
                              if (isFrozen) ...[
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                                  decoration: BoxDecoration(
                                    color: Colors.cyan.shade900.withValues(alpha: 0.8),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.ac_unit_rounded, color: Colors.cyanAccent, size: 12.r),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'FROZEN',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: Colors.cyanAccent,
                                          fontSize: 9.5.sp,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 8.w),
                              ],
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: AppColors.accentLime,
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                                child: Text(
                                  'PRIMARY',
                                  style: GoogleFonts.plusJakartaSans(
                                    color: AppColors.primaryDark,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '•••• •••• •••• ${activeCard.lastFourDigits}',
                        style: GoogleFonts.shareTechMono(
                          color: Colors.white,
                          fontSize: 19.sp,
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
                                'Limit Card',
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFFC7CBC0),
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                '\$${limit.toStringAsFixed(2).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')}',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Exp ${activeCard.expiryDate}',
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFFC7CBC0),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // 2. Action Buttons Row (Directly matching user image layout!)
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: Icons.credit_card_rounded,
                label: 'Card Details',
                onTap: () => _showCardDetailsModal(context, activeCard),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildActionButton(
                icon: isFrozen ? Icons.lock_open_rounded : Icons.ac_unit_rounded,
                label: isFrozen ? 'Unfreeze' : 'Freeze Card',
                isHighlight: isFrozen,
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  await widget.repository.toggleFreezePaymentCard(activeCard.id);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isFrozen
                              ? 'Card unfrozen successfully!'
                              : 'Card frozen. Transactions blocked.',
                          style: GoogleFonts.plusJakartaSans(color: Colors.white),
                        ),
                        backgroundColor: AppColors.primaryDark,
                      ),
                    );
                  }
                },
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: _buildActionButton(
                icon: Icons.more_horiz_rounded,
                label: 'More',
                onTap: () => _showMoreCardOptions(context, activeCard),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandIcon(CardBrand brand) {
    String text = 'VISA';
    if (brand == CardBrand.mastercard) text = 'MC';
    if (brand == CardBrand.amex) text = 'AMEX';

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(color: Colors.white24, width: 0.8),
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.accentLime,
          fontWeight: FontWeight.w900,
          fontSize: 12.sp,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isHighlight = false,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: isHighlight ? AppColors.accentLime : Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isHighlight ? AppColors.primary : AppColors.borderUnselected,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 22.r,
              color: isHighlight ? AppColors.primaryDark : AppColors.primary,
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5.sp,
                fontWeight: FontWeight.w700,
                color: isHighlight ? AppColors.primaryDark : AppColors.textHeadline,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCardDetailsModal(BuildContext context, PaymentCard card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.borderUnselected,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Card Details',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textHeadline,
                ),
              ),
              SizedBox(height: 16.h),
              _buildDetailRow('Cardholder Name', card.cardholderName),
              const Divider(),
              _buildDetailRow('Card Number', '•••• •••• •••• ${card.lastFourDigits}'),
              const Divider(),
              _buildDetailRow('Expiry Date', card.expiryDate),
              const Divider(),
              _buildDetailRow('Card Limit', '\$${card.cardLimit.toStringAsFixed(2)}'),
              const Divider(),
              _buildDetailRow('Card Status', card.isFrozen ? 'Frozen' : 'Active'),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.buttonBackground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5.sp,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14.5.sp,
              color: AppColors.textHeadline,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void _showMoreCardOptions(BuildContext context, PaymentCard card) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            title: Text(
              'Delete Card',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
            onTap: () async {
              Navigator.of(ctx).pop();
              await widget.repository.deletePaymentCard(card.id);
            },
          ),
        ],
      ),
    );
  }
}
