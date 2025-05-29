import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myposapp/features/product/presentation/bloc/product_bloc.dart';

import '../../../core/common/styles.dart';
import '../../../core/injection.dart' as di;
import 'add_edit_product_sheet.dart';
import 'category_success_sheet.dart';

class AddCategorySheet extends StatefulWidget {
  const AddCategorySheet({super.key});

  @override
  State<AddCategorySheet> createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  final _formKey = GlobalKey<FormState>();

  final _categoryController = TextEditingController();

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      context.read<ProductBloc>().add(
        AddCategoryEvent(_categoryController.text),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is AddCategorySuccess) {
          Navigator.pop(context);
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder:
                (context) => CategorySuccessSheet(
                  addProductButton: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder:
                          (context) => BlocProvider(
                            create: (context) => di.locator<ProductBloc>(),
                            child: const AddEditProductSheet(),
                          ),
                    );
                  },
                ),
          );
        } else if (state is AddCategoryFailure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Gagal menambahkan kategori')));
        }
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.4,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Tambah Category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Nama Produk
                  TextFormField(
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      labelText: 'Kategori',
                      hintText: 'Cth: Makanan manis',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Kategori tidak boleh kosong';
                      }
                      if (value.trim().toLowerCase() == 'gacoan') {
                        return 'Kategori Ini Sudah Tersedia.';
                      }
                      return null;
                    },
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
                            side: const BorderSide(
                              color: AppColors.primaryLight,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // Rounded button
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ), // tinggi tombol
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: const Text('Batal'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                12,
                              ), // Rounded button
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            textStyle: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          child: const Text('Tambah'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ), // Tambahan agar ada ruang di bawah
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
