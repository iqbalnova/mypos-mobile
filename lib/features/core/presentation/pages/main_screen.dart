import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../product/presentation/bloc/product_bloc.dart';
import '../../../product/presentation/pages/home_page.dart';
import '../../../product/presentation/widgets/add_category_sheet.dart';
import '../../../product/presentation/widgets/add_edit_product_sheet.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../common/styles.dart';
import '../../injection.dart' as di;

class MainScreen extends StatefulWidget {
  final int initialIndex;

  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _setIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return BlocProvider(
          create: (context) => di.locator<ProductBloc>(),
          child: HomePage(
            onProfileTabSelected: () {
              setState(() {
                _currentIndex = 1;
              });
            },
          ),
        );
      case 1:
        return const ProfilePage();
      default:
        return const OnDevScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            height: 70.h,
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Home button
                _buildNavItem(
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  index: 0,
                ),

                // Center floating action button
                Container(
                  width: 120.w,
                  height: 46.h,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          builder:
                              (context) => Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  16,
                                  16,
                                  32,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        _featureCard(
                                          title: 'Kategori',
                                          subtitle:
                                              'Buat menu produk\nlebih rapi',
                                          onTap: () {
                                            Navigator.pop(context);
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder:
                                                  (context) => BlocProvider(
                                                    create:
                                                        (context) =>
                                                            di
                                                                .locator<
                                                                  ProductBloc
                                                                >(),
                                                    child:
                                                        const AddCategorySheet(),
                                                  ),
                                            );
                                          },
                                        ),
                                        _featureCard(
                                          title: 'Produk',
                                          subtitle:
                                              'Tambahin makanan\natau minuman',
                                          onTap: () {
                                            Navigator.pop(context);
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              builder:
                                                  (context) => BlocProvider(
                                                    create:
                                                        (context) =>
                                                            di
                                                                .locator<
                                                                  ProductBloc
                                                                >(),
                                                    child:
                                                        const AddEditProductSheet(),
                                                  ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                        );
                      },
                      borderRadius: BorderRadius.circular(23.r),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.onPrimary,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  ),
                ),

                // Profile button
                _buildNavItem(
                  icon: Icons.person_outline,
                  selectedIcon: Icons.person,
                  index: 1,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData selectedIcon,
    required int index,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _setIndex(index),
      child: Container(
        width: 50.w,
        height: 50.h,
        decoration: BoxDecoration(
          color:
              isSelected
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(25.r),
        ),
        child: Center(
          child: Icon(
            isSelected ? selectedIcon : icon,
            color:
                isSelected
                    ? AppColors.primaryLight
                    : Theme.of(context).colorScheme.onSurface,
            size: 24.sp,
          ),
        ),
      ),
    );
  }

  Widget _featureCard({
    required String title,
    required String subtitle,
    void Function()? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.blueAccent.withValues(alpha: 0.5),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 18, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnDevScreen extends StatelessWidget {
  const OnDevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("ON DEV", style: AppTextStyle.subtitle1()));
  }
}
