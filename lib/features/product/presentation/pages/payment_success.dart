import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myposapp/features/product/presentation/widgets/detail_payment_widget.dart';

import '../../../core/common/styles.dart';

class PaymentSuccess extends StatelessWidget {
  final bool? isQrisPay;
  const PaymentSuccess({super.key, this.isQrisPay = false});

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
              onPressed: () => Navigator.of(context).pop(),
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
        date: '04 September 2024',
        transactionId: 'ID 0100jnaka9***',
        amount: 'Rp224.000',
        paymentMethod: PaymentMethodType.qris,
      ),
    );
  }

  void _handleShare(BuildContext context) {
    // Implement share functionality here
    // You can use packages like share_plus for sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality will be implemented here'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
