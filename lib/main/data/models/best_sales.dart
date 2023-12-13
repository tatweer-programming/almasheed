import 'package:almasheed/main/data/models/product.dart';
import 'package:equatable/equatable.dart';

class BestSales extends Equatable{
  final List<String> productsIds;
  List<Product>? products;
  BestSales({
    required this.productsIds,
    this.products
  });
  factory BestSales.fromJson(Map<String, dynamic> json) => BestSales(
    productsIds: List<String>.from(json['productsIds'])
        .map((id) => id)
        .toList(),
  );

  @override
  List<Object?> get props => [productsIds,];
}
