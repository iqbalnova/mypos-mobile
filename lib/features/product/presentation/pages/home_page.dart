import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/data_constant.dart';
import '../../../core/common/styles.dart';
import '../../../core/router/app_routes.dart';
import '../widgets/banner_widget.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar_widget.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onProfileTabSelected;
  const HomePage({super.key, required this.onProfileTabSelected});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        title: Text(
          'MASPOS',
          style: AppTextStyle.headline2(color: AppColors.primaryLight),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_outlined),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.comingSoon),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
          ),
          IconButton(
            icon: const Icon(Icons.person_2_outlined),
            color: Theme.of(context).colorScheme.onSurface,
            onPressed: widget.onProfileTabSelected,
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: SearchBarWidget(
                readOnly: true,
                onTap:
                    () => Navigator.pushNamed(context, AppRoutes.listProduct),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            const SliverToBoxAdapter(child: BannerWidget()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildSaleProducts()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildSaleProducts() {
    return Container(
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Produk yang dijual',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.listProduct);
                  },
                  child: Text(
                    'Lihat semua',
                    style: TextStyle(color: AppColors.primaryLight),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GridView.builder(
              itemCount: dummyProducts.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200.w,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 16.w,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (context, index) {
                final product = dummyProducts[index];
                return ProductCard(
                  imageUrl: product.pictureUrl,
                  title: product.name,
                  price: product.price,
                  onAddToCart: () {
                    // handle add to cart
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
