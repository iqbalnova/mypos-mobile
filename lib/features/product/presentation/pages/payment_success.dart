import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:myposapp/features/product/presentation/bloc/product_bloc.dart';
import '../../../core/router/app_routes.dart';
import '../../domain/entities/cart_item.dart';
import '../widgets/detail_payment_widget.dart';

import '../../../core/common/data_constant.dart';
import '../../../core/common/styles.dart';

class PaymentSuccess extends StatefulWidget {
  final PaymentMethod selectedPaymentMethod;
  final double totalPrice;
  final List<CartItem> cartItems;

  const PaymentSuccess({
    super.key,
    required this.selectedPaymentMethod,
    required this.totalPrice,
    required this.cartItems,
  });

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  void initState() {
    super.initState();

    final productIds = widget.cartItems.map((e) => e.productId).toList();
    Future.microtask(() {
      // ignore: use_build_context_synchronously
      context.read<ProductBloc>().add(BulkRemoveCartItemEvent(productIds));
    });
  }

  PaymentMethodType _getPaymentMethodType(String title) {
    switch (title.toLowerCase()) {
      case 'qris':
        return PaymentMethodType.qris;
      case 'tunai':
        return PaymentMethodType.cash;
      default:
        throw Exception('Unknown payment method: $title');
    }
  }

  String _getFormattedDateNow() {
    final now = DateTime.now();
    final formatter = DateFormat('dd MMMM yyyy', 'id_ID');
    return formatter.format(now); // Contoh output: '30 Mei 2025'
  }

  // Format price helper method
  String _formatPrice(double price) {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: BoxDecoration(color: AppColors.primaryLight),
        child: Stack(
          children: [
            // Background vectors
            _buildBackgroundVectors(),

            // Safe area content
            SafeArea(
              child: Column(
                children: [
                  // Header with X and Share buttons
                  _buildHeader(context),

                  // Main content
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),

                          // Success titles
                          _buildSuccessTitles(),

                          SizedBox(height: 20.h),

                          // Success illustration
                          _buildSuccessIllustration(),

                          SizedBox(height: 20.h),

                          // Payment details card
                          _buildPaymentDetails(),

                          // Spacer to push content up
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundVectors() {
    return Stack(
      children: [
        // Left vector
        Positioned(
          left: 0,
          bottom: -10,
          child: Image.asset(
            'assets/images/vector_left.png',
            width: 200.w,
            height: 250.h,
            fit: BoxFit.contain,
          ),
        ),

        // Right vector
        Positioned(
          right: -40,
          top: 40,
          child: Image.asset(
            'assets/images/vector_right.png',
            width: 200.w,
            height: 250.h,
            fit: BoxFit.contain,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Close button
            IconButton(
              onPressed:
                  () => Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRoutes.main,
                    (route) => false,
                  ),
              icon: Icon(Icons.close, color: Colors.white, size: 24.sp),
              padding: EdgeInsets.all(12.w),
              constraints: BoxConstraints(minWidth: 44.w, minHeight: 44.h),
            ),

            // Share button
            IconButton(
              onPressed: () {
                // Handle share functionality
                _handleShare(context);
              },
              icon: Icon(Icons.share, color: Colors.white, size: 24.sp),
              padding: EdgeInsets.all(12.w),
              constraints: BoxConstraints(minWidth: 44.w, minHeight: 44.h),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessTitles() {
    return Column(
      children: [
        Text(
          "Pembayaran Berhasil",
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
          textAlign: TextAlign.center,
        ),

        SizedBox(height: 8.h),

        Text(
          "Yuk! Mulai Siapkan Pesanan",
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.9),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildSuccessIllustration() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Image.asset(
        'assets/images/payment_success.png',
        width: 200.w,
        height: 200.h,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildPaymentDetails() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      child: DetailPaymentWidget(
        date: _getFormattedDateNow(),
        transactionId: 'ID 0100jnaka9***',
        amount: _formatPrice(widget.totalPrice),
        paymentMethod: _getPaymentMethodType(
          widget.selectedPaymentMethod.title,
        ),
      ),
    );
  }

  void _handleShare(BuildContext context) {
    // Implement share functionality here
    // You can use packages like share_plus for sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitur berbagi akan segera hadir!'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
