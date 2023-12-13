import 'package:almasheed/main/data/models/product.dart';
import 'package:equatable/equatable.dart';

class Offer extends Equatable{
  final List<String> productsIds;
  List<Product>? products;
  Offer({
    required this.productsIds,
    this.products
  });
  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        productsIds: List<String>.from(json['productsIds'])
            .map((id) => id)
            .toList(),
      );

  @override
  List<Object?> get props => [productsIds,];
}
