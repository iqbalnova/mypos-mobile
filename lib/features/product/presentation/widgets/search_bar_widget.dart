import 'package:flutter/material.dart';

import '../../../core/common/styles.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: TextField(
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.primaryLight,
              ),
              hintText: 'Cari nama produk...',
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }
}
