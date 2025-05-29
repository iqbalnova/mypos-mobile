import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/data_constant.dart';
import '../../../core/common/styles.dart';
import '../../../core/router/app_routes.dart';
import '../../domain/entities/cart_item.dart';
import '../bloc/product_bloc.dart';
import '../widgets/cart_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  PaymentMethod? _selectedPaymentMethod;

  // Format price helper method
  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  void _submitPayment(
    List<CartItem> cartItems,
    PaymentMethod? selectedPaymentMethod,
    double totalPrice,
  ) {
    if (cartItems.isNotEmpty && selectedPaymentMethod != null) {
      if (selectedPaymentMethod.title.toLowerCase() == 'qris') {
        Navigator.pushNamed(
          context,
          AppRoutes.qrisPayment,
          arguments: {
            'cartItems': cartItems,
            'totalPrice': totalPrice,
            'paymentMethod': selectedPaymentMethod,
          },
        );
      } else if (selectedPaymentMethod.title.toLowerCase() == 'tunai') {
        Navigator.pushNamed(
          context,
          AppRoutes.paymentSuccess,
          arguments: {
            'cartItems': cartItems,
            'totalPrice': totalPrice,
            'paymentMethod': selectedPaymentMethod,
          },
        );
      } else {
        // Metode pembayaran tidak dikenali
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Metode pembayaran tidak dikenali.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Mohon pilih metode pembayaran dan pastikan keranjang tidak kosong.',
          ),
        ),
      );
    }
  }

  Future<void> showPaymentMethodSheet(BuildContext context) async {
    final result = await showModalBottomSheet<PaymentMethod>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        int? selectedId = _selectedPaymentMethod?.id;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ...paymentMethods.map(
                      (method) => ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(method.imageUrl),
                          radius: 24,
                        ),
                        title: Text(method.title),
                        trailing: Radio<int>(
                          value: method.id,
                          groupValue: selectedId,
                          onChanged: (value) {
                            setModalState(() {
                              selectedId = value;
                            });
                          },
                        ),
                        onTap: () {
                          setModalState(() {
                            selectedId = method.id;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        onPressed: () {
                          final selectedMethod = paymentMethods.firstWhere(
                            (method) => method.id == selectedId,
                          );
                          Navigator.pop(context, selectedMethod);
                        },
                        child: const Text('Pilih Metode'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() {
        _selectedPaymentMethod = result;
      });
      if (kDebugMode) {
        print('Metode dipilih: ${result.title}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Keranjang saya",
          style: AppTextStyle.headline3(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CartError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64.sp,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Error loading cart',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      context.read<ProductBloc>().add(LoadCartItems());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (state is CartLoaded) {
            final cartItems = state.cartItems;

            return Container(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Column(
                children: [
                  // Cart Items List
                  Expanded(
                    child:
                        cartItems.isEmpty
                            ? _buildEmptyCart()
                            : ListView.separated(
                              itemCount: cartItems.length,
                              separatorBuilder:
                                  (context, index) => SizedBox(height: 0.h),
                              itemBuilder: (context, index) {
                                final item = cartItems[index];
                                return CartWidget(item: item);
                              },
                            ),
                  ),
                ],
              ),
            );
          } else {
            // Initial state - load cart items
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.read<ProductBloc>().add(LoadCartItems());
            });
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      bottomNavigationBar: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is CartLoaded) {
            return _buildBottomPaymentWidget(state.cartItems, state.totalPrice);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80.sp,
            color: Theme.of(
              context,
            ).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            'Keranjang kosong',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Tambahkan produk ke keranjang untuk melanjutkan',
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPaymentWidget(
    List<CartItem> cartItems,
    double totalPrice,
  ) {
    return Container(
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
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Payment Method Section
              GestureDetector(
                onTap: () => showPaymentMethodSheet(context),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest
                        .withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Bayar menggunakan',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const Spacer(),
                      if (_selectedPaymentMethod != null) ...[
                        Row(
                          children: [
                            Image.asset(
                              _selectedPaymentMethod!.imageUrl,
                              width: 24.w,
                              height: 24.w,
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 8.w),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 100.w),
                              child: Text(
                                _selectedPaymentMethod!.title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                          ],
                        ),
                      ],
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16.sp,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Total and Pay Button
              Row(
                children: [
                  // Total Price Section
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.shopping_cart,
                            size: 18.sp,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Total Tagihan',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                _formatPrice(totalPrice),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryLight,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Pay Button
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed:
                          () => _submitPayment(
                            cartItems,
                            _selectedPaymentMethod,
                            totalPrice,
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Bayar',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
