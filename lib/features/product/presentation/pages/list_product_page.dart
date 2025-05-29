import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myposapp/features/product/presentation/widgets/category_selector.dart';

import '../../../core/common/data_constant.dart';
import '../../../core/common/styles.dart';
import '../../../core/router/app_routes.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar_widget.dart';

class ListProductPage extends StatefulWidget {
  const ListProductPage({super.key});

  @override
  State<ListProductPage> createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
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
            onPressed:
                () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.main,
                  (route) => false,
                  arguments: {'initialIndex': 1},
                ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            const SliverToBoxAdapter(child: SearchBarWidget()),
            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            const SliverToBoxAdapter(child: CategorySelector()),
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
