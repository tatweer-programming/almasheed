part of 'main_bloc.dart';

abstract class MainState extends Equatable {
  const MainState();
}

class MainInitial extends MainState {
  @override
  List<Object> get props => [];
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
  @override
  List<Object?> get props => [];
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
  @override
  List<Object?> get props => [];
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
  @override
  List<Object?> get props => [];
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
  @override
  List<Object?> get props => [];
}

class SelectProductState extends MainState {
  @override
  List<Object?> get props => [];
}
