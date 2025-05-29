import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/common/exception.dart';
import '../../../core/helper/secure_storage_helper.dart';
import '../models/category_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<void> addCategory(String name);
  Future<void> updateCategory(String id, String name);
  Future<void> deleteCategory(String id);
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
}
