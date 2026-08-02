import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer_app/core/constants/app_colors.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'All';

  final List<String> _filters = ['All', 'Cleaning', 'Plumbing', 'Electrical', 'Painting', 'Gardening', 'HVAC'];

  final List<Map<String, dynamic>> _categories = [
    {
      'title': 'Deep Cleaning',
      'priceFrom': 'from \$89',
      'rating': '4.9 (1.2k)',
      'badge': 'Popular',
      'icon': Icons.cleaning_services_rounded,
      'category': 'Cleaning',
    },
    {
      'title': 'Emergency Plumbing',
      'priceFrom': 'from \$75',
      'rating': '4.8 (850)',
      'badge': 'Fast 30m',
      'icon': Icons.plumbing_rounded,
      'category': 'Plumbing',
    },
    {
      'title': 'Electrical Fixtures & Repair',
      'priceFrom': 'from \$69',
      'rating': '4.9 (940)',
      'badge': 'Certified',
      'icon': Icons.electrical_services_rounded,
      'category': 'Electrical',
    },
    {
      'title': 'Lawn Mowing & Landscape',
      'priceFrom': 'from \$55',
      'rating': '4.7 (620)',
      'badge': 'Eco Friendly',
      'icon': Icons.yard_rounded,
      'category': 'Gardening',
    },
    {
      'title': 'Interior & Exterior Painting',
      'priceFrom': 'from \$199',
      'rating': '4.8 (430)',
      'badge': 'Top Rated',
      'icon': Icons.format_paint_rounded,
      'category': 'Painting',
    },
    {
      'title': 'AC & Heating Maintenance',
      'priceFrom': 'from \$85',
      'rating': '4.9 (1.1k)',
      'badge': 'Warranty',
      'icon': Icons.hvac_rounded,
      'category': 'HVAC',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCategories = _categories.where((c) {
      final matchesFilter = _selectedCategory == 'All' || c['category'] == _selectedCategory;
      final query = _searchController.text.toLowerCase().trim();
      final matchesQuery = query.isEmpty ||
          (c['title'] as String).toLowerCase().contains(query) ||
          (c['category'] as String).toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkHeaderBg,
        elevation: 0,
        title: Text(
          'Find Services & Pros',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search input banner
          Container(
            color: AppColors.darkHeaderBg,
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Row(
                children: [
                  Icon(Icons.search_rounded, color: AppColors.primary, size: 22.r),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Search any home service...',
                        hintStyle: GoogleFonts.plusJakartaSans(
                          color: AppColors.textMuted,
                          fontSize: 13.5.sp,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      child: Icon(Icons.close_rounded, size: 18.r, color: AppColors.textMuted),
                    ),
                ],
              ),
            ),
          ),

          // Filter tags
          Container(
            height: 52.h,
            color: Colors.white,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              scrollDirection: Axis.horizontal,
              itemCount: _filters.length,
              separatorBuilder: (context, index) => SizedBox(width: 8.w),
              itemBuilder: (context, index) {
                final filter = _filters[index];
                final isSelected = _selectedCategory == filter;
                return GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _selectedCategory = filter;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.cardSelectedBg,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.borderUnselected,
                      ),
                    ),
                    child: Text(
                      filter,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5.sp,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Service results list
          Expanded(
            child: filteredCategories.isEmpty
                ? Center(
                    child: Text(
                      'No services found matching "${_searchController.text}"',
                      style: GoogleFonts.plusJakartaSans(
                        color: AppColors.textMuted,
                        fontSize: 14.sp,
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 110.h),
                    itemCount: filteredCategories.length,
                    separatorBuilder: (context, index) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final item = filteredCategories[index];
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.r),
                          border: Border.all(color: AppColors.borderUnselected),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.all(16.r),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(12.r),
                              decoration: BoxDecoration(
                                color: AppColors.cardSelectedBg,
                                borderRadius: BorderRadius.circular(14.r),
                                border: Border.all(color: AppColors.borderUnselected),
                              ),
                              child: Icon(
                                item['icon'] as IconData,
                                color: AppColors.primary,
                                size: 26.r,
                              ),
                            ),
                            SizedBox(width: 14.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item['title'] as String,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textHeadline,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(6.r),
                                        ),
                                        child: Text(
                                          item['badge'] as String,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4.h),
                                  Row(
                                    children: [
                                      Text(
                                        item['priceFrom'] as String,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        '• ${item['rating']}',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w500,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
