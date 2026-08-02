import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/src/presentation/screens/auth/add_properties_screen.dart';
import 'package:customer_app/src/presentation/tabs/home_tab.dart';
import 'package:customer_app/src/presentation/tabs/jobs_tab.dart';
import 'package:customer_app/src/presentation/tabs/search_tab.dart';
import 'package:customer_app/src/presentation/tabs/alerts_tab.dart';
import 'package:customer_app/src/presentation/tabs/profile_tab.dart';

class MainNavigationScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavigationScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onTabSelected(int index) {
    if (_currentIndex != index) {
      HapticFeedback.mediumImpact();
      setState(() {
        _currentIndex = index;
      });
    }
  }

  void _openAddProperties() {
    HapticFeedback.lightImpact();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddPropertiesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Active Tab View
            IndexedStack(
              index: _currentIndex,
              children: [
                HomeTab(
                  onAddPropertyTap: _openAddProperties,
                  onNavigateTab: _onTabSelected,
                ),
                const JobsTab(),
                const SearchTab(),
                const AlertsTab(),
                ProfileTab(
                  onAddPropertyTap: _openAddProperties,
                ),
              ],
            ),

            // Floating Light Mode Custom Curvature Bottom Navigation Bar
            Positioned(
              left: 16.w,
              right: 16.w,
              bottom: 24.h,
              child: _buildCustomBottomNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomBottomNavigationBar() {
    final double barHeight = 72.h;

    return SizedBox(
      height: barHeight + 36.h, // Total height to accommodate the raised FAB
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // 1. Curved White Background with Smooth Scoop/Dip & Elevation Shadow
          CustomPaint(
            size: Size(double.infinity, barHeight),
            painter: CurvatureNotchedNavBarPainterLight(),
            child: SizedBox(
              height: barHeight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left Items: Home, Jobs
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            index: 0,
                            label: 'Home',
                            icon: Icons.home_rounded,
                          ),
                          _buildNavItem(
                            index: 1,
                            label: 'Jobs',
                            icon: Icons.grid_view_rounded,
                          ),
                        ],
                      ),
                    ),

                    // Gap for Center FAB
                    SizedBox(width: 74.w),

                    // Right Items: Alerts, Profile
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(
                            index: 3,
                            label: 'Alerts',
                            icon: Icons.notifications_rounded,
                          ),
                          _buildNavItem(
                            index: 4,
                            label: 'Profile',
                            icon: Icons.person_rounded,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Central Raised Floating Action Button (Light Mode)
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () => _onTabSelected(2),
              child: Container(
                width: 66.r,
                height: 66.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.borderUnselected,
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(7.r),
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primary, // Brand Deep Olive Green
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      _currentIndex == 2 ? Icons.search_rounded : Icons.add_rounded,
                      color: Colors.white,
                      size: 28.r,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final bool isSelected = _currentIndex == index;
    final Color activeColor = AppColors.primary;
    final Color inactiveColor = AppColors.textMuted;

    return GestureDetector(
      onTap: () => _onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24.r,
            color: isSelected ? activeColor : inactiveColor,
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5.sp,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LIGHT MODE CURVED NOTCHED NAVBAR PAINTER
// ---------------------------------------------------------------------------
class CurvatureNotchedNavBarPainterLight extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = AppColors.borderUnselected.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final Paint shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16);

    final double w = size.width;
    final double h = size.height;
    final double cornerRadius = 30.r;

    final double centerX = w / 2;
    final double notchWidth = 84.w;
    final double notchDepth = 28.h;

    final Path path = Path();

    // Start at top-left corner after radius
    path.moveTo(cornerRadius, 0);

    // Top horizontal line leading to the left edge of the notch
    path.lineTo(centerX - (notchWidth / 2) - 16.w, 0);

    // Smooth entry curve into the scoop (Notch)
    path.cubicTo(
      centerX - (notchWidth / 2) + 2.w, 0,
      centerX - (notchWidth / 2) + 6.w, notchDepth,
      centerX - (notchWidth / 4), notchDepth,
    );

    // Bottom arc of the scoop
    path.cubicTo(
      centerX - 10.w, notchDepth + 6.h,
      centerX + 10.w, notchDepth + 6.h,
      centerX + (notchWidth / 4), notchDepth,
    );

    // Smooth exit curve out of the scoop
    path.cubicTo(
      centerX + (notchWidth / 2) - 6.w, notchDepth,
      centerX + (notchWidth / 2) - 2.w, 0,
      centerX + (notchWidth / 2) + 16.w, 0,
    );

    // Top horizontal line to top-right corner
    path.lineTo(w - cornerRadius, 0);

    // Top-right rounded corner
    path.quadraticBezierTo(w, 0, w, cornerRadius);

    // Right vertical line down to bottom-right corner
    path.lineTo(w, h - cornerRadius);

    // Bottom-right rounded corner
    path.quadraticBezierTo(w, h, w - cornerRadius, h);

    // Bottom horizontal line to bottom-left corner
    path.lineTo(cornerRadius, h);

    // Bottom-left rounded corner
    path.quadraticBezierTo(0, h, 0, h - cornerRadius);

    // Left vertical line up to top-left corner
    path.lineTo(0, cornerRadius);

    // Top-left rounded corner
    path.quadraticBezierTo(0, 0, cornerRadius, 0);

    path.close();

    // Draw Drop Shadow
    canvas.drawPath(path.shift(Offset(0, 6.h)), shadowPaint);

    // Draw Main Nav Bar Path
    canvas.drawPath(path, paint);

    // Draw Outline Border
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
