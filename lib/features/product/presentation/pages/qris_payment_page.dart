import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/router/app_routes.dart';
import '../widgets/detail_payment_widget.dart';

class QrisPaymentPage extends StatefulWidget {
  const QrisPaymentPage({super.key});

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
        Navigator.pushReplacementNamed(context, AppRoutes.paymentSuccess);
      }
    });
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
              date: '04 September 2024',
              transactionId: 'ID 0100jnaka9***',
              amount: 'Rp224.000',
              paymentMethod: PaymentMethodType.qris,
            ),
          ],
        ),
      ),
    );
  }
}
