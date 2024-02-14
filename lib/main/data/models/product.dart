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
  final String productOverview;
  final String productWorkCharacteristics;
  final String productMainUses;
  final String merchantId;
  final String merchantName;
  final String productCity;
  final ProductCustomProperties? customProperties;

  Product(
      {required this.productName,
      this.productCategory,
      required this.productId,
      required this.productMainUses,
      this.productsImagesUrl,
      required this.productOldPrice,
      required this.productNewPrice,
      required this.productWorkCharacteristics,
      required this.productCity,
      required this.merchantId,
      this.productsImagesFile,
      this.productsImagesDelete,
      required this.productOverview,
      required this.merchantName,
      this.customProperties});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        productOverview: json['productOverview'],
        productMainUses: json['productMainUses'],
        productWorkCharacteristics: json['productWorkCharacteristics'],
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
        customProperties:
            ProductCustomProperties.fromJson(json["customProperties"]),
      );

  Map<String, dynamic> toJson() {
    return {
      'productWorkCharacteristics': productWorkCharacteristics,
      'productOverview': productOverview,
      "productId": productId,
      "merchantId": merchantId,
      "productMainUses": productMainUses,
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
        productOverview,
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
