import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer_app/core/constants/app_colors.dart';

class ProfileTab extends StatelessWidget {
  final VoidCallback? onAddPropertyTap;

  const ProfileTab({super.key, this.onAddPropertyTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: AppColors.darkHeaderBg,
              padding: EdgeInsets.fromLTRB(20.w, 60.h, 20.w, 30.h),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64.r,
                        height: 64.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.accentLime, width: 2),
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryLight],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'A',
                            style: GoogleFonts.plusJakartaSans(
                              color: Colors.white,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Alex Johnson',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              '+1 (555) 382-9102 • Member since 2026',
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFFC7CBC0),
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Profile Options
            Padding(
              padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 110.h),
              child: Column(
                children: [
                  _buildOptionTile(
                    icon: Icons.location_city_rounded,
                    title: 'Manage Properties',
                    subtitle: '3 properties registered',
                    onTap: () {
                      HapticFeedback.lightImpact();
                      onAddPropertyTap?.call();
                    },
                  ),
                  _buildOptionTile(
                    icon: Icons.credit_card_rounded,
                    title: 'Payment Methods',
                    subtitle: 'Apple Pay, Visa ending 4920',
                    onTap: () {},
                  ),
                  _buildOptionTile(
                    icon: Icons.history_rounded,
                    title: 'Service History & Invoices',
                    subtitle: 'View receipts & past bookings',
                    onTap: () {},
                  ),
                  _buildOptionTile(
                    icon: Icons.support_agent_rounded,
                    title: 'Help & 24/7 Support',
                    subtitle: 'Live chat with customer care',
                    onTap: () {},
                  ),
                  _buildOptionTile(
                    icon: Icons.security_rounded,
                    title: 'Privacy & Security',
                    subtitle: 'Passcode, Biometrics, Permissions',
                    onTap: () {},
                  ),
                  _buildOptionTile(
                    icon: Icons.logout_rounded,
                    title: 'Log Out',
                    subtitle: 'Sign out of this device',
                    isDestructive: true,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderUnselected),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
            color: isDestructive
                ? Colors.red.shade50
                : AppColors.cardSelectedBg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(
            icon,
            color: isDestructive ? Colors.red : AppColors.primary,
            size: 22.r,
          ),
        ),
        title: Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14.5.sp,
            fontWeight: FontWeight.w700,
            color: isDestructive ? Colors.red : AppColors.textHeadline,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.sp,
            color: AppColors.textMuted,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 14.r,
          color: AppColors.borderUnselected,
        ),
      ),
    );
  }
}
