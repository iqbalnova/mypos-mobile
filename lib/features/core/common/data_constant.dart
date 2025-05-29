import '../../product/domain/entities/product.dart';

const List<String> categories = [
  'All',
  'Shoes',
  'Clothing',
  'Accessories',
  'Electronics',
  'Sports',
];

final List<Map<String, dynamic>> promotions = [
  {'image': 'assets/images/banner1.png'},
  {'image': 'assets/images/banner2.png'},
  {'image': 'assets/images/banner3.png'},
];

final List<Product> dummyProducts = [
  Product(
    id: "221208a1-74b2-41a7-b95e-cb73b83b1524",
    categoryId: "f1d0e615-6b99-4ad7-a1c4-06087ea0db85",
    name: "Smart Hydroponic Kit",
    price: 13213,
    pictureUrl:
        "https://images.unsplash.com/photo-1647456612962-f081347a1178?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZCUyMGFuaW1hdGlvbnxlbnwwfHwwfHx8MA%3D%3D",
    createdAt: DateTime.parse("2025-01-23T04:49:31.320Z"),
    updatedAt: DateTime.parse("2025-01-23T04:49:31.320Z"),
  ),
  Product(
    id: "b321ba91-6ee9-4a10-aaa7-29f1a7e33fba",
    categoryId: "8e52e234-8a9c-41ea-977b-25e620d9f6a1",
    name: "IoT Irrigation Controller",
    price: 249000,
    pictureUrl:
        "https://images.unsplash.com/photo-1647456612962-f081347a1178?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZCUyMGFuaW1hdGlvbnxlbnwwfHwwfHx8MA%3D%3D",
    createdAt: DateTime.parse("2025-02-10T09:30:00.000Z"),
    updatedAt: DateTime.parse("2025-02-10T09:30:00.000Z"),
  ),
  Product(
    id: "c123cd23-999f-4231-b99d-bae30c2e77cb",
    categoryId: "ab2ffcd9-4b67-4df7-a5f2-fd8b1b6ecb21",
    name: "Urban Farming Starter Pack",
    price: 99000,
    pictureUrl:
        "https://images.unsplash.com/photo-1647456612962-f081347a1178?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZCUyMGFuaW1hdGlvbnxlbnwwfHwwfHx8MA%3D%3D",
    createdAt: DateTime.parse("2025-03-01T12:00:00.000Z"),
    updatedAt: DateTime.parse("2025-03-01T12:00:00.000Z"),
  ),
  Product(
    id: "d456df45-1ef3-4b22-9d21-2a2a0660dfd8",
    categoryId: "5ac8df43-79a1-48d3-b0a4-70cbbfcb7f77",
    name: "Fertilizer AB Mix (1L)",
    price: 45000,
    pictureUrl:
        "https://images.unsplash.com/photo-1647456612962-f081347a1178?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZCUyMGFuaW1hdGlvbnxlbnwwfHwwfHx8MA%3D%3D",
    createdAt: DateTime.parse("2025-03-12T15:45:00.000Z"),
    updatedAt: DateTime.parse("2025-03-12T15:45:00.000Z"),
  ),
];

class PaymentMethod {
  final int id;
  final String title;
  final String imageUrl;

  PaymentMethod({
    required this.id,
    required this.title,
    required this.imageUrl,
  });
}

final List<PaymentMethod> paymentMethods = [
  PaymentMethod(id: 1, title: 'Tunai', imageUrl: 'assets/icons/tunai.png'),
  PaymentMethod(id: 2, title: 'QRIS', imageUrl: 'assets/icons/qris.png'),
];
