import 'package:almasheed/authentication/data/models/merchant.dart';
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
  }

  Future<Either<FirebaseException, List<Category>>> getCategories() async {
    return await mainRemoteDataSource.getCategories();
  }

  Future<Either<FirebaseException, List<String>>> getOffers() async {
    return await mainRemoteDataSource.getOffers();
  }

  Future<Either<FirebaseException, Map<String, int>>> getBestSales() async {
    return await mainRemoteDataSource.getBestSales();
  }

  Future<Either<FirebaseException, List<Merchant>>> getMerchants() async {
    return await mainRemoteDataSource.getMerchants();
  }

  Future<Either<FirebaseException, Unit>> setProduct(
      {required Product product}) async {
    return await mainRemoteDataSource.setProduct(product: product);
  }

  Future<Either<FirebaseException, Unit>> modifyProduct(
      {required Product product}) async {
    return await mainRemoteDataSource.modifyProduct(product: product);
  }

  Future<Either<FirebaseException, Unit>> setCategory(
      {required Category category}) async {
    return await mainRemoteDataSource.setCategory(category: category);
  }

  Future<Either<FirebaseException, Unit>> deleteProduct(
      {required Product product}) async {
    return await mainRemoteDataSource.deleteProduct(product: product);
  }

  Future<Either<FirebaseException, Unit>> addAndRemoveFromFavorites({
    required List<String> favorites,
  }) async {
    return await mainRemoteDataSource.addAndRemoveFromFavorites(
        favorites: favorites);
  }

  Future<Either<FirebaseException, (double,int)>> productRatingUpdate({
    required double productRating,
    required String productId,
  }) async {
    return await mainRemoteDataSource.productRatingUpdate(
        productId: productId, productRating: productRating);
  }

  Future<Either<FirebaseException, Unit>> getUserData() {
    return mainRemoteDataSource.getUserData();
  }
}
