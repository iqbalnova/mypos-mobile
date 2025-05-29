import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/common/data_constant.dart';
import '../../../core/router/app_routes.dart';
import '../../domain/entities/cart_item.dart';
import '../widgets/detail_payment_widget.dart';

class QrisPaymentPage extends StatefulWidget {
  final List<CartItem> cartItems;
  final PaymentMethod selectedPaymentMethod;
  final double totalPrice;

  const QrisPaymentPage({
    super.key,
    required this.selectedPaymentMethod,
    required this.totalPrice,
    required this.cartItems,
  });

  @override
  State<QrisPaymentPage> createState() => _QrisPaymentPageState();
}

class _QrisPaymentPageState extends State<QrisPaymentPage> {
  @override
  void initState() {
    super.initState();

    // Navigasi otomatis setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          AppRoutes.paymentSuccess,
          arguments: {
            'cartItems': widget.cartItems,
            'totalPrice': widget.totalPrice,
            'paymentMethod': widget.selectedPaymentMethod,
          },
        );
      }
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Scan kode berikut",
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16.r),
              ),
              padding: EdgeInsets.all(12.w),
              child: Image.asset(
                'assets/images/qr.png',
                width: 300.w,
                height: 300.h,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 32.h),
            DetailPaymentWidget(
              date: _getFormattedDateNow(),
              transactionId: 'ID 0100jnaka9***',
              amount: _formatPrice(widget.totalPrice),
              paymentMethod: _getPaymentMethodType(
                widget.selectedPaymentMethod.title,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
