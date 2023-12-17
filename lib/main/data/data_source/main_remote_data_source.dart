import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class MainRemoteDataSource {
  final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

  Future<Either<FirebaseException, List<Product>>> getProducts() async {
    try {
      List<Product> products = [];
      await firebaseInstance.collection("products").get().then((value) {
        for (var element in value.docs) {
          products.add(Product.fromJson(element.data()));
        }
      });
      return Right(products);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, List<Category>>> getCategories() async {
    try {
      List<Category> categories = [];
      await firebaseInstance.collection("categories").get().then((value) {
        for (var element in value.docs) {
          categories.add(Category.fromJson(element.data()));
        }
      });
      return Right(categories);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, List<String>>> getOffers() async {
    try {
      List<String> offers = [];
      await firebaseInstance
          .collection("offers")
          .doc("offers")
          .get()
          .then((value) {
        offers = List<String>.from(value.data()!["productsIds"])
            .map((e) => e)
            .toList();
      });
      return Right(offers);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, Map<String, int>>> getBestSales() async {
    try {
      Map<String, dynamic> data = {};
      await firebaseInstance
          .collection("best_sales")
          .doc("best_sales")
          .get()
          .then((value) {
        data = value.data() as Map<String, dynamic>;
      });
      Map<String, int> bestSales = data.map(
            (key, value) => MapEntry(key, value is int ? value : 0),
      );
      return Right(bestSales);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }
}
