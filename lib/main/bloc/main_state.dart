part of 'main_bloc.dart';

abstract class MainState {
  const MainState();
}

class MainInitial extends MainState {}

// get product
class GetProductsSuccessfullyState extends MainState {}

class GetProductsLoadingState extends MainState {}

class GetProductsErrorState extends MainState {
  final FirebaseException error;

  const GetProductsErrorState(this.error);
}

// set product
class SetProductSuccessfullyState extends MainState {}

class SetProductLoadingState extends MainState {}

class SetProductErrorState extends MainState {
  final FirebaseException error;

  const SetProductErrorState(this.error);
}

// set OrderForWorkers
class SetOrderForWorkersSuccessfullyState extends MainState {}

class SetOrderForWorkersLoadingState extends MainState {}

class SetOrderForWorkersErrorState extends MainState {
  final FirebaseException error;

  const SetOrderForWorkersErrorState(this.error);
}

// update product
class UpdateProductSuccessfullyState extends MainState {}

class UpdateProductLoadingState extends MainState {}

class UpdateProductErrorState extends MainState {
  final FirebaseException error;

  const UpdateProductErrorState(this.error);
}

class SetCategorySuccessfullyState extends MainState {}

class SetCategoryLoadingState extends MainState {}

class SetCategoryErrorState extends MainState {
  final FirebaseException error;

  const SetCategoryErrorState(this.error);
}

// delete product
class DeleteProductSuccessfullyState extends MainState {}

class DeleteProductLoadingState extends MainState {}

class DeleteProductErrorState extends MainState {
  final FirebaseException error;

  const DeleteProductErrorState(this.error);
}

// get Merchants
class GetMerchantsSuccessfullyState extends MainState {}

class GetMerchantsLoadingState extends MainState {}

class GetMerchantsErrorState extends MainState {
  final FirebaseException error;

  const GetMerchantsErrorState(this.error);
} // get Banners

class GetBannersSuccessfullyState extends MainState {}

class GetBannersLoadingState extends MainState {}

class GetBannersErrorState extends MainState {
  final FirebaseException error;

  const GetBannersErrorState(this.error);
}

// get Workers
class GetWorkersSuccessfullyState extends MainState {}

class GetWorkersLoadingState extends MainState {}

class GetWorkersErrorState extends MainState {
  final FirebaseException error;

  const GetWorkersErrorState(this.error);
}

// get offer
class GetOffersSuccessfullyState extends MainState {}

class GetOffersLoadingState extends MainState {}

class GetOffersErrorState extends MainState {
  final FirebaseException error;

  const GetOffersErrorState(this.error);
}

// get OrderForWorkers
class GetOrderForWorkersSuccessfullyState extends MainState {}

class GetOrderForWorkersLoadingState extends MainState {}

class GetOrderForWorkersErrorState extends MainState {
  final FirebaseException error;

  const GetOrderForWorkersErrorState(this.error);
}

// get category
class GetCategoriesSuccessfullyState extends MainState {}

class GetCategoriesLoadingState extends MainState {}

class GetCategoriesErrorState extends MainState {
  final FirebaseException error;

  const GetCategoriesErrorState(this.error);
}

// get User data
class GetUserDataSuccessfullyState extends MainState {}

class GetUserDataLoadingState extends MainState {}

class IncreaseQuantityState extends MainState {
  final int quantity;
  final int index;

  IncreaseQuantityState({required this.quantity, required this.index});
}

class GetUserDataErrorState extends MainState {
  final FirebaseException error;

  const GetUserDataErrorState(this.error);
}

// Add And Remove From Favorites
class AddAndRemoveFromFavoritesSuccessfullyState extends MainState {}

class AddAndRemoveFromFavoritesLoadingState extends MainState {}

class AddAndRemoveFromFavoritesErrorState extends MainState {
  final FirebaseException error;

  const AddAndRemoveFromFavoritesErrorState(this.error);
}
// Product Rating Update

class ProductRatingUpdateSuccessfullyState extends MainState {
  final Product product;

  ProductRatingUpdateSuccessfullyState(
      {required this.product,});
}

class ProductRatingUpdateErrorState extends MainState {
  final FirebaseException error;

