import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer_app/core/constants/app_colors.dart';

class LatLng {
  final double latitude;
  final double longitude;

  const LatLng(this.latitude, this.longitude);
}

class MapSelectorScreen extends StatefulWidget {
  const MapSelectorScreen({super.key});

  @override
  State<MapSelectorScreen> createState() => _MapSelectorScreenState();
}

class _MapSelectorScreenState extends State<MapSelectorScreen> {
  LatLng _selectedLatLng = const LatLng(37.7749, -122.4194); // Default to SF
  String _selectedAddress = "Market Street, San Francisco, CA";
  bool _isLoadingAddress = false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _reverseGeocode(LatLng position) async {
    setState(() {
      _isLoadingAddress = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    String address = "Coordinates: ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
    if ((position.latitude - 37.7749).abs() < 0.05 && (position.longitude - (-122.4194)).abs() < 0.05) {
      address = "Market Street, San Francisco, CA";
    } else {
      address = "Custom Location, City District, Area Code";
    }

    setState(() {
      _selectedAddress = address;
      _isLoadingAddress = false;
    });
  }

  void _handleConfirm() {
    HapticFeedback.mediumImpact();
    Navigator.of(context).pop({
      'address': _selectedAddress,
      'latitude': _selectedLatLng.latitude,
      'longitude': _selectedLatLng.longitude,
    });
  }

  // Handle mock map drag gesture
  void _handleMockPan(DragUpdateDetails details) {
    setState(() {
      // Convert translation delta to approximate coordinates change
      final double latDelta = -details.delta.dy * 0.0001;
      final double lngDelta = details.delta.dx * 0.00015;
      _selectedLatLng = LatLng(
        (_selectedLatLng.latitude + latDelta).clamp(-85.0, 85.0),
        (_selectedLatLng.longitude + lngDelta).clamp(-180.0, 180.0),
      );
    });
  }

  void _handleMockPanEnd(DragEndDetails details) {
    _reverseGeocode(_selectedLatLng);
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // 1. Fallback Mock Vector Map
            GestureDetector(
              onPanUpdate: _handleMockPan,
              onPanEnd: _handleMockPanEnd,
              child: Container(
                color: const Color(0xFFE8ECE5),
                child: CustomPaint(
                  painter: MockMapGridPainter(center: _selectedLatLng),
                  child: Container(),
                ),
              ),
            ),

            // 2. Centered Pin Indicator
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 28.h),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.white,
                        size: 32.r,
                      ),
                    ),
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.35),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 3. Search Bar Overlay (Top)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  child: Row(
                    children: [
                      // Back Button
                      Container(
                        width: 44.r,
                        height: 44.r,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
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
                            onTap: () {
                              HapticFeedback.lightImpact();
                              Navigator.of(context).pop();
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
                      SizedBox(width: 10.w),

                      // Search Input field
                      Expanded(
                        child: Container(
                          height: 48.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Row(
                            children: [
                              Icon(
                                Icons.search_rounded,
                                color: AppColors.textSecondary,
                                size: 20.r,
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: TextField(
                                  controller: _searchController,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textHeadline,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Search location...',
                                    hintStyle: GoogleFonts.plusJakartaSans(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary.withValues(alpha: 0.5),
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 4. Bottom Location Card
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.r),
                    topRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 20,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Confirm Location',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textHeadline,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.primary,
                            size: 20.r,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: _isLoadingAddress
                                ? Container(
                                    height: 16.h,
                                    alignment: Alignment.centerLeft,
                                    child: SizedBox(
                                      width: 14.r,
                                      height: 14.r,
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation(AppColors.primary),
                                      ),
                                    ),
                                  )
                                : Text(
                                    _selectedAddress,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Coordinates: ${_selectedLatLng.latitude.toStringAsFixed(6)}, ${_selectedLatLng.longitude.toStringAsFixed(6)}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textMuted,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        height: 52.h,
                        child: ElevatedButton(
                          onPressed: _isLoadingAddress ? null : _handleConfirm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonBackground,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26.r),
                            ),
                          ),
                          child: Text(
                            'Confirm Location',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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
}

// Custom Painter to draw a gorgeous, high-fidelity mock vector map grid
class MockMapGridPainter extends CustomPainter {
  final LatLng center;

  MockMapGridPainter({required this.center});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2.0;

    final Paint mainRoadPaint = Paint()
      ..color = const Color(0xFFF9E7C9)
      ..strokeWidth = 14.0
      ..strokeCap = StrokeCap.round;

    final Paint waterPaint = Paint()
      ..color = const Color(0xFFC5E0E5)
      ..style = PaintingStyle.fill;

    // 1. Draw a mock river
    final Path waterPath = Path();
    waterPath.moveTo(0, size.height * 0.2);
    waterPath.quadraticBezierTo(
      size.width * 0.4,
      size.height * 0.15,
      size.width,
      size.height * 0.4,
    );
    waterPath.lineTo(size.width, 0);
    waterPath.lineTo(0, 0);
    waterPath.close();
    canvas.drawPath(waterPath, waterPaint);

    // Grid coordinates offset simulation (moves grid as user pans)
    final double offsetX = (center.longitude + 122.4194) * 120000 % 80;
    final double offsetY = (center.latitude - 37.7749) * 120000 % 80;

    // 2. Draw road grid lines
    for (double x = offsetX; x < size.width; x += 60) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = offsetY; y < size.height; y += 60) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // 3. Draw main highways
    canvas.drawLine(
      Offset(0, size.height * 0.5 + offsetY * 0.5),
      Offset(size.width, size.height * 0.65 + offsetY * 0.5),
      mainRoadPaint,
    );
    canvas.drawLine(
      Offset(size.width * 0.3 + offsetX * 0.5, 0),
      Offset(size.width * 0.4 + offsetX * 0.5, size.height),
      mainRoadPaint,
    );

    // 4. Draw mock park area
    final Paint parkPaint = Paint()
      ..color = const Color(0xFFD2E2D4)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.6 + offsetX,
          size.height * 0.6 + offsetY,
          100.w,
          100.h,
        ),
        Radius.circular(12.r),
      ),
      parkPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MockMapGridPainter oldDelegate) {
    return oldDelegate.center != center;
  }
}
