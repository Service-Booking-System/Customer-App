import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:customer_app/core/constants/app_colors.dart';

class JobsTab extends StatefulWidget {
  const JobsTab({super.key});

  @override
  State<JobsTab> createState() => _JobsTabState();
}

class _JobsTabState extends State<JobsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _allJobs = [
    {
      'id': 'JOB-9842',
      'service': 'Deep Home Sanitization & Cleaning',
      'property': 'Sunset Luxury Villa, SF',
      'provider': 'David Miller',
      'rating': '4.9 ★',
      'price': '\$180.00',
      'date': 'Today, Aug 02 • 02:00 PM',
      'status': 'In Progress',
      'type': 'ongoing',
      'statusColor': AppColors.accentLime,
      'icon': Icons.cleaning_services_rounded,
    },
    {
      'id': 'JOB-9845',
      'service': 'HVAC Filter & Air Quality Service',
      'property': 'Downtown Studio Apt, SF',
      'provider': 'Marcus Vance',
      'rating': '4.8 ★',
      'price': '\$95.00',
      'date': 'Today, Aug 02 • 04:30 PM',
      'status': 'Pro En Route',
      'type': 'ongoing',
      'statusColor': const Color(0xFFE5A00D),
      'icon': Icons.hvac_rounded,
    },
    {
      'id': 'JOB-9830',
      'service': 'Lawn Mowing & Hedge Trimming',
      'property': 'Sunset Luxury Villa, SF',
      'provider': 'Green Thumb Services',
      'rating': '5.0 ★',
      'price': '\$120.00',
      'date': 'Tomorrow, Aug 03 • 10:00 AM',
      'status': 'Scheduled',
      'type': 'scheduled',
      'statusColor': AppColors.primaryLight,
      'icon': Icons.yard_rounded,
    },
    {
      'id': 'JOB-9811',
      'service': 'Kitchen Sink Pipe Replacement',
      'property': 'Sunset Luxury Villa, SF',
      'provider': 'QuickFix Plumbing Ltd',
      'rating': '4.9 ★',
      'price': '\$145.00',
      'date': 'Jul 28, 2026',
      'status': 'Completed',
      'type': 'completed',
      'statusColor': AppColors.primary,
      'icon': Icons.plumbing_rounded,
    },
    {
      'id': 'JOB-9788',
      'service': 'Electrical Panel Health Checkup',
      'property': 'Silicon Valley Office',
      'provider': 'Apex Electricians',
      'rating': '4.7 ★',
      'price': '\$220.00',
      'date': 'Jul 15, 2026',
      'status': 'Completed',
      'type': 'completed',
      'statusColor': AppColors.primary,
      'icon': Icons.electrical_services_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> _getFilteredJobs(int tabIndex) {
    if (tabIndex == 0) {
      return _allJobs.where((j) => j['type'] == 'ongoing').toList();
    } else if (tabIndex == 1) {
      return _allJobs.where((j) => j['type'] == 'scheduled').toList();
    } else {
      return _allJobs.where((j) => j['type'] == 'completed').toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.darkHeaderBg,
        elevation: 0,
        title: Text(
          'My Bookings & Jobs',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18.sp,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: AppColors.accentLime,
                borderRadius: BorderRadius.circular(12.r),
              ),
              labelColor: AppColors.textHeadline,
              unselectedLabelColor: Colors.white70,
              labelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
              unselectedLabelStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
              dividerColor: Colors.transparent,
              tabs: const [
                Tab(text: 'Ongoing (2)'),
                Tab(text: 'Scheduled (1)'),
                Tab(text: 'Past (2)'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJobsList(0),
          _buildJobsList(1),
          _buildJobsList(2),
        ],
      ),
    );
  }

  Widget _buildJobsList(int tabIndex) {
    final jobs = _getFilteredJobs(tabIndex);

    if (jobs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64.r, color: AppColors.borderUnselected),
            SizedBox(height: 12.h),
            Text(
              'No jobs in this category',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 110.h),
      itemCount: jobs.length,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        final job = jobs[index];
        return _buildJobItemCard(job);
      },
    );
  }

  Widget _buildJobItemCard(Map<String, dynamic> job) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: AppColors.cardSelectedBg,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.borderUnselected),
                ),
                child: Icon(
                  job['icon'] as IconData,
                  color: AppColors.primary,
                  size: 24.r,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['service'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textHeadline,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${job['id']} • ${job['property']}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: (job['statusColor'] as Color).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Text(
                  job['status'] as String,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: (job['statusColor'] as Color) == AppColors.accentLime
                        ? AppColors.primary
                        : job['statusColor'] as Color,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(height: 1, color: AppColors.borderUnselected.withValues(alpha: 0.6)),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 14.r, color: AppColors.textMuted),
                  SizedBox(width: 6.w),
                  Text(
                    job['date'] as String,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              Text(
                job['price'] as String,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
