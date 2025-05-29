import 'package:flutter/material.dart';

enum PaymentMethodType { qris, cash }

extension PaymentMethodTypeExtension on PaymentMethodType {
  String get label {
    switch (this) {
      case PaymentMethodType.qris:
        return 'QRIS';
      case PaymentMethodType.cash:
        return 'Tunai';
    }
  }

  String? get logoAsset {
    switch (this) {
      case PaymentMethodType.qris:
        return 'assets/icons/qris.png';
      case PaymentMethodType.cash:
        return null;
    }
  }
}

class DetailPaymentWidget extends StatelessWidget {
  final String date;
  final String transactionId;
  final String amount;
  final PaymentMethodType paymentMethod;
  final String? paymentLogo;

  const DetailPaymentWidget({
    super.key,
    required this.date,
    required this.transactionId,
    required this.amount,
    required this.paymentMethod,
    this.paymentLogo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Konten utama
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Tanggal & ID
                Container(
                  padding: const EdgeInsets.only(bottom: 12),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE5E5E5), width: 1),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        transactionId,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Total Bayar
                const Text(
                  'Total Bayar',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF999999),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  amount,
                  style: TextStyle(
                    fontSize: 32,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),

                // Metode Pembayaran
                Row(
                  children: [
                    const Text(
                      'Metode Pembayaran',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(width: 12),
                    if (paymentMethod.logoAsset != null)
                      Image.asset(
                        paymentMethod.logoAsset!,
                        height: 40,
                        width: 40,
                        fit: BoxFit.contain,
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF007BFF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          paymentMethod.label,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),

          // Watermark vertikal
          ClipRect(
            child: SizedBox(
              width: 24,
              child: Align(
                alignment: Alignment.center,
                child: RotatedBox(
                  quarterTurns: 3,
                  child: SizedBox(
                    width: 180,
                    child: Text(
                      'MASPOS MASPOS MASPOS MASPOS',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.withValues(alpha: 0.2),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                      overflow: TextOverflow.clip,
                      softWrap: false,
                      textAlign: TextAlign.left,
                      textDirection: TextDirection.rtl,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
