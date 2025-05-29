import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    return UserModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      token: data['token'],
    );
  }
}
