import 'package:almasheed/main/data/models/custom_properties.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

//ignore: must_be_immutable
class Product extends Equatable {
  final String productName;
  String? productCategory;
  final String productId;
  List<String>? productsImagesUrl;
  List<XFile>? productsImagesFile;
  List<String>? productsImagesDelete;
  final double productOldPrice;
  final double productNewPrice;
  final String productDescription;
  final String merchantId;
  final String merchantName;
  final String productCity;
  final PorductCustomProperties? customProperties;

  Product(
      {required this.productName,
      this.productCategory,
      required this.productId,
      this.productsImagesUrl,
      required this.productOldPrice,
      required this.productNewPrice,
      required this.productCity,
      required this.merchantId,
      this.productsImagesFile,
      this.productsImagesDelete,
      required this.productDescription,
      required this.merchantName,
      this.customProperties});

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
        merchantId: json['merchantId'],
        // customProperties:
        //     PorductCustomProperties.fromJson(json["customProperties"]),
      );

  Map<String, dynamic> toJson() {
    return {
      'productDescription': productDescription,
      "productId": productId,
      "merchantId": merchantId,
      "productCity": productCity,
      "productNewPrice": productNewPrice,
      "productsImages": productsImagesUrl,
      "productName": productName,
      "productOldPrice": productOldPrice,
      "merchantName": merchantName,
      "customProperties": customProperties?.toJson()
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
        productsImagesUrl,
        customProperties
      ];
}
