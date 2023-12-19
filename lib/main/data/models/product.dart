import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class Product extends Equatable {
  final String productName;
  String? productId;
  List<String>? productsImagesUrl;
  List<XFile>? productsImagesFile;
  List<String>? productsImagesDelete;
  final double productOldPrice;
  final double productNewPrice;
  final String productDescription;
  final String merchantName;
  final String productCity;

  Product(
      {required this.productName,
      this.productId,
      this.productsImagesUrl,
      required this.productOldPrice,
      required this.productNewPrice,
      required this.productCity,
      this.productsImagesFile,
      this.productsImagesDelete,
      required this.productDescription,
      required this.merchantName});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productDescription: json['productDescription'],
        productId: json['productId'],
        productCity: json['productCity'],
        productNewPrice: json['productNewPrice'].toDouble(),
        productsImagesUrl: List<String>.from(json['productsImages'])
            .map((image) => image)
            .toList(),
        productName: json['productName'],
        productOldPrice: json['productOldPrice'].toDouble(),
        merchantName: json['merchantName'],
      );

  Map<String, dynamic> toJson() {
    return {
      'productDescription': productDescription,
      "productId": productId,
      "productCity": productCity,
      "productDiscount": productNewPrice,
      "productsImages": productsImagesUrl,
      "productName": productName,
      "productPrice": productOldPrice,
      "merchantName": merchantName,
    };
  }

  @override
  List<Object?> get props => [
        productDescription,
        productId,
        productNewPrice,
        productName,
        productOldPrice,
        merchantName,
        productCity,
        productsImagesUrl
      ];
}
