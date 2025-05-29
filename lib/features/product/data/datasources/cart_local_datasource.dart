import '../../../core/helper/db/database_helper.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<CartItemModel> addCartItem(CartItemModel cartItem);
  Future<CartItemModel> updateCartItem(CartItemModel cartItem);
  Future<void> removeCartItem(String productId);
  Future<void> clearCart();
  Future<void> bulkRemoveCartItems(List<String> productIds);
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final DatabaseHelper databaseHelper;

  CartLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('cart_items');

    return List.generate(maps.length, (i) {
      return CartItemModel.fromJson(maps[i]);
    });
  }

  @override
  Future<CartItemModel> addCartItem(CartItemModel cartItem) async {
    final db = await databaseHelper.database;

    // Check if item already exists
    final existingItems = await db.query(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [cartItem.productId],
    );

    if (existingItems.isNotEmpty) {
      // Update quantity if item exists
      final existingItem = CartItemModel.fromJson(existingItems.first);
      final updatedItem = CartItemModel(
        id: existingItem.id,
        productId: existingItem.productId,
        productName: existingItem.productName,
        imageUrl: existingItem.imageUrl,
        price: existingItem.price,
        quantity: existingItem.quantity + cartItem.quantity,
      );
      return await updateCartItem(updatedItem);
    } else {
      // Insert new item
      final id = await db.insert('cart_items', cartItem.toJson());
      return cartItem.copyWith(id: id);
    }
  }

  @override
  Future<CartItemModel> updateCartItem(CartItemModel cartItem) async {
    final db = await databaseHelper.database;

    await db.update(
      'cart_items',
      cartItem.toJson(),
      where: 'id = ?',
      whereArgs: [cartItem.id],
    );

    return cartItem;
  }

  @override
  Future<void> removeCartItem(String productId) async {
    final db = await databaseHelper.database;

    await db.delete(
      'cart_items',
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  @override
  Future<void> bulkRemoveCartItems(List<String> productIds) async {
    final db = await databaseHelper.database;

    // Jika list kosong, tidak perlu melakukan query
    if (productIds.isEmpty) return;

    // Buat placeholder untuk IN clause (?, ?, ?)
    final placeholders = List.filled(productIds.length, '?').join(', ');

    await db.delete(
      'cart_items',
      where: 'productId IN ($placeholders)',
      whereArgs: productIds,
    );
  }

  @override
  Future<void> clearCart() async {
    final db = await databaseHelper.database;
    await db.delete('cart_items');
  }
}
