import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../core/common/exception.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final http.Client client;

  AuthRemoteDataSourceImpl({required this.client});

  @override
  Future<UserModel> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('https://mas-pos.appmedia.id/api/v1/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      print(response.body);
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      final error = json.decode(response.body)['message'] ?? 'Login failed';
      throw ServerException(error);
    }
  }
}
