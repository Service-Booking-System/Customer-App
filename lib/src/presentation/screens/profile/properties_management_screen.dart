import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer_app/core/constants/app_colors.dart';
import 'package:customer_app/src/data/repositories/profile_repository_impl.dart';
import 'package:customer_app/src/domain/entities/property.dart';
import 'package:customer_app/src/presentation/screens/auth/add_properties_screen.dart';

class PropertiesManagementScreen extends StatelessWidget {
  const PropertiesManagementScreen({super.key});

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
          'Properties Management',
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<Property>>(
        stream: repository.watchProperties(),
        builder: (context, snapshot) {
          final properties = snapshot.data ?? [];

          return SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Registered Properties (${properties.length})',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textHeadline,
                  ),
                ),
                SizedBox(height: 14.h),
                if (properties.isEmpty)
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
                        Icon(Icons.location_city_rounded,
                            size: 48.r, color: AppColors.textMuted),
                        SizedBox(height: 12.h),
                        Text(
                          'No Properties Added Yet',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textHeadline,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  ...properties.map((prop) => _buildPropertyTile(context, prop, repository)),

                SizedBox(height: 24.h),

                // Add Property Button
                SizedBox(
                  width: double.infinity,
                  height: 54.h,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddPropertiesScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add_home_rounded, color: Colors.white),
                    label: Text(
                      'Add New Property',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonBackground,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(27.r),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPropertyTile(
    BuildContext context,
    Property property,
    ProfileRepositoryImpl repository,
  ) {
    IconData typeIcon = Icons.home_rounded;
    if (property.type == PropertyType.apartment) typeIcon = Icons.apartment_rounded;
    if (property.type == PropertyType.villa) typeIcon = Icons.villa_rounded;
    if (property.type == PropertyType.office) typeIcon = Icons.domain_rounded;

    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: property.isPrimary ? AppColors.primary : AppColors.borderUnselected,
          width: property.isPrimary ? 2.0 : 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.cardSelectedBg,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(typeIcon, color: AppColors.primary, size: 24.r),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      property.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHeadline,
                      ),
                    ),
                    if (property.isPrimary) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                        decoration: BoxDecoration(
                          color: AppColors.accentLime,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          'PRIMARY',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9.sp,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  property.address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5.sp,
                    color: AppColors.textMuted,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  '${property.bedrooms} Beds • ${property.areaSqft} sqft',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.red),
            onPressed: () async {
              HapticFeedback.lightImpact();
              await repository.deleteProperty(property.id);
            },
          ),
        ],
      ),
    );
  }
}
