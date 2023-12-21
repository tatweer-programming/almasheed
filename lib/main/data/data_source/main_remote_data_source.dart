import 'dart:io';

import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../authentication/data/models/merchant.dart';

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

  Future<Either<FirebaseException, Unit>> setProduct({
    required Product product,
  }) async {
    try {
      var batch = FirebaseFirestore.instance.batch();
      product.productsImagesUrl ??= [];
      if (product.productsImagesFile != null) {
        for (XFile imageFile in product.productsImagesFile!) {
          String imageUrl = await _uploadImageToFirebaseStorage(
              imageFile: imageFile,
              fileName:
                  "products/${product.productName}/${Uri.file(imageFile.path).pathSegments.last}");
          product.productsImagesUrl!.add(imageUrl);
        }
      }
      var products =
          firebaseInstance.collection("products").doc(product.productId);
      var offers = firebaseInstance.collection("offers").doc("offers");
      var merchants = firebaseInstance
          .collection("merchants")
          .doc(ConstantsManager.appUser!.id);
      var bestSales =
          firebaseInstance.collection("best_sales").doc("best_sales");
      var categories = firebaseInstance
          .collection("categories")
          .doc(product.productCategory);
      batch.set(products, product.toJson());
      batch.set(bestSales, {product.productId.replaceAll(".", "*") : 0});
      batch.update(categories, {
        "productsIds": FieldValue.arrayUnion([product.productId])
      });
      batch.update(merchants, {
        "productsIds": FieldValue.arrayUnion([product.productId])
      });
      if (product.productNewPrice != product.productOldPrice) {
        batch.update(offers, {
          "productsIds": FieldValue.arrayUnion([product.productId])
        });
      }
      await batch.commit();
      return const Right(unit);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, Unit>> deleteProduct({
    required Product product,
  }) async {
    try {
      var batch = FirebaseFirestore.instance.batch();
      var bestSales = firebaseInstance.collection("best_sales").doc("best_sales");
      var offers = firebaseInstance.collection("offers").doc("offers");
      var products = firebaseInstance.collection("products").doc(product.productId);
      var categories = firebaseInstance.collection("categories").doc(product.productCategory);
      var merchants = firebaseInstance.collection("merchants").doc(ConstantsManager.appUser!.id);
      batch.delete(products,);
      batch.update(bestSales, {product.productId.replaceAll(".", "*"): FieldValue.delete()});
      batch.update(categories, {
        "productsIds": FieldValue.arrayRemove([product.productId])
      });
      batch.update(merchants, {
        "productsIds": FieldValue.arrayRemove([product.productId])
      });
      if (product.productNewPrice != product.productOldPrice) {
        batch.update(offers, {
          "productsIds": FieldValue.arrayRemove([product.productId])
        });
      }
      await batch.commit();
      return const Right(unit);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, Unit>> modifyProduct({
    required Product product,
  }) async {
    try {
      if (product.productsImagesDelete != null &&
          product.productsImagesDelete!.isNotEmpty) {
        for (String productImage in product.productsImagesDelete!) {
          _deleteImageFromFirebaseStorage(
              fileName: Uri.parse(productImage).pathSegments.last);
        }
        product.productsImagesDelete!.clear();
      }
      if (product.productsImagesFile != null &&
          product.productsImagesFile!.isNotEmpty) {
        for (XFile imageFile in product.productsImagesFile!) {
          String imageUrl = await _uploadImageToFirebaseStorage(
              imageFile: imageFile,
              fileName:
                  "products/${product.productName}/${Uri.file(imageFile.path).pathSegments.last}");
          product.productsImagesUrl!.add(imageUrl);
        }
      }
      await firebaseInstance
          .collection("products")
          .doc(product.productId)
          .update(product.toJson());
      return const Right(unit);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, Unit>> setCategory({
    required Category category,
  }) async {
    try {
      if (category.categoryImageFile != null) {
        await _uploadImageToFirebaseStorage(
                imageFile: category.categoryImageFile!,
                fileName:
                    "categories/${category.categoryName}/${Uri.file(category.categoryImageFile!.path).pathSegments.last}")
            .then((categoryImage) {
          category.categoryImage = categoryImage;
        });
      }
      await firebaseInstance
          .collection("categories")
          .doc(category.categoryName)
          .set(category.toJson());
      return const Right(unit);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, Unit>> addAndRemoveFromFavorites({
    required List<String> favorites,
  }) async {
    try {
      await firebaseInstance
          .collection("customers")
          .doc(ConstantsManager.appUser!.id)
          .update({
        "favorites": favorites
      });
      return const Right(unit);
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
        (key, value) => MapEntry(key.replaceAll("*", "."), value is int ? value : 0),
      );
      return Right(bestSales);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, List<Merchant>>> getMerchants() async {
    try {
      List<Merchant> merchants = [];
      await firebaseInstance.collection("merchants").get().then((value) {
        for (var element in value.docs) {
          merchants.add(Merchant.fromJson(element.data()));
        }
      });
      return Right(merchants);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  void _deleteImageFromFirebaseStorage({required String fileName}) async {
    FirebaseStorage.instance.ref().child(fileName).delete();
  }

  Future<String> _uploadImageToFirebaseStorage(
      {required XFile imageFile, required String fileName}) async {
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    await reference.putFile(File(imageFile.path));
    return reference.getDownloadURL();
  }
}
