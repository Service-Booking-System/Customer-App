import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
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
    CountryCode(flag: '🇦🇫', name: 'Afghanistan', code: '+93'),
    CountryCode(flag: '🇦🇱', name: 'Albania', code: '+355'),
    CountryCode(flag: '🇩🇿', name: 'Algeria', code: '+213'),
    CountryCode(flag: '🇦🇩', name: 'Andorra', code: '+376'),
    CountryCode(flag: '🇦🇴', name: 'Angola', code: '+244'),
    CountryCode(flag: '🇦🇬', name: 'Antigua & Barbuda', code: '+1'),
    CountryCode(flag: '🇦🇷', name: 'Argentina', code: '+54'),
    CountryCode(flag: '🇦🇲', name: 'Armenia', code: '+374'),
    CountryCode(flag: '🇦🇹', name: 'Austria', code: '+43'),
    CountryCode(flag: '🇦🇿', name: 'Azerbaijan', code: '+994'),
    CountryCode(flag: '🇧🇸', name: 'Bahamas', code: '+1'),
    CountryCode(flag: '🇧🇭', name: 'Bahrain', code: '+973'),
    CountryCode(flag: '🇧🇩', name: 'Bangladesh', code: '+880'),
    CountryCode(flag: '🇧🇧', name: 'Barbados', code: '+1'),
    CountryCode(flag: '🇧🇾', name: 'Belarus', code: '+375'),
    CountryCode(flag: '🇧🇪', name: 'Belgium', code: '+32'),
    CountryCode(flag: '🇧🇿', name: 'Belize', code: '+501'),
    CountryCode(flag: '🇧🇯', name: 'Benin', code: '+229'),
    CountryCode(flag: '🇧🇹', name: 'Bhutan', code: '+975'),
    CountryCode(flag: '🇧🇴', name: 'Bolivia', code: '+591'),
    CountryCode(flag: '🇧🇦', name: 'Bosnia & Herzegovina', code: '+387'),
    CountryCode(flag: '🇧🇼', name: 'Botswana', code: '+267'),
    CountryCode(flag: '🇧🇷', name: 'Brazil', code: '+55'),
    CountryCode(flag: '🇧🇳', name: 'Brunei', code: '+673'),
    CountryCode(flag: '🇧🇬', name: 'Bulgaria', code: '+359'),
    CountryCode(flag: '🇧🇫', name: 'Burkina Faso', code: '+226'),
    CountryCode(flag: '🇧🇮', name: 'Burundi', code: '+257'),
    CountryCode(flag: '🇰🇭', name: 'Cambodia', code: '+855'),
    CountryCode(flag: '🇨🇲', name: 'Cameroon', code: '+237'),
    CountryCode(flag: '🇨🇦', name: 'Canada', code: '+1'),
    CountryCode(flag: '🇨🇻', name: 'Cape Verde', code: '+238'),
    CountryCode(flag: '🇨🇫', name: 'Central African Republic', code: '+236'),
    CountryCode(flag: '🇹🇩', name: 'Chad', code: '+235'),
    CountryCode(flag: '🇨🇱', name: 'Chile', code: '+56'),
    CountryCode(flag: '🇨🇳', name: 'China', code: '+86'),
    CountryCode(flag: '🇨🇴', name: 'Colombia', code: '+57'),
    CountryCode(flag: '🇰🇲', name: 'Comoros', code: '+269'),
    CountryCode(flag: '🇨🇬', name: 'Congo', code: '+242'),
    CountryCode(flag: '🇨🇷', name: 'Costa Rica', code: '+506'),
    CountryCode(flag: '🇭🇷', name: 'Croatia', code: '+385'),
    CountryCode(flag: '🇨🇺', name: 'Cuba', code: '+53'),
    CountryCode(flag: '🇨🇾', name: 'Cyprus', code: '+357'),
    CountryCode(flag: '🇨🇿', name: 'Czech Republic', code: '+420'),
    CountryCode(flag: '🇩🇰', name: 'Denmark', code: '+45'),
    CountryCode(flag: '🇩🇯', name: 'Djibouti', code: '+253'),
    CountryCode(flag: '🇩🇲', name: 'Dominica', code: '+1'),
    CountryCode(flag: '🇩🇴', name: 'Dominican Republic', code: '+1'),
    CountryCode(flag: '🇪🇨', name: 'Ecuador', code: '+593'),
    CountryCode(flag: '🇪🇬', name: 'Egypt', code: '+20'),
    CountryCode(flag: '🇸🇻', name: 'El Salvador', code: '+503'),
    CountryCode(flag: '🇬🇶', name: 'Equatorial Guinea', code: '+240'),
    CountryCode(flag: '🇪🇷', name: 'Eritrea', code: '+291'),
    CountryCode(flag: '🇪🇪', name: 'Estonia', code: '+372'),
    CountryCode(flag: '🇸🇿', name: 'Eswatini', code: '+268'),
    CountryCode(flag: '🇪🇹', name: 'Ethiopia', code: '+251'),
    CountryCode(flag: '🇫🇯', name: 'Fiji', code: '+679'),
    CountryCode(flag: '🇫🇮', name: 'Finland', code: '+358'),
    CountryCode(flag: '🇫🇷', name: 'France', code: '+33'),
    CountryCode(flag: '🇬🇦', name: 'Gabon', code: '+241'),
    CountryCode(flag: '🇬🇲', name: 'Gambia', code: '+220'),
    CountryCode(flag: '🇬🇪', name: 'Georgia', code: '+995'),
    CountryCode(flag: '🇩🇪', name: 'Germany', code: '+49'),
    CountryCode(flag: '🇬🇭', name: 'Ghana', code: '+233'),
    CountryCode(flag: '🇬🇷', name: 'Greece', code: '+30'),
    CountryCode(flag: '🇬🇩', name: 'Grenada', code: '+1'),
    CountryCode(flag: '🇬🇹', name: 'Guatemala', code: '+502'),
    CountryCode(flag: '🇬🇳', name: 'Guinea', code: '+224'),
    CountryCode(flag: '🇬🇼', name: 'Guinea-Bissau', code: '+245'),
    CountryCode(flag: '🇬🇾', name: 'Guyana', code: '+592'),
    CountryCode(flag: '🇭🇹', name: 'Haiti', code: '+509'),
    CountryCode(flag: '🇭🇳', name: 'Honduras', code: '+504'),
    CountryCode(flag: '🇭🇰', name: 'Hong Kong', code: '+852'),
    CountryCode(flag: '🇭🇺', name: 'Hungary', code: '+36'),
    CountryCode(flag: '🇮🇸', name: 'Iceland', code: '+354'),
    CountryCode(flag: '🇮🇩', name: 'Indonesia', code: '+62'),
    CountryCode(flag: '🇮🇷', name: 'Iran', code: '+98'),
    CountryCode(flag: '🇮🇶', name: 'Iraq', code: '+964'),
    CountryCode(flag: '🇮🇪', name: 'Ireland', code: '+353'),
    CountryCode(flag: '🇮🇱', name: 'Israel', code: '+972'),
    CountryCode(flag: '🇮🇹', name: 'Italy', code: '+39'),
    CountryCode(flag: '🇨🇮', name: 'Ivory Coast', code: '+225'),
    CountryCode(flag: '🇯🇲', name: 'Jamaica', code: '+1'),
    CountryCode(flag: '🇯🇵', name: 'Japan', code: '+81'),
    CountryCode(flag: '🇯🇴', name: 'Jordan', code: '+962'),
    CountryCode(flag: '🇰🇿', name: 'Kazakhstan', code: '+7'),
    CountryCode(flag: '🇰🇪', name: 'Kenya', code: '+254'),
    CountryCode(flag: '🇰🇮', name: 'Kiribati', code: '+686'),
    CountryCode(flag: '🇰🇼', name: 'Kuwait', code: '+965'),
    CountryCode(flag: '🇰🇬', name: 'Kyrgyzstan', code: '+996'),
    CountryCode(flag: '🇱🇦', name: 'Laos', code: '+856'),
    CountryCode(flag: '🇱🇻', name: 'Latvia', code: '+371'),
    CountryCode(flag: '🇱🇧', name: 'Lebanon', code: '+961'),
    CountryCode(flag: '🇱🇸', name: 'Lesotho', code: '+266'),
    CountryCode(flag: '🇱🇷', name: 'Liberia', code: '+231'),
    CountryCode(flag: '🇱🇾', name: 'Libya', code: '+218'),
    CountryCode(flag: '🇱🇮', name: 'Liechtenstein', code: '+423'),
    CountryCode(flag: '🇱🇹', name: 'Lithuania', code: '+370'),
    CountryCode(flag: '🇱🇺', name: 'Luxembourg', code: '+352'),
    CountryCode(flag: '🇲🇴', name: 'Macao', code: '+853'),
    CountryCode(flag: '🇲🇬', name: 'Madagascar', code: '+261'),
    CountryCode(flag: '🇲🇼', name: 'Malawi', code: '+265'),
    CountryCode(flag: '🇲🇾', name: 'Malaysia', code: '+60'),
    CountryCode(flag: '🇲🇻', name: 'Maldives', code: '+960'),
    CountryCode(flag: '🇲🇱', name: 'Mali', code: '+223'),
    CountryCode(flag: '🇲🇹', name: 'Malta', code: '+356'),
    CountryCode(flag: '🇲🇭', name: 'Marshall Islands', code: '+692'),
    CountryCode(flag: '🇲🇷', name: 'Mauritania', code: '+222'),
    CountryCode(flag: '🇲🇺', name: 'Mauritius', code: '+230'),
    CountryCode(flag: '🇲🇽', name: 'Mexico', code: '+52'),
    CountryCode(flag: '🇫🇲', name: 'Micronesia', code: '+691'),
    CountryCode(flag: '🇲🇩', name: 'Moldova', code: '+373'),
    CountryCode(flag: '🇲🇨', name: 'Monaco', code: '+377'),
    CountryCode(flag: '🇲🇳', name: 'Mongolia', code: '+976'),
    CountryCode(flag: '🇲🇪', name: 'Montenegro', code: '+382'),
    CountryCode(flag: '🇲🇦', name: 'Morocco', code: '+212'),
    CountryCode(flag: '🇲🇿', name: 'Mozambique', code: '+258'),
    CountryCode(flag: '🇲🇲', name: 'Myanmar', code: '+95'),
    CountryCode(flag: '🇳🇦', name: 'Namibia', code: '+264'),
    CountryCode(flag: '🇳🇷', name: 'Nauru', code: '+674'),
    CountryCode(flag: '🇳🇵', name: 'Nepal', code: '+977'),
    CountryCode(flag: '🇳🇱', name: 'Netherlands', code: '+31'),
    CountryCode(flag: '🇳🇿', name: 'New Zealand', code: '+64'),
    CountryCode(flag: '🇳🇮', name: 'Nicaragua', code: '+505'),
    CountryCode(flag: '🇳🇪', name: 'Niger', code: '+227'),
    CountryCode(flag: '🇳🇬', name: 'Nigeria', code: '+234'),
    CountryCode(flag: '🇰🇵', name: 'North Korea', code: '+850'),
    CountryCode(flag: '🇲🇰', name: 'North Macedonia', code: '+389'),
    CountryCode(flag: '🇳🇴', name: 'Norway', code: '+47'),
    CountryCode(flag: '🇴🇲', name: 'Oman', code: '+968'),
    CountryCode(flag: '🇵🇰', name: 'Pakistan', code: '+92'),
    CountryCode(flag: '🇵🇼', name: 'Palau', code: '+680'),
    CountryCode(flag: '🇵🇸', name: 'Palestine', code: '+970'),
    CountryCode(flag: '🇵🇦', name: 'Panama', code: '+507'),
    CountryCode(flag: '🇵🇬', name: 'Papua New Guinea', code: '+675'),
    CountryCode(flag: '🇵🇾', name: 'Paraguay', code: '+595'),
    CountryCode(flag: '🇵🇪', name: 'Peru', code: '+51'),
    CountryCode(flag: '🇵🇭', name: 'Philippines', code: '+63'),
    CountryCode(flag: '🇵🇱', name: 'Poland', code: '+48'),
    CountryCode(flag: '🇵🇹', name: 'Portugal', code: '+351'),
    CountryCode(flag: '🇶🇦', name: 'Qatar', code: '+974'),
    CountryCode(flag: '🇷🇴', name: 'Romania', code: '+40'),
    CountryCode(flag: '🇷🇺', name: 'Russia', code: '+7'),
    CountryCode(flag: '🇷🇼', name: 'Rwanda', code: '+250'),
    CountryCode(flag: '🇰🇳', name: 'Saint Kitts & Nevis', code: '+1'),
    CountryCode(flag: '🇱🇨', name: 'Saint Lucia', code: '+1'),
    CountryCode(flag: '🇻🇨', name: 'Saint Vincent & Grenadines', code: '+1'),
    CountryCode(flag: '🇼🇸', name: 'Samoa', code: '+685'),
    CountryCode(flag: '🇸🇲', name: 'San Marino', code: '+378'),
    CountryCode(flag: '🇸🇹', name: 'Sao Tome & Principe', code: '+239'),
    CountryCode(flag: '🇸🇦', name: 'Saudi Arabia', code: '+966'),
    CountryCode(flag: '🇸🇳', name: 'Senegal', code: '+221'),
    CountryCode(flag: '🇷🇸', name: 'Serbia', code: '+381'),
    CountryCode(flag: '🇸🇨', name: 'Seychelles', code: '+248'),
    CountryCode(flag: '🇸🇱', name: 'Sierra Leone', code: '+232'),
    CountryCode(flag: '🇸🇰', name: 'Slovakia', code: '+421'),
    CountryCode(flag: '🇸🇮', name: 'Slovenia', code: '+386'),
    CountryCode(flag: '🇸🇧', name: 'Solomon Islands', code: '+677'),
    CountryCode(flag: '🇸🇴', name: 'Somalia', code: '+252'),
    CountryCode(flag: '🇿🇦', name: 'South Africa', code: '+27'),
    CountryCode(flag: '🇰🇷', name: 'South Korea', code: '+82'),
    CountryCode(flag: '🇸🇸', name: 'South Sudan', code: '+211'),
    CountryCode(flag: '🇪🇸', name: 'Spain', code: '+34'),
    CountryCode(flag: '🇸🇩', name: 'Sudan', code: '+249'),
    CountryCode(flag: '🇸🇷', name: 'Suriname', code: '+597'),
    CountryCode(flag: '🇸🇪', name: 'Sweden', code: '+46'),
    CountryCode(flag: '🇨🇭', name: 'Switzerland', code: '+41'),
    CountryCode(flag: '🇸🇾', name: 'Syria', code: '+963'),
    CountryCode(flag: '🇹🇼', name: 'Taiwan', code: '+886'),
    CountryCode(flag: '🇹🇯', name: 'Tajikistan', code: '+992'),
    CountryCode(flag: '🇹🇿', name: 'Tanzania', code: '+255'),
    CountryCode(flag: '🇹🇭', name: 'Thailand', code: '+66'),
    CountryCode(flag: '🇹🇱', name: 'Timor-Leste', code: '+670'),
    CountryCode(flag: '🇹🇬', name: 'Togo', code: '+228'),
    CountryCode(flag: '🇹🇴', name: 'Tonga', code: '+676'),
    CountryCode(flag: '🇹🇹', name: 'Trinidad & Tobago', code: '+1'),
    CountryCode(flag: '🇹🇳', name: 'Tunisia', code: '+216'),
    CountryCode(flag: '🇹🇷', name: 'Turkey', code: '+90'),
    CountryCode(flag: '🇹🇲', name: 'Turkmenistan', code: '+993'),
    CountryCode(flag: '🇹🇻', name: 'Tuvalu', code: '+688'),
    CountryCode(flag: '🇺🇬', name: 'Uganda', code: '+256'),
    CountryCode(flag: '🇺🇦', name: 'Ukraine', code: '+380'),
    CountryCode(flag: '🇺🇾', name: 'Uruguay', code: '+598'),
    CountryCode(flag: '🇺🇿', name: 'Uzbekistan', code: '+998'),
    CountryCode(flag: '🇻🇺', name: 'Vanuatu', code: '+678'),
    CountryCode(flag: '🇻🇦', name: 'Vatican City', code: '+379'),
    CountryCode(flag: '🇻🇪', name: 'Venezuela', code: '+58'),
    CountryCode(flag: '🇻🇳', name: 'Vietnam', code: '+84'),
    CountryCode(flag: '🇾🇪', name: 'Yemen', code: '+967'),
    CountryCode(flag: '🇿🇲', name: 'Zambia', code: '+260'),
    CountryCode(flag: '🇿🇼', name: 'Zimbabwe', code: '+263'),
  ];

  static Future<List<CountryCode>> fetchFromApi() async {
    try {
      final response = await Dio().get(
        'https://restcountries.com/v3.1/all?fields=name,idd,flag,cca2',
        options: Options(receiveTimeout: const Duration(seconds: 8)),
      );
      if (response.statusCode == 200 && response.data is List) {
        final List data = response.data;
        final countries = <CountryCode>[];
        for (final item in data) {
          final flag = item['flag']?.toString() ?? '';
          final name = item['name']?['common']?.toString() ?? '';
          final root = item['idd']?['root']?.toString() ?? '';
          final List suffixes = (item['idd']?['suffixes'] as List?) ?? [];

          if (root.isEmpty) continue;

          String dialCode = root;
          if (suffixes.length == 1) {
            dialCode = '$root${suffixes[0]}';
          }

          if (name.isNotEmpty && dialCode.isNotEmpty) {
            countries.add(CountryCode(flag: flag, name: name, code: dialCode));
          }
        }
        countries.sort((a, b) => a.name.compareTo(b.name));
        if (countries.isNotEmpty) return countries;
      }
    } catch (_) {
      // Return fallback offline supported list on failure or timeout
    }
    return supported;
  }
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
  List<CountryCode> _countryList = CountryCode.supported;
  bool _isLoadingCountries = false;
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

    _loadCountryCodes();
  }

  Future<void> _loadCountryCodes() async {
    setState(() {
      _isLoadingCountries = true;
    });
    final countries = await CountryCode.fetchFromApi();
    if (mounted) {
      setState(() {
        _countryList = countries;
        _isLoadingCountries = false;
      });
    }
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
    String searchQuery = '';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final filteredCountries = _countryList.where((c) {
              final query = searchQuery.toLowerCase();
              return c.name.toLowerCase().contains(query) ||
                  c.code.toLowerCase().contains(query);
            }).toList();

            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
              child: Column(
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
                  TextField(
                    onChanged: (val) {
                      setModalState(() {
                        searchQuery = val;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search country or dial code...',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 14.sp,
                        color: Colors.grey.shade400,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        size: 20.r,
                        color: Colors.grey.shade500,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 14.w,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: _isLoadingCountries
                        ? const Center(child: CircularProgressIndicator())
                        : filteredCountries.isEmpty
                            ? Center(
                                child: Text(
                                  'No country found',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              )
                            : ListView.separated(
                                itemCount: filteredCountries.length,
                                separatorBuilder: (_, index) => Divider(
                                  height: 1,
                                  color: Colors.grey.shade200,
                                ),
                                itemBuilder: (context, index) {
                                  final country = filteredCountries[index];
                                  final isSelected =
                                      country.code == _selectedCountry.code &&
                                          country.name == _selectedCountry.name;

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
            );
          },
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
