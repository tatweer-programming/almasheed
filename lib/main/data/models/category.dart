import 'package:almasheed/main/data/models/product.dart';

class Category {
  final String categoryName;
  final String categoryImage;
  final List<String> productsIds;
  List<Product>? products;
  Category({
    required this.categoryName,
    required this.categoryImage,
    required this.productsIds,
    this.products
  });
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        productsIds: List<String>.from(json['productsIds'])
            .map((id) => id)
            .toList(),
        categoryName: json['categoryName'],
        categoryImage: json['categoryImage'],
      );
}
