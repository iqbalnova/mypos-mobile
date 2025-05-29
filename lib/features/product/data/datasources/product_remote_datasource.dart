import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../core/common/exception.dart';
import '../../../core/helper/secure_storage_helper.dart';
import '../models/category_model.dart';
import '../models/product_form_model.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> addCategory(String name);
  Future<void> updateCategory(String id, String name);
  Future<void> deleteCategory(String id);
  Future<List<ProductModel>> getProducts();
  Future<void> addProduct(ProductFormModel formModel, File imageFile);
  Future<void> updateProduct(
    String id,
    ProductFormModel formModel,
    File? imageFile,
  );
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;
  final SecureStorageHelper secureStorageHelper;

  ProductRemoteDataSourceImpl({
    required this.client,
    required this.secureStorageHelper,
  });

  Future<Map<String, String>> _getHeaders() async {
    final token = await secureStorageHelper.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
    };
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    final headers = await _getHeaders();

    final response = await client.get(
      Uri.parse('https://mas-pos.appmedia.id/api/v1/category'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => CategoryModel.fromJson(e)).toList();
    } else {
      final error =
          json.decode(response.body)['message'] ?? 'Get Categories Failed';
      throw ServerException(error);
    }
  }

  @override
  Future<void> addCategory(String name) async {
    final response = await client.post(
      Uri.parse('https://mas-pos.appmedia.id/api/v1/category'),
      headers: await _getHeaders(),
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to add category');
    }
  }

  @override
  Future<void> updateCategory(String id, String name) async {
    final response = await client.put(
      Uri.parse('https://mas-pos.appmedia.id/api/v1/category/$id'),
      headers: await _getHeaders(),
      body: jsonEncode({'name': name}),
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to update category');
    }
  }

  @override
  Future<void> deleteCategory(String id) async {
    final response = await client.delete(
      Uri.parse('https://mas-pos.appmedia.id/api/v1/category/$id'),
      headers: await _getHeaders(),
    );
    if (response.statusCode != 200) {
      throw ServerException('Failed to delete category');
    }
  }

  // Products
  @override
  Future<List<ProductModel>> getProducts() async {
    final headers = await _getHeaders();

    final response = await client.get(
      Uri.parse('https://mas-pos.appmedia.id/api/v1/product'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => ProductModel.fromJson(e)).toList();
    } else {
      final error =
          json.decode(response.body)['message'] ?? 'Get Products Failed';
      throw ServerException(error);
    }
  }

  @override
  Future<void> addProduct(ProductFormModel formModel, File imageFile) async {
    final uri = Uri.parse('https://mas-pos.appmedia.id/api/v1/product');
    final request = http.MultipartRequest('POST', uri);

    // Tambahkan headers
    final headers = await _getHeaders();
    request.headers.addAll(headers);

    // Tambahkan field form
    request.fields['category_id'] = formModel.categoryId;
    request.fields['name'] = formModel.name;
    request.fields['price'] = formModel.price.toString();

    // Tambahkan file gambar
    request.files.add(
      await http.MultipartFile.fromPath('picture', imageFile.path),
    );

    // Kirim request
    final response = await request.send();

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      final error = json.decode(body)['message'] ?? 'Failed to add product';
      throw ServerException(error);
    }
  }

  @override
  Future<void> updateProduct(
    String id,
    ProductFormModel formModel,
    File? imageFile,
  ) async {
    final uri = Uri.parse(
      'https://mas-pos.appmedia.id/api/v1/product/update/$id',
    );
    final request = http.MultipartRequest('POST', uri);

    // Tambahkan headers
    final headers = await _getHeaders();
    request.headers.addAll(headers);

    // Tambahkan field form
    request.fields['category_id'] = formModel.categoryId;
    request.fields['name'] = formModel.name;
    request.fields['price'] = formModel.price.toString();

    // Tambahkan file gambar jika ada
    if (imageFile != null && imageFile.path.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath('picture', imageFile.path),
      );
    }

    // Kirim request
    final response = await request.send();

    if (response.statusCode != 200) {
      final body = await response.stream.bytesToString();
      final error = json.decode(body)['message'] ?? 'Failed to update product';
      throw ServerException(error);
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await client.delete(
      Uri.parse('https://mas-pos.appmedia.id/api/v1/product/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      final error =
          json.decode(response.body)['message'] ?? 'Failed to delete product';
      throw ServerException(error);
    }
  }
}
