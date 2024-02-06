import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/localization_manager.dart';
import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/data/repositories/main_repository.dart';
import 'package:almasheed/authentication/presentation/screens/profile_screen.dart';
import 'package:almasheed/main/view/screens/support_screen.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../authentication/data/models/merchant.dart';
import '../../core/services/dep_injection.dart';
import '../view/screens/categories_screen.dart';
import '../view/screens/favourite_screen.dart';
import '../view/screens/home_page_screen.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  static MainBloc get(BuildContext context) =>
      BlocProvider.of<MainBloc>(context);

  int pageIndex = 0;
  int carouselIndicatorIndex = 0;
  List<Product> products = [];
  List<Merchant> merchants = [];
  List<Product> offers = [];
  List<Product> bestSales = [];
  List<Category> categories = [];
  List<XFile> imagesFiles = [];
  Product? selectedProduct;
  String? selectedProductCategory;
  String? selectedCity;
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
    const SupportScreen(),
  ];

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
        });
      } else if (event is UpdateProductEvent) {
        emit(UpdateProductLoadingState());
        var result =
            await MainRepository(sl()).modifyProduct(product: event.product);
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
      } else if (event is SelectProductEvent) {
        selectedProduct = event.product;
        emit(SelectProductState());
      } else if (event is SelectProductCategoryEvent) {
        selectedProductCategory = event.selectedProductCategory;
        emit(SelectProductCategoryState());
      } else if (event is SelectCityEvent) {
        selectedCity = event.selectedCity;
        sortedProducts = sortedProducts
            .where((product) => product.productCity == event.selectedCity)
            .toList();
        emit(SelectedCityState(
            selectedCity: event.selectedCity, sortedProducts: sortedProducts));
      } else if (event is CancelSortProductsEvent) {
        sortedProducts = event.products;
        selectedCity = null;
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
      }else if (event is AddPropertyEvent) {
        event.propertyList.add(TextEditingController());
        emit(AddPropertyState());
      } else if (event is RemovePropertyEvent) {
        event.propertyList.remove(event.propertyList[event.index]);
        emit(RemovePropertyState());
      } else if (event is FinishedAddPropertiesEvent) {

        emit(FinishedAddPropertiesState(convertToMap(event.propertyList, event.propertyNameList)));
      }else if (event is SelectedPropertiesSavedEvent) {
        event.selectedPropertiesSaved.add(event.selectedProperties);
        event.selectedProperties=[];
        emit(SelectedPropertiesSavedState(event.selectedProperties));
      }else if (event is RemoveSelectedPropertiesSavedEvent) {
        event.selectedPropertiesSaved.remove(event.selectedPropertiesSaved[event.index]);
        emit(RemoveSelectedPropertiesSavedState());
      }
    });
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
