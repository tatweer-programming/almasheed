import 'package:almasheed/authentication/data/models/merchant.dart';
import 'package:almasheed/authentication/data/models/worker.dart';
import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/data/models/rating.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../data_source/main_remote_data_source.dart';
import '../models/order_for_workers.dart';

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

  Future<Either<FirebaseException, List<Worker>>> getWorkers() async {
    return await mainRemoteDataSource.getWorkers();
  }

  Future<Either<FirebaseException, List<OrderForWorkers>>>
      getOrderForWorkers() async {
    return await mainRemoteDataSource.getOrderForWorkers();
  }

  Future<Either<FirebaseException, List<String>>> getBanners() async {
    return await mainRemoteDataSource.getBanners();
  }

  Future<Either<FirebaseException, Unit>> setProduct(
      {required Product product}) async {
    return await mainRemoteDataSource.setProduct(product: product);
  }

  Future<Either<FirebaseException, Unit>> updateProduct(
      {required Product product}) async {
    return await mainRemoteDataSource.updateProduct(product: product);
  }

  Future<Either<FirebaseException, Unit>> setCategory(
      {required Category category}) async {
    return await mainRemoteDataSource.setCategory(category: category);
  }

  Future<Either<FirebaseException, Unit>> setOrderForWorkers(
      {required OrderForWorkers orderForWorkers}) async {
    return await mainRemoteDataSource.setOrderForWorkers(
        orderForWorkers: orderForWorkers);
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

  Future<Either<FirebaseException, Product>> productRatingUpdate({
    required Rating rating,
    required List<Rating> ratings,
    required String productId,
  }) async {
    return await mainRemoteDataSource.productRatingUpdate(
        ratings: ratings,
        productId: productId, rating: rating);
  }

  Future<Either<FirebaseException, Unit>> getUserData() {
    return mainRemoteDataSource.getUserData();
  }
}
