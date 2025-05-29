import '../../domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    super.id,
    required super.productId,
    required super.productName,
    required super.imageUrl,
    required super.price,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'],
      productId: json['productId'],
      productName: json['productName'],
      imageUrl: json['imageUrl'],
      price: json['price']?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 0,
    );
  }

  factory CartItemModel.fromEntity(CartItem cartItem) {
    return CartItemModel(
      id: cartItem.id,
      productId: cartItem.productId,
      productName: cartItem.productName,
      imageUrl: cartItem.imageUrl,
      price: cartItem.price,
      quantity: cartItem.quantity,
    );
  }

  CartItem toEntity() {
    return CartItem(
      id: id,
      productId: productId,
      productName: productName,
      imageUrl: imageUrl,
      price: price,
      quantity: quantity,
    );
  }

  @override
  CartItemModel copyWith({
    int? id,
    String? productId,
    String? productName,
    String? imageUrl,
    double? price,
    int? quantity,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }
}
