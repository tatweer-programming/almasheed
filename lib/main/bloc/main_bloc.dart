import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/data/repositories/main_repository.dart';
import 'package:almasheed/main/view/screens/profile_screen.dart';
import 'package:almasheed/main/view/screens/support_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/services/dep_injection.dart';
import '../view/screens/home_page_screen.dart';

part 'main_event.dart';
part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  static MainBloc get(BuildContext context) =>
      BlocProvider.of<MainBloc>(context);

  int pageIndex = 0;
  int carouselIndicatorIndex = 0;
  List<Product> products = [];
  List<Product> offers = [];
  List<Product> bestSales = [];
  List<Category> categories = [];
  Product? selectedProduct;
  List<Widget> pages = [
    const HomePageScreen(),
    const ProfileScreen(),
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
          emit(GetProductsErrorState());
        }, (r) {
          products = r;
          emit(GetProductsSuccessfullyState());
        });
      } else if (event is GetOffersEvent) {
        emit(GetOffersLoadingState());
        var result = await MainRepository(sl()).getOffers();
        result.fold((l) {
          emit(GetOffersErrorState());
        }, (r) {
          List<String> response = r;
          offers = products
              .where((product) => response.contains(product.productId))
              .toList();
          emit(GetOffersSuccessfullyState());
        });
      }else if (event is GetBestSalesEvent) {
        emit(GetBestSalesLoadingState());
        var result = await MainRepository(sl()).getBestSales();
        result.fold((l) {
          emit(GetBestSalesErrorState());
        }, (r) {
          Map<String,int> response = r;
          response = Map.fromEntries(
              response.entries.toList()..sort((e1, e2) => e1.value.compareTo(e2.value)));

          bestSales = products
              .where((product) => response.containsKey(product.productId))
              .toList();
          emit(GetBestSalesSuccessfullyState());
        });
      }else if (event is GetCategoriesEvent) {
        emit(GetCategoriesLoadingState());
        var result = await MainRepository(sl()).getCategories();
        result.fold((l) {
          emit(GetCategoriesErrorState());
        }, (r) {
          categories = r;
          for(Category category in categories){
            category.products = products
                .where((product) => category.productsIds.contains(product.productId))
                .toList();
          }
          emit(GetCategoriesSuccessfullyState());
        });
      }else if (event is SelectProductEvent){
        selectedProduct = event.product;
        emit(SelectProductState());
      }
    });
  }
}
