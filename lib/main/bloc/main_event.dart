part of 'main_bloc.dart';

abstract class MainEvent extends Equatable {
  const MainEvent();
}

class ChangeBottomNavEvent extends MainEvent {
  final int index;
  const ChangeBottomNavEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class ChangeCarouselIndicatorEvent extends MainEvent {
  final int index;
  const ChangeCarouselIndicatorEvent({required this.index});
  @override
  List<Object?> get props => [index];
}

class GetProductsEvent extends MainEvent {
  @override
  List<Object?> get props => [];
}

class SetProductEvent extends MainEvent {
  final Product product;
  const SetProductEvent({required this.product});
  @override
  List<Object?> get props => [product];
}

class UpdateProductEvent extends MainEvent {
  final Product product;
  const UpdateProductEvent({required this.product});
  @override
  List<Object?> get props => [product];
}

class DeleteProductEvent extends MainEvent {
  final Product product;
  const DeleteProductEvent({required this.product});
  @override
  List<Object?> get props => [product];
}

class GetMerchantsEvent extends MainEvent {
  @override
  List<Object?> get props => [];
}

class GetCategoriesEvent extends MainEvent {
  @override
  List<Object?> get props => [];
}

class GetOffersEvent extends MainEvent {
  @override
  List<Object?> get props => [];
}

class GetBestSalesEvent extends MainEvent {
  @override
  List<Object?> get props => [];
}

class SelectProductEvent extends MainEvent {
  final Product product;
  const SelectProductEvent({required this.product});
  @override
  List<Object?> get props => [product];
}

class SelectCityEvent extends MainEvent {
  final String selectedCity;
  const SelectCityEvent({required this.selectedCity});
  @override
  List<Object?> get props => [selectedCity];
}

class CancelSortProductsEvent extends MainEvent {
  final List<Product> products;
  const CancelSortProductsEvent({required this.products});
  @override
  List<Object?> get props => [products];
}

class SortProductsEvent extends MainEvent {
  final String type;
  final List<Product> products;
  const SortProductsEvent({required this.type,required this.products});
  @override
  List<Object?> get props => [type,products];
}

class PickImagesEvent extends MainEvent {
  @override
  List<Object?> get props => [];
}

class RemovePickedImageEvent extends MainEvent {
  final XFile image;
  const RemovePickedImageEvent({required this.image});
  @override
  List<Object?> get props => [image];
}

class RemoveImageEvent extends MainEvent {
  final String image;
  final List<String> imagesUrlDelete;
  final List<String> imagesUrl;
  const RemoveImageEvent({required this.image,required this.imagesUrlDelete,required this.imagesUrl});
  @override
  List<Object?> get props => [image,imagesUrl,imagesUrlDelete];
}