  const ProductRatingUpdateErrorState(this.error);
}

// get best sales
class GetBestSalesSuccessfullyState extends MainState {}

class GetBestSalesLoadingState extends MainState {}

class GetBestSalesErrorState extends MainState {
  final FirebaseException error;

  const GetBestSalesErrorState(this.error);
}

// logic

class SelectProductState extends MainState {
  final Product product;

  SelectProductState(this.product);
}

class SelectProductCategoryState extends MainState {
  final String selectedProductCategory;

  SelectProductCategoryState(this.selectedProductCategory);
}

class SelectWorkState extends MainState {
  final String work;

  SelectWorkState(this.work);
}

class SelectedCityState extends MainState {
  final String selectedCity;
  final List<Product> sortedProducts;

  const SelectedCityState(
      {required this.selectedCity, required this.sortedProducts});
}

class CancelSortProductsState extends MainState {
  final List<Product> products;

  const CancelSortProductsState({required this.products});
}

class SortProductsState extends MainState {
  final List<Product> products;

  const SortProductsState({required this.products});
}

class ChangeBottomNavState extends MainState {
  final int index;

  const ChangeBottomNavState({required this.index});

  List<Object> get props => [index];
}

class ChangeCarouselIndicatorState extends MainState {
  final int index;

  const ChangeCarouselIndicatorState({required this.index});

  List<Object> get props => [index];
}

class PickImageState extends MainState {
  final List<XFile> imagesFiles;

  const PickImageState({required this.imagesFiles});

  List<Object> get props => [imagesFiles];
}

class RemovePickedImageState extends MainState {
  final List<XFile> imagesFiles;

  const RemovePickedImageState({required this.imagesFiles});

  List<Object> get props => [imagesFiles];
}

class AddImageUrlDeletedState extends MainState {}

class RemoveImageState extends MainState {}

class MakeImagesFilesEmptyState extends MainState {
  final List<XFile> imagesFiles;

  const MakeImagesFilesEmptyState(this.imagesFiles);

  List<Object> get props => [imagesFiles];
}

class SelectDeleteProductState extends MainState {
  final Product product;

  const SelectDeleteProductState(this.product);

  List<Object> get props => [product];
}

class SelectEditProductState extends MainState {
  final Product product;

  const SelectEditProductState(this.product);

  List<Object> get props => [product];
}

class SelectAddProductState extends MainState {}

class SelectAddCategoryState extends MainState {}

class ChangeLocaleState extends MainState {
  final int index;

  const ChangeLocaleState(this.index);
}

class ChangeSwitchNotificationsState extends MainState {
  final bool isOn;

  const ChangeSwitchNotificationsState(this.isOn);
}

class ChooseCategoryState extends MainState {
  final List<Product> categoryProducts;
  final String categoryName;

  const ChooseCategoryState(
      {required this.categoryName, required this.categoryProducts});
}

class MerchantProductsState extends MainState {
  const MerchantProductsState();
}

class CheckIfAvailablePropertiesState extends MainState {
  final List<String> availableProperties;

  const CheckIfAvailablePropertiesState({required this.availableProperties});
}

class SelectPropertiesState extends MainState {
  final List<String> selectedProperties;

  const SelectPropertiesState({required this.selectedProperties});
}

class RemovePropertyNameState extends MainState {}

class RemovePropertyState extends MainState {}

class AddPropertyNameState extends MainState {}

class AddPropertyState extends MainState {}

class SelectedPropertiesSavedState extends MainState {
  final List<String> selectedProperties;

  SelectedPropertiesSavedState(this.selectedProperties);
}

class RemoveSelectedPropertiesSavedState extends MainState {}

class FinishedAddPropertiesState extends MainState {
  final Map<String, List<String>> result;

  const FinishedAddPropertiesState(this.result);
}

class ChangeShowingProductsState extends MainState {
  final bool isHorizontal;

  const ChangeShowingProductsState({required this.isHorizontal});
}

class GetMyCurrentLocationState extends MainState {}

class OnMapCreatedState extends MainState {}

class GetLocationState extends MainState {}

class GetLocationLoadingState extends MainState {}

class GetNameOfLocationState extends MainState {
  final String location;

  GetNameOfLocationState(this.location);
}
