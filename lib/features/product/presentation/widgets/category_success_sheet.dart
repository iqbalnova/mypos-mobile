import 'package:flutter/material.dart';

import '../../../core/common/styles.dart';

class CategorySuccessSheet extends StatelessWidget {
  final void Function() addProductButton;
  const CategorySuccessSheet({super.key, required this.addProductButton});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 24),
          Image.asset('assets/icons/ilustration1.png', width: 120, height: 120),
          const SizedBox(height: 24),
          Text(
            'Yeay, Berhasil!',
            style: AppTextStyle.headline2(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Kategori baru sudah terbentuk. Yuk, mulai tambahkan produknya!',
            textAlign: TextAlign.center,
            style: AppTextStyle.regularText(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 24),
          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primaryLight,
                    side: const BorderSide(color: AppColors.primaryLight),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded button
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ), // tinggi tombol
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('Nanti aja'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: addProductButton,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryLight,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded button
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('Tambah produk'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
