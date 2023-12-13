import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String productName;
  final String productId;
  final List<String> productsImages;
  final double productPrice;
  final double productDiscount;
  final String productDescription;
  final String sellerName;
  const Product(
      {required this.productName,
      required this.productId,
      required this.productsImages,
      required this.productPrice,
      required this.productDiscount,
      required this.productDescription,
      required this.sellerName});
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productDescription: json['productDescription'],
        productId: json['productId'],
        productDiscount: json['productDiscount'],
        productsImages: List<String>.from(json['productsImages'])
            .map((image) => image)
            .toList(),
        productName: json['productName'],
        productPrice: json['productPrice'],
        sellerName: json['sellerName'],
      );

  @override
  List<Object?> get props => [
        productDescription,
        productId,
        productDiscount,
        productName,
        productPrice,
        sellerName,
        productsImages
      ];
}
