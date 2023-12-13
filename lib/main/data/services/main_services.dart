import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

class MainServices {
  final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

  Future<Either<FirebaseException,List<Product>>> getProducts()async{
    try {
      List<Product> products = [];
      await firebaseInstance.collection("products")
          .get()
          .then((value) {
        for (var element in value.docs) {
          products.add(Product.fromJson(element.data()));
        }
      });
      return Right(products);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }
  Future<Either<FirebaseException,List<Category>>> getCategories()async{
    try {
      List<Category> categories = [];
      await firebaseInstance.collection("categories")
          .get()
          .then((value) {
        for (var element in value.docs) {
          categories.add(Category.fromJson(element.data()));
        }
      });
      return Right(categories);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }
}