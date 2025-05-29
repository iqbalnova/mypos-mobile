import 'package:flutter/material.dart';
import '../../../core/common/styles.dart';

class SearchBarWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;

  const SearchBarWidget({
    super.key,
    this.onTap,
    this.onChanged,
    this.readOnly = false,
    this.controller,
    this.focusNode,
    this.hintText = 'Cari nama produk...',
  });

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
              color: Colors.black.withAlpha(13),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            readOnly: readOnly,
            autofocus: false, // Fokus diatur dari parent via focusNode
            onTap: onTap,
            onChanged: onChanged,
            decoration: InputDecoration(
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.primaryLight,
              ),
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }
}
