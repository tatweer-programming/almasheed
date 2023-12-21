import 'package:almasheed/main/data/models/product.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

//ignore: must_be_immutable
class Category extends Equatable {
  final String categoryName;
  String? categoryImage;
  final List<String> productsIds;
  List<Product>? products;
  XFile? categoryImageFile;
  Category(
      {required this.categoryName,
      this.categoryImage,
      required this.productsIds,
      this.products,
      this.categoryImageFile});
  factory Category.fromJson(Map<String, dynamic> json) => Category(
        productsIds:
            List<String>.from(json['productsIds']).map((id) => id).toList(),
        categoryName: json['categoryName'],
        categoryImage: json['categoryImage'],
      );
  Map<String, dynamic> toJson() {
    return {
      "productsIds": productsIds,
      "categoryName": categoryName,
      "categoryImage": categoryImage
    };
  }

  @override
  List<Object?> get props => [categoryImage, categoryName, productsIds];
}
