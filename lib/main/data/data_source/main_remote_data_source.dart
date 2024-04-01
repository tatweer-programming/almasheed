import 'dart:convert';
import 'dart:io';

import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:http/http.dart' as http;
import 'package:almasheed/authentication/data/models/user.dart';
import 'package:almasheed/authentication/data/models/worker.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../authentication/data/models/merchant.dart';
import '../models/order_for_workers.dart';

class MainRemoteDataSource {
  final FirebaseFirestore firebaseInstance = FirebaseFirestore.instance;

  /// Set
  Future<Either<FirebaseException, Unit>> setProduct({
    required Product product,
  }) async {
    try {
      var batch = firebaseInstance.batch();
      product.productsImagesUrl ??= [];

      if (product.productsImagesFile != null) {
        for (XFile imageFile in product.productsImagesFile!) {
          String imageUrl = await _uploadImageToFirebaseStorage(
            imageFile: imageFile,
            fileName:
                "products/${product.productName}/${Uri.file(imageFile.path).pathSegments.last}",
          );
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
      batch.update(bestSales, {product.productId.replaceAll(".", "-"): 0});

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
      print("error $error");
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
              "categories/${category.categoryName}/${Uri.file(category.categoryImageFile!.path).pathSegments.last}",
        ).then((categoryImage) {
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

  Future<Either<FirebaseException, Unit>> setOrderForWorkers({
    required OrderForWorkers orderForWorkers,
  }) async {
    try {
      var batch = firebaseInstance.batch();
      String newOrderId =
          firebaseInstance.collection("orders_for_workers").doc().id;
      orderForWorkers.orderId = newOrderId;
      await _setOrderInWorkers(orderForWorkers: orderForWorkers, batch: batch);
      var order =
          firebaseInstance.collection("orders_for_workers").doc(newOrderId);
      batch.set(order, orderForWorkers.toJson());
      await batch.commit();
      return const Right(unit);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  /// Update

  Future<Either<FirebaseException, Unit>> updateProduct({
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
                "products/${product.productName}/${Uri.file(imageFile.path).pathSegments.last}",
          );
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

  Future<Either<FirebaseException, Unit>> addAndRemoveFromFavorites({
    required List<String> favorites,
  }) async {
    try {
      await firebaseInstance
          .collection("customers")
          .doc(ConstantsManager.appUser!.id)
          .update({"favorites": favorites});
      return const Right(unit);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, Tuple2<double, int>>> productRatingUpdate({
    required double productRating,
    required String productId,
  }) async {
    try {
      int ratingNumbers = 0;

      await firebaseInstance.collection("products").doc(productId).update({
        "productRating": productRating,
        "ratingNumbers": FieldValue.increment(1)
      }).then((value) async {
        await firebaseInstance
            .collection("products")
            .doc(productId)
            .get()
            .then((value) {
          ratingNumbers = value.data()!["ratingNumbers"].toInt();
        });
      });

      return Right(Tuple2(productRating, ratingNumbers));
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  /// Gets
  Future<Either<FirebaseException, List<Product>>> getProducts() async {
    try {
      List<Product> products = [];
      final value = await firebaseInstance.collection("products").get();
      for (var element in value.docs) {
        products.add(Product.fromJson(element.data()));
      }
      return Right(products);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, List<Category>>> getCategories() async {
    try {
      List<Category> categories = [];

      final value = await firebaseInstance.collection("categories").get();
      for (var element in value.docs) {
        categories.add(Category.fromJson(element.data()));
      }

      return Right(categories);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, List<String>>> getOffers() async {
    try {
      List<String> offers = [];

      final value =
          await firebaseInstance.collection("offers").doc("offers").get();
      offers = List<String>.from(value.data()!["productsIds"])
          .map((e) => e)
          .toList();

      return Right(offers);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, Map<String, int>>> getBestSales() async {
    try {
      Map<String, dynamic> data = {};

      final value = await firebaseInstance
          .collection("best_sales")
          .doc("best_sales")
          .get();
      data = value.data() as Map<String, dynamic>;

      Map<String, int> bestSales = data.map(
        (key, value) =>
            MapEntry(key.replaceAll("-", "."), value is int ? value : 0),
      );

      return Right(bestSales);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, List<Merchant>>> getMerchants() async {
    try {
      List<Merchant> merchants = [];

      final value = await firebaseInstance.collection("merchants").get();
      for (var element in value.docs) {
        merchants.add(Merchant.fromJson(element.data()));
      }

      return Right(merchants);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, List<Worker>>> getWorkers() async {
    try {
      List<Worker> workers = [];

      final value = await firebaseInstance.collection("workers").get();
      for (var element in value.docs) {
        workers.add(Worker.fromJson(element.data()));
      }

      return Right(workers);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, List<OrderForWorkers>>>
      getOrderForWorkers() async {
    try {
      List<OrderForWorkers> orderForWorkers = [];

      final value =
          await firebaseInstance.collection("orders_for_workers").get();
      for (var element in value.docs) {
        if (element.data().isNotEmpty) {
          if (ConstantsManager.appUser is Worker) {
            if ((ConstantsManager.appUser as Worker)
                .ordersIds
                .contains(element.id)) {
              orderForWorkers.add(OrderForWorkers.fromJson(element.data()));
            }
          } else if (ConstantsManager.appUser is Customer) {
            if (element.data()["customerId"] == ConstantsManager.userId) {
              orderForWorkers.add(OrderForWorkers.fromJson(element.data()));
            }
          }
        }
      }

      return Right(orderForWorkers);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, List<String>>> getBanners() async {
    try {
      List<String> banners = [];

      final value = await firebaseInstance.collection("banners").get();
      for (var element in value.docs) {
        if (element.data().isNotEmpty) {
          banners.add(element.data()["link"]);
        }
      }

      return Right(banners);
    } on FirebaseException catch (error) {
      return Left(error);
    }
  }

  Future<Either<FirebaseException, Unit>> getUserData() async {
    try {
      await firebaseInstance
          .collection("${ConstantsManager.userType}s/")
          .doc("${ConstantsManager.userId}")
          .get()
          .then((value) {
        ConstantsManager.appUser =
            AppUser.fromJson(value.data()!, "${ConstantsManager.userType}");
        ConstantsManager.appUser!.image =
            FirebaseAuth.instance.currentUser!.photoURL;
      });
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(e);
    }
  }

  /// Delete
  Future<Either<FirebaseException, Unit>> deleteProduct({
    required Product product,
  }) async {
    try {
      var batch = firebaseInstance.batch();
      var bestSales =
          firebaseInstance.collection("best_sales").doc("best_sales");
      var offers = firebaseInstance.collection("offers").doc("offers");
      var products =
          firebaseInstance.collection("products").doc(product.productId);
      var categories = firebaseInstance
          .collection("categories")
          .doc(product.productCategory);
      var merchants = firebaseInstance
          .collection("merchants")
          .doc(ConstantsManager.appUser!.id);

      batch.delete(products);
      batch.update(bestSales,
          {product.productId.replaceAll(".", "-"): FieldValue.delete()});
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

  /// private
  Future _setOrderInWorkers({
    required OrderForWorkers orderForWorkers,
    required WriteBatch batch,
  }) async {
    for (String sortedWorker in orderForWorkers.workersIds) {
      var element = firebaseInstance.collection("workers").doc(sortedWorker);
      batch.update(element, {
        "ordersIds": FieldValue.arrayUnion([orderForWorkers.orderId])
      });
      print("Worker  id $sortedWorker");
      await _pushNotification(
        id: sortedWorker,
        work: orderForWorkers.work,
        city: orderForWorkers.city,
      ).then((value) => print("pushed"));
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

  Future<void> _pushNotification({
    required String id,
    required String work,
    required String city,
  }) async {
    await http.post(Uri.parse(ConstantsManager.baseUrlNotification),
        body: jsonEncode({
          "to": "/topics/$id",
          "notification": {
            "body": "مطلوب $work في $city",
            "click_action": "FLUTTER_NOTIFICATION_CLICK"
          }
        }),
        headers: {
          "Authorization": "key=${ConstantsManager.firebaseMessagingAPI}",
          "Content-Type": "application/json"
        });
  }
}
