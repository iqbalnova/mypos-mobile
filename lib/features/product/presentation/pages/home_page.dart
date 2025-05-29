import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/styles.dart';
import '../../../core/common/utils.dart';
import '../../../core/injection.dart' as di;
import '../../../core/router/app_routes.dart';
import '../../domain/entities/cart_item.dart';
import '../bloc/product_bloc.dart';
import '../widgets/add_edit_product_sheet.dart';
import '../widgets/banner_widget.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onProfileTabSelected;
  const HomePage({super.key, required this.onProfileTabSelected});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  void _fetchProducts() {
    context.read<ProductBloc>().add(FetchProductsEvent());
  }

  void _loadCartItems() {
    context.read<ProductBloc>().add(LoadCartItems());
  }

  @override
  void initState() {
    _loadCartItems(); // Load cart items when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCartItems();
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    _loadCartItems();
    _fetchProducts();
  }

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
            onPressed:
                () => Navigator.pushNamed(
                  context,
                  AppRoutes.listProduct,
                  arguments: {'autofocusSearch': true},
                ),
          ),
          _buildCartIconWithBadge(),
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
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            const SliverToBoxAdapter(child: BannerWidget()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildSaleProducts()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildCartIconWithBadge() {
    return BlocBuilder<ProductBloc, ProductState>(
      buildWhen: (previous, current) {
        // Only rebuild when cart-related states change
        return current is CartLoaded ||
            current is CartItemAdded ||
            current is CartItemUpdated ||
            current is CartItemRemoved ||
            current is CartCleared;
      },
      builder: (context, state) {
        int productCount = 0;

        if (state is CartLoaded) {
          // Count unique products instead of total quantity
          productCount = state.cartItems.length;
        }

        return Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.shopping_cart_outlined),
              color: Theme.of(context).colorScheme.onSurface,
              onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
            ),
            if (productCount > 0)
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                      width: 1,
                    ),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 14,
                    minHeight: 14,
                  ),
                  child: Text(
                    productCount > 9 ? '9+' : productCount.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
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
            child: BlocListener<ProductBloc, ProductState>(
              listener: (context, state) {
                print('===========');
                print(state);
                print('===========');
                if (state is DeleteProductSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Produk berhasil dihapus')),
                  );
                  context.read<ProductBloc>().add(FetchProductsEvent());
                } else if (state is DeleteProductFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Gagal menghapus produk')),
                  );
                } else if (state is CartItemAdded) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Berhasil menambahkan produk ke keranjang'),
                    ),
                  );
                  context.read<ProductBloc>().add(FetchProductsEvent());
                  _loadCartItems(); // Refresh cart count after adding item
                } else if (state is CartError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                  context.read<ProductBloc>().add(FetchProductsEvent());
                } else if (state is CartLoaded) {
                  context.read<ProductBloc>().add(FetchProductsEvent());
                }
              },
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductLoaded) {
                    final products = state.products;
                    return GridView.builder(
                      itemCount: products.length > 5 ? 5 : products.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.w,
                        mainAxisSpacing: 16.h,
                        crossAxisSpacing: 16.w,
                        childAspectRatio: 0.56,
                      ),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        return ProductCard(
                          imageUrl: product.pictureUrl,
                          title: product.name,
                          price: product.price,
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder:
                                  (_) => BlocProvider(
                                    create:
                                        (context) => di.locator<ProductBloc>(),
                                    child: AddEditProductSheet(
                                      product: product,
                                    ),
                                  ),
                            ).then((result) {
                              if (result == true) {
                                // ignore: use_build_context_synchronously
                                context.read<ProductBloc>().add(
                                  FetchProductsEvent(),
                                );
                              }
                            });
                          },
                          onAddToCart: () {
                            context.read<ProductBloc>().add(
                              AddCartItemEvent(
                                CartItem(
                                  productId: product.id,
                                  productName: product.name,
                                  price: product.price.toDouble(),
                                  quantity: 1,
                                  imageUrl: product.pictureUrl,
                                ),
                              ),
                            );
                          },
                          onDelete: () {
                            context.read<ProductBloc>().add(
                              DeleteProductEvent(product.id),
                            );
                          },
                        );
                      },
                    );
                  } else if (state is ProductError) {
                    return Center(child: Text(state.message));
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
