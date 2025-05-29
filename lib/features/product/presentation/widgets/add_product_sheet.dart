import 'package:flutter/material.dart';

import '../../../core/presentation/widgets/dashed_border.dart';

class AddProductSheet extends StatefulWidget {
  const AddProductSheet({super.key});

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  String? _selectedCategory;
  String? _imageError;

  final List<String> _categories = ['Makanan Pedas', 'Minuman', 'Cemilan'];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    final isValid = _formKey.currentState!.validate();

    setState(() {
      // Simulasi error dari backend
      _imageError = 'Filemu Terlalu Besar, Melebihi 5 MB';
    });

    if (isValid && _imageError == null) {
      // Simpan data
      print('Nama: ${_nameController.text}');
      print('Harga: ${_priceController.text}');
      print('Kategori: $_selectedCategory');
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
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
                    'Tambah Produk',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // Upload Section (Dummy)
                CustomPaint(
                  painter: DashedBorderPainter(
                    color: _imageError != null ? Colors.red : Colors.grey,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 150,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.add_circle, color: Colors.blue, size: 32),
                        SizedBox(height: 8),
                        Text.rich(
                          TextSpan(
                            text: 'Seret & Letakkan atau ',
                            style: TextStyle(color: Colors.black),
                            children: [
                              TextSpan(
                                text: 'Pilih File',
                                style: TextStyle(color: Colors.blue),
                              ),
                              TextSpan(text: ' untuk diunggah'),
                            ],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Format Yang Didukung: Jpg & Png\nGunakan File Maksimum 5Mb',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
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
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Pilih Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      _categories
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                  onChanged: (val) {
                    setState(() {
                      _selectedCategory = val;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Kategori wajib dipilih';
                    }
                    if (value == 'Makanan Pedas') {
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
                        child: const Text('Batal'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Tambah'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40), // Tambahan agar ada ruang di bawah
              ],
            ),
          ),
        );
      },
    );
  }
}
