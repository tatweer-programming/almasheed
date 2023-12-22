part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  const MainState();
}

class MainInitial extends MainState {
  @override
  List<Object> get props => [];
}

// get product
class GetProductsSuccessfullyState extends MainState {
  @override
  List<Object?> get props => [];
}

class GetProductsLoadingState extends MainState {
  @override
  List<Object?> get props => [];
}

class GetProductsErrorState extends MainState {
  final FirebaseException error;

  const GetProductsErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

// set product
class SetProductSuccessfullyState extends MainState {
  @override
  List<Object?> get props => [];
}

class SetProductLoadingState extends MainState {
  @override
  List<Object?> get props => [];
}

class SetProductErrorState extends MainState {
  final FirebaseException error;

  const SetProductErrorState(this.error);

  @override
  List<Object?> get props => [error];
}


// update product
class UpdateProductSuccessfullyState extends MainState {
  @override
  List<Object?> get props => [];
}

class UpdateProductLoadingState extends MainState {
  @override
  List<Object?> get props => [];
}

class UpdateProductErrorState extends MainState {
  final FirebaseException error;

  const UpdateProductErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

class SetCategorySuccessfullyState extends MainState {
  @override
  List<Object?> get props => [];
}

class SetCategoryLoadingState extends MainState {
  @override
  List<Object?> get props => [];
}

class SetCategoryErrorState extends MainState {
  final FirebaseException error;

  const SetCategoryErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

// delete product
class DeleteProductSuccessfullyState extends MainState {
  @override
  List<Object?> get props => [];
}

class DeleteProductLoadingState extends MainState {
  @override
  List<Object?> get props => [];
}

class DeleteProductErrorState extends MainState {
  final FirebaseException error;

  const DeleteProductErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

// get Merchants
class GetMerchantsSuccessfullyState extends MainState {
  @override
  List<Object?> get props => [];
}

class GetMerchantsLoadingState extends MainState {
  @override
  List<Object?> get props => [];
}

class GetMerchantsErrorState extends MainState {
  final FirebaseException error;

  const GetMerchantsErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

// get offer
class GetOffersSuccessfullyState extends MainState {
  @override
  List<Object?> get props => [];
}

class GetOffersLoadingState extends MainState {
  @override
  List<Object?> get props => [];
}

class GetOffersErrorState extends MainState {
  final FirebaseException error;

  const GetOffersErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

// get category
class GetCategoriesSuccessfullyState extends MainState {
  @override
  List<Object?> get props => [];
}

class GetCategoriesLoadingState extends MainState {
  @override
  List<Object?> get props => [];
}

class GetCategoriesErrorState extends MainState {
  final FirebaseException error;

  const GetCategoriesErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

// get User data
class GetUserDataSuccessfullyState extends MainState {
  @override
  List<Object?> get props => [];
}

class GetUserDataLoadingState extends MainState {
  @override
  List<Object?> get props => [];
}

class GetUserDataErrorState extends MainState {
  final FirebaseException error;

  const GetUserDataErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
// Add And Remove From Favorites
class AddAndRemoveFromFavoritesSuccessfullyState extends MainState {
  @override
  List<Object?> get props => [];
}

class AddAndRemoveFromFavoritesLoadingState extends MainState {
  @override
  List<Object?> get props => [];
}

class AddAndRemoveFromFavoritesErrorState extends MainState {
  final FirebaseException error;

  const AddAndRemoveFromFavoritesErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

// get best sales
class GetBestSalesSuccessfullyState extends MainState {
  @override
  List<Object?> get props => [];
}

class GetBestSalesLoadingState extends MainState {
  @override
  List<Object?> get props => [];
}

class GetBestSalesErrorState extends MainState {
  final FirebaseException error;

  const GetBestSalesErrorState(this.error);

  @override
  List<Object?> get props => [error];
}

// logic

class SelectProductState extends MainState {
  @override
  List<Object?> get props => [];
}

class SelectProductCategoryState extends MainState {
  @override
  List<Object?> get props => [];
}

class SelectedCityState extends MainState {
  final String selectedCity;
  final List<Product> sortedProducts;

  const SelectedCityState(
      {required this.selectedCity, required this.sortedProducts});

  @override
  List<Object?> get props => [selectedCity, sortedProducts];
}

class CancelSortProductsState extends MainState {
  final List<Product> products;

  const CancelSortProductsState({required this.products});

  @override
  List<Object?> get props => [products];
}

class SortProductsState extends MainState {
  final List<Product> products;

  const SortProductsState({required this.products});

  @override
  List<Object?> get props => [products];
}

class ChangeBottomNavState extends MainState {
  final int index;

  const ChangeBottomNavState({required this.index});

  @override
  List<Object> get props => [index];
}

class ChangeCarouselIndicatorState extends MainState {
  final int index;

  const ChangeCarouselIndicatorState({required this.index});

  @override
  List<Object> get props => [index];
}

class PickImageState extends MainState {
  final List<XFile> imagesFiles;

  const PickImageState({required this.imagesFiles});

  @override
  List<Object> get props => [imagesFiles];
}

class RemovePickedImageState extends MainState {
  final List<XFile> imagesFiles;

  const RemovePickedImageState({required this.imagesFiles});

  @override
  List<Object> get props => [imagesFiles];
}

class AddImageUrlDeletedState extends MainState {
  @override
  List<Object> get props => [];
}

class RemoveImageState extends MainState {
  @override
  List<Object> get props => [];
}

class MakeImagesFilesEmptyState extends MainState {
  final List<XFile> imagesFiles;

  const MakeImagesFilesEmptyState(this.imagesFiles);

  @override
  List<Object> get props => [imagesFiles];
}

class SelectDeleteProductState extends MainState {
  final Product product;

  const SelectDeleteProductState(this.product);

  @override
  List<Object> get props => [product];
}

class SelectEditProductState extends MainState {
  final Product product;

  const SelectEditProductState(this.product);

  @override
  List<Object> get props => [product];
}