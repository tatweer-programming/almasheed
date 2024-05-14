import 'dart:async';
import 'dart:math';

import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/localization_manager.dart';
import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/order_for_workers.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/data/repositories/main_repository.dart';
import 'package:almasheed/authentication/presentation/screens/profile_screen.dart';
import 'package:almasheed/main/view/screens/support/support_screen.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:multi_dropdown/models/value_item.dart';
import '../../authentication/data/models/merchant.dart';
import '../../authentication/data/models/worker.dart';
import '../../core/services/dep_injection.dart';
import '../view/screens/categories/categories_screen.dart';
import '../view/screens/favourite/favourite_screen.dart';
import '../view/screens/main/home_page_screen.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  static MainBloc get(BuildContext context) =>
      BlocProvider.of<MainBloc>(context);

  int pageIndex = 0;
  int carouselIndicatorIndex = 0;
  List<Product> products = [];
  List<Product> merchantProducts = [];
  Set<Product> lastSeenProducts = {};
  List<Merchant> merchants = [];
  List<Worker> workers = [];
  List<OrderForWorkers> ordersForWorkers = [];
  List<String> banners = [];
  List<Product> offers = [];
  List<Product> bestSales = [];
  List<Category> merchantCategories = [];
  List<Category> categories = [];
  List<XFile> imagesFiles = [];
  List<Product> sortedProducts = [];
  List<String> selectedProperties = [];
  List<Widget> pagesCustomer = [
    const HomePageScreen(),
    const CategoriesScreen(),
    const FavouriteScreen(),
    const ProfileScreen(),
    const SupportScreen(),
  ];
  List<Widget> pagesMerchant = [
    const HomePageScreen(),
    const CategoriesScreen(),
    const ProfileScreen(),
    const SupportScreen(),
  ];
  List<Widget> pagesWorker = [
    const HomePageScreen(),
    const ProfileScreen(),
    const SupportScreen(),
  ];

  /// maps
  Completer<GoogleMapController> controller = Completer<GoogleMapController>();
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  LatLng? latLng;

  MainBloc(MainInitial mainInitial) : super(MainInitial()) {
    on<MainEvent>((event, emit) async {
      if (event is ChangeBottomNavEvent) {
        pageIndex = event.index;
        emit(ChangeBottomNavState(index: pageIndex));
      } else if (event is ChangeCarouselIndicatorEvent) {
        carouselIndicatorIndex = event.index;
        emit(ChangeCarouselIndicatorState(index: carouselIndicatorIndex));
      } else if (event is GetProductsEvent) {
        emit(GetProductsLoadingState());
        var result = await MainRepository(sl()).getProducts();
        result.fold((l) {
          emit(GetProductsErrorState(l));
        }, (r) {
          products = r;
          products.sort((a, b) => DateTime.parse(a.productId)
              .compareTo(DateTime.parse(b.productId)));
          emit(GetProductsSuccessfullyState());
        });
      } else if (event is SetProductEvent) {
        emit(SetProductLoadingState());
        var result =
            await MainRepository(sl()).setProduct(product: event.product);
        result.fold((l) {
          emit(SetProductErrorState(l));
        }, (r) {
          emit(SetProductSuccessfullyState());
          (ConstantsManager.appUser as Merchant)
              .productsIds.add(event.product.productId);
          categories.firstWhere((element) => element.categoryName == event.product.productCategory).products!.add(event.product);
          add(MerchantProductsEvent());
        });
      } else if (event is SetOrderForWorkersEvent) {
        emit(SetOrderForWorkersLoadingState());
        Map<String, LatLng> sortedWorkersWhomSentOrder = _sortPointsByDistance(
          LatLng(
              event.orderForWorkers.latitude, event.orderForWorkers.longitude),
          event.orderForWorkers.work,
        );
        event.orderForWorkers.workersIds =
            sortedWorkersWhomSentOrder.keys.toList().take(5).toList();
        var result = await MainRepository(sl())
            .setOrderForWorkers(orderForWorkers: event.orderForWorkers);
        result.fold((l) {
          emit(SetOrderForWorkersErrorState(l));
        }, (r) {
          emit(SetOrderForWorkersSuccessfullyState());
        });
      } else if (event is UpdateProductEvent) {
        emit(UpdateProductLoadingState());
        var result =
            await MainRepository(sl()).updateProduct(product: event.product);
        result.fold((l) {
          emit(UpdateProductErrorState(l));
        }, (r) {
          emit(UpdateProductSuccessfullyState());
        });
      } else if (event is SetCategoryEvent) {
        emit(SetCategoryLoadingState());
        var result =
            await MainRepository(sl()).setCategory(category: event.category);
        result.fold((l) {
          emit(SetCategoryErrorState(l));
        }, (r) {
          emit(SetCategorySuccessfullyState());
        });
      } else if (event is DeleteProductEvent) {
        emit(DeleteProductLoadingState());
        var result =
            await MainRepository(sl()).deleteProduct(product: event.product);
        result.fold((l) {
          emit(DeleteProductErrorState(l));
        }, (r) {
          (ConstantsManager.appUser as Merchant)
              .productsIds.remove(event.product.productId);
          add(MerchantProductsEvent());
          emit(DeleteProductSuccessfullyState());
        });
      } else if (event is GetMerchantsEvent) {
        emit(GetMerchantsLoadingState());
        var result = await MainRepository(sl()).getMerchants();
        result.fold((l) {
          emit(GetMerchantsErrorState(l));
        }, (r) {
          merchants = r;
          emit(GetMerchantsSuccessfullyState());
        });
      } else if (event is GetBannersEvent) {
        emit(GetBannersLoadingState());
        var result = await MainRepository(sl()).getBanners();
        result.fold((l) {
          emit(GetBannersErrorState(l));
        }, (r) {
          banners = r;
          emit(GetBannersSuccessfullyState());
        });
      } else if (event is GetWorkersEvent) {
        emit(GetWorkersLoadingState());
        var result = await MainRepository(sl()).getWorkers();
        result.fold((l) {
          emit(GetWorkersErrorState(l));
        }, (r) {
          workers = r;
          emit(GetWorkersSuccessfullyState());
        });
      } else if (event is GetOrderForWorkersEvent) {
        emit(GetOrderForWorkersLoadingState());
        var result = await MainRepository(sl()).getOrderForWorkers();
        result.fold((l) {
          emit(GetOrderForWorkersErrorState(l));
        }, (r) {
          ordersForWorkers = r;
          emit(GetOrderForWorkersSuccessfullyState());
        });
      } else if (event is GetOffersEvent) {
        emit(GetOffersLoadingState());
        var result = await MainRepository(sl()).getOffers();
        result.fold((l) {
          emit(GetOffersErrorState(l));
        }, (r) {
          List<String> response = r;
          offers = products
              .where((product) => response.contains(product.productId))
              .toList();
          emit(GetOffersSuccessfullyState());
        });
      } else if (event is GetBestSalesEvent) {
        emit(GetBestSalesLoadingState());
        var result = await MainRepository(sl()).getBestSales();
        result.fold((l) {
          emit(GetBestSalesErrorState(l));
        }, (r) {
          Map<String, int> response = r;
          response = Map.fromEntries(response.entries.toList()
            ..sort((e1, e2) => e1.value.compareTo(e2.value)));
          bestSales = products
              .where((product) => response.containsKey(product.productId))
              .toList();
          emit(GetBestSalesSuccessfullyState());
        });
      } else if (event is GetCategoriesEvent) {
        emit(GetCategoriesLoadingState());
        var result = await MainRepository(sl()).getCategories();
        result.fold((l) {
          emit(GetCategoriesErrorState(l));
        }, (r) {
          categories = r;
          for (Category category in categories) {
            category.products = products
                .where((product) =>
                    category.productsIds.contains(product.productId))
                .toList();
          }
          emit(GetCategoriesSuccessfullyState());
        });
      } else if (event is AddAndRemoveFromFavoritesEvent) {
        emit(AddAndRemoveFromFavoritesLoadingState());
        List<String> favorites = getFavorites(
            productId: event.productId, favorites: event.favorites);
        var result = await MainRepository(sl())
            .addAndRemoveFromFavorites(favorites: favorites);
        result.fold((l) {
          emit(AddAndRemoveFromFavoritesErrorState(l));
        }, (r) {
          emit(AddAndRemoveFromFavoritesSuccessfullyState());
        });
      } else if (event is ProductRatingUpdateEvent) {
        var result = await MainRepository(sl()).productRatingUpdate(
            productRating: event.productRating, productId: event.productId);
        result.fold((l) {
          emit(ProductRatingUpdateErrorState(l));
        }, (r) {
          emit(ProductRatingUpdateSuccessfullyState(
              rating: r.value1, numbers: r.value2));
        });
      } else if (event is SelectProductEvent) {
        emit(SelectProductState(event.product));
      } else if (event is SelectProductCategoryEvent) {
        emit(SelectProductCategoryState(event.selectedProductCategory));
      } else if (event is SelectWorkEvent) {
        emit(SelectWorkState(event.selectedWork));
      } else if (event is SelectCityEvent) {
        sortedProducts = sortedProducts
            .where((product) => product.productCity == event.selectedCity)
            .toList();
        emit(SelectedCityState(
            selectedCity: event.selectedCity, sortedProducts: sortedProducts));
      } else if (event is CancelSortProductsEvent) {
        sortedProducts = event.products;
        emit(CancelSortProductsState(
          products: event.products,
        ));
      } else if (event is SortProductsEvent) {
        if (event.type == "Alphabet") {
          sortedProducts.sort((product1, product2) =>
              product1.productName.compareTo(product2.productName));
        } else if (event.type == "Lowest to highest price") {
          sortedProducts.sort((product1, product2) =>
              product1.productOldPrice.compareTo(product2.productOldPrice));
        } else if (event.type == "Highest to lowest price") {
          sortedProducts.sort((product1, product2) =>
              product2.productOldPrice.compareTo(product1.productOldPrice));
        } else if (event.type == "Best Sales") {
          sortedProducts = event.products
              .where((product) =>
                  bestSales.map((e) => e.productId).contains(product.productId))
              .toList();
        } else if (event.type == "Offers") {
          sortedProducts = event.products
              .where((product) =>
                  offers.map((e) => e.productId).contains(product.productId))
              .toList();
        }
        emit(SortProductsState(products: sortedProducts));
      } else if (event is PickImagesEvent) {
        final pickedFile = await ImagePicker().pickMultiImage();
        if (pickedFile.isNotEmpty) {
          imagesFiles = imagesFiles + pickedFile;
        }
        emit(PickImageState(imagesFiles: imagesFiles));
      } else if (event is RemovePickedImageEvent) {
        emit(RemoveImageState());
        imagesFiles.remove(event.image);
        emit(RemovePickedImageState(imagesFiles: imagesFiles));
      } else if (event is RemoveImageEvent) {
        emit(AddImageUrlDeletedState());
        event.imagesUrlDelete.add(event.image);
        event.imagesUrl.remove(event.image);
        emit(RemoveImageState());
      } else if (event is MakeImagesFilesEmptyEvent) {
        imagesFiles = [];
        emit(MakeImagesFilesEmptyState(imagesFiles));
      } else if (event is SelectEditOrDeleteProductEvent) {
        if (event.selected == "Edit") {
          emit(SelectEditProductState(event.product));
        } else {
          sortedProducts.remove(event.product);
          products.remove(event.product);
          emit(SelectDeleteProductState(event.product));
        }
      } else if (event is SelectAddProductOrAddCategoryEvent) {
        if (event.selected == "AddProduct") {
          emit(SelectAddProductState());
        } else {
          emit(SelectAddCategoryState());
        }
      } else if (event is IncreaseQuantityEvent) {
        event.quantity++;
        emit(IncreaseQuantityState(
            quantity: event.quantity, index: event.index));
      } else if (event is GetUserDataEvent) {
        emit(GetUserDataLoadingState());
        var response = await MainRepository(sl()).getUserData();
        response.fold((l) {
          emit(GetUserDataErrorState(l));
        }, (r) {
          emit(GetUserDataSuccessfullyState());
        });
      } else if (event is ChangeShowingProductsEvent) {
        event.isHorizontal = !event.isHorizontal;
        emit(ChangeShowingProductsState(isHorizontal: event.isHorizontal));
      } else if (event is ChangeLocaleEvent) {
        await LocalizationManager.setLocale(event.index);
        emit(ChangeLocaleState(event.index));
      } else if (event is ChangeSwitchNotificationsEvent) {
        emit(ChangeSwitchNotificationsState(event.isOn));
      } else if (event is ChooseCategoryEvent) {
        if (ConstantsManager.appUser is Merchant) {
          event.categoryProducts = event.categoryProducts
              .where((product) => (ConstantsManager.appUser as Merchant)
                  .productsIds
                  .contains(product.productId))
              .toList();
        }
        emit(ChooseCategoryState(
            categoryName: event.categoryName,
            categoryProducts: event.categoryProducts));
      } else if (event is MerchantProductsEvent) {
        if (ConstantsManager.appUser is Merchant) {
          List<Product> products = [];
          merchantCategories = [];
          merchantProducts = [];
          for (Category category in categories) {
            products = [];
            if (category.products != null && category.products!.isNotEmpty) {
              products = category.products!
                  .where((product) => (ConstantsManager.appUser as Merchant)
                      .productsIds
                      .contains(product.productId))
                  .toList();
            }
            merchantProducts.addAll(products);
            merchantCategories.add(Category(
                categoryName: category.categoryName,
                productsIds: const [],
                categoryImage: category.categoryImage,
                products: products));
          }
        }
        emit(const MerchantProductsState());
      } else if (event is CheckIfAvailablePropertiesEvent) {
        List<String> availableProperties = event.product.customProperties!
            .searchInAvailablePropsFromChosenProps(event.selectedProperties);
        emit(CheckIfAvailablePropertiesState(
            availableProperties: availableProperties));
      } else if (event is SelectPropertiesEvent) {
        bool flag = false;
        for (String p in event.properties) {
          if (event.selectedProperties.contains(p)) {
            event.selectedProperties.remove(p);
            event.selectedProperties.add(event.prop);
            flag = true;
            break;
          }
        }
        if (!flag) {
          event.selectedProperties.add(event.prop);
        }
        emit(SelectPropertiesState(
            selectedProperties: event.selectedProperties));
      } else if (event is AddPropertyNameEvent) {
        event.propertyNameList.add(TextEditingController());
        event.propertyList.add([TextEditingController()]);
        emit(AddPropertyNameState());
      } else if (event is RemovePropertyNameEvent) {
        event.propertyNameList.remove(event.propertyNameList[event.index]);
        event.propertyList.remove(event.propertyList[event.index]);
        emit(RemovePropertyNameState());
      } else if (event is AddPropertyEvent) {
        event.propertyList.add(TextEditingController());
        emit(AddPropertyState());
      } else if (event is RemovePropertyEvent) {
        event.propertyList.remove(event.propertyList[event.index]);
        emit(RemovePropertyState());
      } else if (event is FinishedAddPropertiesEvent) {
        emit(FinishedAddPropertiesState(
            convertToMap(event.propertyList, event.propertyNameList)));
      } else if (event is SelectedPropertiesSavedEvent) {
        event.selectedPropertiesSaved.add(event.selectedProperties);
        event.selectedProperties = [];
        emit(SelectedPropertiesSavedState(event.selectedProperties));
      } else if (event is RemoveSelectedPropertiesSavedEvent) {
        event.selectedPropertiesSaved
            .remove(event.selectedPropertiesSaved[event.index]);
        emit(RemoveSelectedPropertiesSavedState());
      } else if (event is GetMyCurrentLocationEvent) {
        emit(GetLocationLoadingState());
        await _myCurrentLocation().then((value) {
          add(GetLocationEvent(tappedPoint: latLng!));
        });
        emit(GetMyCurrentLocationState());
      } else if (event is OnMapCreatedEvent) {
        if (!controller.isCompleted) {
          controller.complete(event.controller);
          mapController = event.controller;
        }
        emit(OnMapCreatedState());
      } else if (event is GetLocationEvent) {
        markers.clear();
        addMarker(event.tappedPoint, event.tappedPoint.latitude.toString());
        latLng =
            LatLng(event.tappedPoint.latitude, event.tappedPoint.longitude);
        mapController!.animateCamera(CameraUpdate.newLatLng(event.tappedPoint));
        emit(GetLocationState());
      } else if (event is GetNameOfLocationEvent) {
        emit(GetNameOfLocationState(event.locationName));
      }
    });
  }

  Future<void> _myCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationData = await location.getLocation();
    final GoogleMapController googleMapController = await controller.future;
    CameraPosition myLocation = CameraPosition(
      target: LatLng(locationData.latitude ?? 24.774265,
          locationData.longitude ?? 46.738586),
      zoom: 14.4746,
    );
    latLng = LatLng(locationData.latitude ?? 24.774265,
        locationData.longitude ?? 46.738586);
    await googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(myLocation));
  }

  void addMarker(LatLng position, String markerId) {
    final marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: markerId),
    );
    markers.add(marker);
  }

  double _calculateDistance(
    LatLng position1,
    LatLng position2,
  ) {
    double x1 = position1.latitude, y1 = position1.latitude;
    double x2 = position2.latitude, y2 = position2.latitude;
    return sqrt(pow(x2 - x1, 2) + pow(y2 - y1, 2));
  }

  Map<String, LatLng> _sortPointsByDistance(LatLng targetPoint, String work) {
    ValueItem<String> workConverted;
    workConverted = LocalizationManager.getCurrentLocale().languageCode == "ar"
        ? ConstantsManager.convertWorkToArabic(
            ValueItem(label: work, value: work))
        : ConstantsManager.convertWorkToEnglish(
            ValueItem(label: work, value: work));

    Map<String, LatLng> pointMap = _getPointMap(workConverted.label);
    List<MapEntry<String, LatLng>> entries = pointMap.entries.toList();
    entries.sort((a, b) {
      double distanceA = _calculateDistance(targetPoint, a.value);
      double distanceB = _calculateDistance(targetPoint, b.value);
      return distanceA.compareTo(distanceB);
    });

    return Map.fromEntries(entries);
  }

  Map<String, LatLng> _getPointMap(String work) {
    Map<String, LatLng> pointMap = {};
    for (var element in workers) {
      if (element.works.contains(work)) {
        pointMap[element.id] = LatLng(element.latitude, element.longitude);
      }
    }
    return pointMap;
  }

  List<String> getFavorites({
    required String productId,
    required List<String> favorites,
  }) {
    if (favorites.contains(productId)) {
      favorites.remove(productId);
    } else {
      favorites.add(productId);
    }
    return favorites;
  }
}
