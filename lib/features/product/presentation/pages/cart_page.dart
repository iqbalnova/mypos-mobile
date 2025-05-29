import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/common/data_constant.dart';
import '../../../core/common/styles.dart';
import '../../../core/common/utils.dart';
import '../../../core/router/app_routes.dart';
import '../widgets/cart_widget.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  PaymentMethod? _selectedPaymentMethod;

  void _updateQuantity(String itemId, bool isIncrement) {
    setState(() {
      final index = cartItems.indexWhere((item) => item.id == itemId);
      if (index != -1) {
        if (isIncrement) {
          cartItems[index].quantity++;
        } else {
          if (cartItems[index].quantity > 1) {
            cartItems[index].quantity--;
          }
        }
      }
    });
  }

  void _removeItem(String itemId) {
    setState(() {
      cartItems.removeWhere((item) => item.id == itemId);
    });
  }

  double get _totalPrice {
    return cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  Future<void> showPaymentMethodSheet(BuildContext context) async {
    final result = await showModalBottomSheet<PaymentMethod>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        int? selectedId = _selectedPaymentMethod?.id;

        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
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
                        backgroundColor: Theme.of(context).colorScheme.primary,
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
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          children: [
            // Cart Items List
            Expanded(
              child: ListView.separated(
                itemCount: cartItems.length,
                separatorBuilder: (context, index) => SizedBox(height: 0.h),
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return CartWidget(
                    item: item,
                    updateQuantity: _updateQuantity,
                    removeItem: _removeItem,
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomPaymentWidget(),
    );
  }

  Widget _buildBottomPaymentWidget() {
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
                                formatPrice(_totalPrice),
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
                          cartItems.isNotEmpty
                              ? () {
                                // Handle payment
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.qrisPayment,
                                );
                              }
                              : null,
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
