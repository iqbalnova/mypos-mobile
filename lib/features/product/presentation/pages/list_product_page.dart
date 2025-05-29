import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../bloc/product_bloc.dart';
import '../widgets/add_edit_product_sheet.dart';
import '../widgets/category_selector.dart';

import '../../../core/common/styles.dart';
import '../../../core/router/app_routes.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_card.dart';
import '../widgets/search_bar_widget.dart';

class ListProductPage extends StatefulWidget {
  final bool autofocusSearch;
  final GetIt locator;

  const ListProductPage({
    super.key,
    required this.locator,
    this.autofocusSearch = false,
  });

  @override
  State<ListProductPage> createState() => _ListProductPageState();
}

class _ListProductPageState extends State<ListProductPage> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  Category? _selectedCategory;
  String _searchQuery = '';

  final FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    if (widget.autofocusSearch) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _searchFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _filterProducts() {
    setState(() {
      _filteredProducts =
          _allProducts.where((product) {
            final matchesCategory =
                _selectedCategory == null ||
                product.categoryId == _selectedCategory!.id;
            final matchesSearch =
                _searchQuery.isEmpty ||
                product.name.toLowerCase().contains(_searchQuery.toLowerCase());
            return matchesCategory && matchesSearch;
          }).toList();
    });
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
                () => WidgetsBinding.instance.addPostFrameCallback((_) {
                  _searchFocusNode.requestFocus();
                }),
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
            SliverToBoxAdapter(
              child: SearchBarWidget(
                focusNode: _searchFocusNode,
                onChanged: (query) {
                  _searchQuery = query;
                  _filterProducts();
                },
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: BlocProvider(
                create:
                    (context) =>
                        widget.locator<ProductBloc>()
                          ..add(FetchCategoriesEvent()),
                child: CategorySelector(
                  onCategorySelected: (Category category) {
                    setState(() {
                      // Jika kategori id atau index 0 (semua kategori), set _selectedCategory = null
                      _selectedCategory = category.id == '0' ? null : category;
                    });
                    _filterProducts();
                  },
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverToBoxAdapter(child: _buildSaleProducts()),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildSaleProducts() {
    return BlocProvider(
      create:
          (context) => widget.locator<ProductBloc>()..add(FetchProductsEvent()),
      child: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is DeleteProductSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Produk berhasil dihapus')));
            setState(() {
              _allProducts = [];
            });
            context.read<ProductBloc>().add(FetchProductsEvent());
          } else if (state is DeleteProductFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Gagal menghapus produk')));
          }
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          buildWhen:
              (prev, curr) =>
                  curr is ProductLoaded ||
                  curr is ProductLoading ||
                  curr is ProductError,
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              // Simpan hasil awal hanya sekali
              if (_allProducts.isEmpty) {
                _allProducts = state.products;
                _filteredProducts = _allProducts;
              }

              return _buildProductGrid(_filteredProducts);
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(List<Product> products) {
    if (products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: Text("Tidak ada produk yang ditemukan.")),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        itemCount: products.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.w,
          mainAxisSpacing: 16.h,
          crossAxisSpacing: 16.w,
          childAspectRatio: 0.6,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            imageUrl: product.pictureUrl,
            title: product.name,
            price: product.price,
            onTap: () async {
              // handle edit product
              await showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder:
                    (_) => BlocProvider(
                      create: (context) => widget.locator<ProductBloc>(),
                      child: AddEditProductSheet(product: product),
                    ),
              ).then((result) {
                if (result == true) {
                  setState(() {
                    _allProducts = [];
                  });
                  // ignore: use_build_context_synchronously
                  context.read<ProductBloc>().add(FetchProductsEvent());
                }
              });
            },
            onAddToCart: () {
              // handle add to cart
            },
            onDelete: () {
              context.read<ProductBloc>().add(DeleteProductEvent(product.id));
            },
          );
        },
      ),
    );
  }
}
