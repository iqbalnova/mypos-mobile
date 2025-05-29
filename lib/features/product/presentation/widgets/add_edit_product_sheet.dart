import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/common/styles.dart';
import '../../../core/injection.dart' as di;
import '../../../core/presentation/widgets/dashed_border.dart';
import '../../../core/router/app_routes.dart';
import '../../data/models/product_form_model.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';

class AddEditProductSheet extends StatefulWidget {
  final Product? product;
  const AddEditProductSheet({super.key, this.product});

  @override
  State<AddEditProductSheet> createState() => _AddEditProductSheetState();
}

class _AddEditProductSheetState extends State<AddEditProductSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  Category? _selectedCategory;
  File? _selectedImage;
  String? _imageError;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();

    if (widget.product != null) {
      // Edit mode: isi controller dan state dari product entity
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();

      // Simpan URL gambar dari product
      _imageUrl = widget.product!.pictureUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final file = File(picked.path);
      final sizeInBytes = await file.length();
      if (sizeInBytes > 5 * 1024 * 1024) {
        setState(() {
          _imageError = 'Filemu Terlalu Besar, Melebihi 5 MB';
          _selectedImage = null;
        });
      } else {
        setState(() {
          _selectedImage = file;
          _imageError = null;
          _imageUrl = null;
        });
      }
    }
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();

    // Kalau belum ada gambar baru (file) dan gambar URL juga null = error
    if (_selectedImage == null && _imageUrl == null) {
      setState(() {
        _imageError = 'Gambar wajib diunggah';
      });
    }

    if (isValid && _imageError == null) {
      final isEditing = widget.product != null;
      final formModel = ProductFormModel(
        categoryId: _selectedCategory!.id,
        name: _nameController.text,
        price: int.tryParse(_priceController.text) ?? 0,
      );

      if (isEditing) {
        context.read<ProductBloc>().add(
          UpdateProductEvent(
            id: widget.product!.id,
            formModel: formModel,
            imageFile: _selectedImage,
          ),
        );
      } else {
        context.read<ProductBloc>().add(
          AddProductEvent(formModel: formModel, imageFile: _selectedImage!),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.product != null;
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is AddProductSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Produk berhasil ditambahkan')),
          );
          Navigator.pushNamed(context, AppRoutes.listProduct);
        } else if (state is UpdateProductSuccess) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Produk berhasil diperbarui')));
        } else if (state is AddProductFailure ||
            state is UpdateProductFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isEditing ? 'Edit gagal' : 'Gagal menambahkan produk',
              ),
            ),
          );
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
                  Center(
                    child: Text(
                      isEditing ? 'Edit Produk' : 'Tambah Produk',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Upload Image
                  GestureDetector(
                    onTap: _pickImage,
                    child: CustomPaint(
                      painter: DashedBorderPainter(
                        color: _imageError != null ? Colors.red : Colors.grey,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        padding: const EdgeInsets.all(16),
                        child:
                            _selectedImage != null
                                ? Image.file(_selectedImage!, fit: BoxFit.cover)
                                : (_imageUrl != null
                                    ? Image.network(
                                      _imageUrl!,
                                      fit: BoxFit.cover,
                                    )
                                    : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.add_circle,
                                          color: Colors.blue,
                                          size: 32,
                                        ),
                                        SizedBox(height: 8),
                                        Text.rich(
                                          TextSpan(
                                            text: 'Seret & Letakkan atau ',
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: 'Pilih File',
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                ),
                                              ),
                                              TextSpan(text: ' untuk diunggah'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Format: JPG, PNG • Maks: 5MB',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    )),
                      ),
                    ),
                  ),
                  if (_imageError != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _imageError!,
                        style: const TextStyle(color: Colors.red, fontSize: 12),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Nama Produk
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Produk',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      // Contoh validasi unik produk jika perlu
                      if (value.trim().toLowerCase() == 'gacoan') {
                        return 'Produk Ini Sudah Tersedia.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Harga
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Harga',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Harga tidak boleh kosong';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Harga harus berupa angka';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Kategori
                  BlocProvider(
                    create:
                        (context) =>
                            di.locator<ProductBloc>()
                              ..add(FetchCategoriesEvent()),
                    child: BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, state) {
                        if (state is CategoryLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is CategoryLoaded) {
                          final categories = state.categories;

                          // Cek jika sedang edit dan _selectedCategory masih null
                          if (widget.product != null &&
                              _selectedCategory == null) {
                            try {
                              _selectedCategory = categories.firstWhere(
                                (category) =>
                                    category.id == widget.product!.categoryId,
                              );
                            } catch (e) {
                              _selectedCategory = null;
                            }
                          }

                          return DropdownButtonFormField<Category>(
                            value: _selectedCategory,
                            decoration: const InputDecoration(
                              labelText: 'Pilih Kategori',
                              border: OutlineInputBorder(),
                            ),
                            items:
                                categories.map((category) {
                                  return DropdownMenuItem<Category>(
                                    value: category,
                                    child: Text(category.name),
                                  );
                                }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedCategory = val;
                              });
                            },
                            validator: (value) {
                              if (value == null) {
                                return 'Kategori wajib dipilih';
                              }
                              // contoh validasi jika ingin pakai name
                              if (value.name == 'Makanan Pedas') {
                                return 'Kategori Ini Sudah Tersedia.';
                              }
                              return null;
                            },
                          );
                        } else if (state is CategoryError) {
                          return Text(
                            'Gagal memuat kategori: ${state.message}',
                            style: const TextStyle(color: Colors.red),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
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
                          child: Text(
                            isEditing ? 'Simpan Perubahan' : 'Tambah',
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
