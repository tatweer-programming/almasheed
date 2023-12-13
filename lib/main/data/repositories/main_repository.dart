
import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../data_source/main_remote_data_source.dart';

class MainRepository {
  MainRemoteDataSource mainServices;
  MainRepository(this.mainServices);
  Future<Either<FirebaseException, List<Product>>> getProducts() async {
    return await mainServices.getProducts();
  }Future<Either<FirebaseException, List<Category>>> getCategories() async {
    return await mainServices.getCategories();
  }Future<Either<FirebaseException, List<String>>> getOffers() async {
    return await mainServices.getOffers();
  }
}
