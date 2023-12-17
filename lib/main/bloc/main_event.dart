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