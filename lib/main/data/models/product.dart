import 'dart:io';

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String productName;
  final String productId;
  final List<String> productsImagesUrl;
  List<File>? productsImagesFile;
  List<String>? productsImagesDelete;
  final double productPrice;
  final double productDiscount;
  final String productDescription;
  final String merchantName;
  final String productCity;
  Product(
      {required this.productName,
      required this.productId,
      required this.productsImagesUrl,
      required this.productPrice,
      required this.productDiscount,
      required this.productCity,
      this.productsImagesFile,
      this.productsImagesDelete,
      required this.productDescription,
      required this.merchantName});
  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productDescription: json['productDescription'],
        productId: json['productId'],
        productCity: json['productCity'],
        productDiscount: json['productDiscount'].toDouble(),
        productsImagesUrl: List<String>.from(json['productsImages'])
            .map((image) => image)
            .toList(),
        productName: json['productName'],
        productPrice: json['productPrice'].toDouble(),
        merchantName: json['merchantName'],
      );
  Map<String, dynamic> toJson() {
    return {
      'productDescription': productDescription,
      "productId": productId,
      "productCity": productCity,
      "productDiscount": productDiscount,
      "productsImages": productsImagesUrl,
      "productName": productName,
      "productPrice": productPrice,
      "merchantName": merchantName,
    };
  }

  @override
  List<Object?> get props => [
        productDescription,
        productId,
        productDiscount,
        productName,
        productPrice,
        merchantName,
        productCity,
        productsImagesUrl
      ];
}
