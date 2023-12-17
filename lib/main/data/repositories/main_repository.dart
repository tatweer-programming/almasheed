
import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../data_source/main_remote_data_source.dart';

class MainRepository {
  final MainRemoteDataSource mainRemoteDataSource;
  MainRepository(this.mainRemoteDataSource);
  Future<Either<FirebaseException, List<Product>>> getProducts() async {
    return await mainRemoteDataSource.getProducts();
  }Future<Either<FirebaseException, List<Category>>> getCategories() async {
    return await mainRemoteDataSource.getCategories();
  }Future<Either<FirebaseException, List<String>>> getOffers() async {
    return await mainRemoteDataSource.getOffers();
  }Future<Either<FirebaseException, Map<String,int>>> getBestSales() async {
    return await mainRemoteDataSource.getBestSales();
  }
}
