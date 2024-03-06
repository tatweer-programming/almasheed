part of 'main_bloc.dart';

abstract class MainEvent {
  const MainEvent();
}

class ChangeBottomNavEvent extends MainEvent {
  final int index;

  const ChangeBottomNavEvent({required this.index});
}

class SelectedPropertiesSavedEvent extends MainEvent {
  List<String> selectedProperties;
  final List<List<String>> selectedPropertiesSaved;

  SelectedPropertiesSavedEvent(
      {required this.selectedProperties,
      required this.selectedPropertiesSaved});
}

class RemoveSelectedPropertiesSavedEvent extends MainEvent {
  final List<List<String>> selectedPropertiesSaved;
  final int index;

  RemoveSelectedPropertiesSavedEvent(
      {required this.selectedPropertiesSaved, required this.index});
}

class ChangeShowingProductsEvent extends MainEvent {
  bool isHorizontal;

  ChangeShowingProductsEvent({required this.isHorizontal});
}

class ChangeCarouselIndicatorEvent extends MainEvent {
  final int index;

  const ChangeCarouselIndicatorEvent({required this.index});
}

class GetProductsEvent extends MainEvent {}

class GetOrderForWorkersEvent extends MainEvent {}

class GetMyCurrentLocationEvent extends MainEvent {}

class GetNameOfLocationEvent extends MainEvent {
  final String locationName;

  GetNameOfLocationEvent(this.locationName);
}

class GetLocationEvent extends MainEvent {
  final LatLng tappedPoint;

  GetLocationEvent({required this.tappedPoint});
}

class OnMapCreatedEvent extends MainEvent {
  final GoogleMapController controller;

  OnMapCreatedEvent({required this.controller});
}

class SetProductEvent extends MainEvent {
  final Product product;

  const SetProductEvent({required this.product});
}

class SetOrderForWorkersEvent extends MainEvent {
  final OrderForWorkers orderForWorkers;

  const SetOrderForWorkersEvent({required this.orderForWorkers});
}

class IncreaseQuantityEvent extends MainEvent {
  int quantity;
  final int index;

  IncreaseQuantityEvent({required this.quantity, required this.index});
}

class UpdateProductEvent extends MainEvent {
  final Product product;

  const UpdateProductEvent({required this.product});
}

class ProductRatingUpdateEvent extends MainEvent {
  final double productRating;
  final String productId;

  const ProductRatingUpdateEvent(
      {required this.productRating, required this.productId});
}

class SetCategoryEvent extends MainEvent {
  final Category category;

  const SetCategoryEvent({required this.category});
}

class DeleteProductEvent extends MainEvent {
  final Product product;

  const DeleteProductEvent({required this.product});
}

class GetMerchantsEvent extends MainEvent {}

class GetBannersEvent extends MainEvent {}

class GetWorkersEvent extends MainEvent {}

class GetUserDataEvent extends MainEvent {}

class GetCategoriesEvent extends MainEvent {}

class AddAndRemoveFromFavoritesEvent extends MainEvent {
  final List<String> favorites;
  final String productId;

  const AddAndRemoveFromFavoritesEvent(
      {required this.favorites, required this.productId});
}

class GetOffersEvent extends MainEvent {}

class GetBestSalesEvent extends MainEvent {}

class SelectProductEvent extends MainEvent {
  final Product product;

  const SelectProductEvent({required this.product});
}

class SelectCityEvent extends MainEvent {
  final String selectedCity;

  const SelectCityEvent({required this.selectedCity});
}

class SelectEditOrDeleteProductEvent extends MainEvent {
  final String selected;
  final BuildContext context;
  final Product product;

  const SelectEditOrDeleteProductEvent(
      {required this.selected, required this.product, required this.context});
}

class SelectAddProductOrAddCategoryEvent extends MainEvent {
  final String selected;

  const SelectAddProductOrAddCategoryEvent({
    required this.selected,
  });
}

class SelectProductCategoryEvent extends MainEvent {
  final String selectedProductCategory;

  const SelectProductCategoryEvent({required this.selectedProductCategory});
}

class SelectWorkEvent extends MainEvent {
  final String selectedWork;

  const SelectWorkEvent({required this.selectedWork});
}

class CancelSortProductsEvent extends MainEvent {
  final List<Product> products;

  const CancelSortProductsEvent({required this.products});
}

class SortProductsEvent extends MainEvent {
  final String type;
  final List<Product> products;

  const SortProductsEvent({required this.type, required this.products});
}

class PickImagesEvent extends MainEvent {}

class MakeImagesFilesEmptyEvent extends MainEvent {}

class RemovePickedImageEvent extends MainEvent {
  final XFile image;

  const RemovePickedImageEvent({required this.image});
}

class RemoveImageEvent extends MainEvent {
  final String image;
  final List<String> imagesUrlDelete;
  final List<String> imagesUrl;

  const RemoveImageEvent(
      {required this.image,
      required this.imagesUrlDelete,
      required this.imagesUrl});
}

class ChangeLocaleEvent extends MainEvent {
  final int index;

  const ChangeLocaleEvent(this.index);
}

class ChangeSwitchNotificationsEvent extends MainEvent {
  final bool isOn;

  const ChangeSwitchNotificationsEvent(this.isOn);
}

class CheckIfAvailablePropertiesEvent extends MainEvent {
  final List<String> selectedProperties;
  final Product product;

  const CheckIfAvailablePropertiesEvent({
    required this.product,
    required this.selectedProperties,
  });
}

class AddPropertyNameEvent extends MainEvent {
  final List<TextEditingController> propertyNameList;
  final List<List<TextEditingController>> propertyList;

  const AddPropertyNameEvent({
    required this.propertyNameList,
    required this.propertyList,
  });
}

class RemovePropertyNameEvent extends MainEvent {
  final List<TextEditingController> propertyNameList;
  final List<List<TextEditingController>> propertyList;
  final int index;

  const RemovePropertyNameEvent({
    required this.propertyNameList,
    required this.index,
    required this.propertyList,
  });
}

class AddPropertyEvent extends MainEvent {
  final List<TextEditingController> propertyList;

  const AddPropertyEvent({
    required this.propertyList,
  });
}

class FinishedAddPropertiesEvent extends MainEvent {
  final List<TextEditingController> propertyNameList;
  final List<List<TextEditingController>> propertyList;

  const FinishedAddPropertiesEvent({
    required this.propertyNameList,
    required this.propertyList,
  });
}

class RemovePropertyEvent extends MainEvent {
  final List<TextEditingController> propertyList;
  final int index;

  const RemovePropertyEvent({
    required this.index,
    required this.propertyList,
  });
}

class ChooseCategoryEvent extends MainEvent {
  List<Product> categoryProducts;
  final String categoryName;

  ChooseCategoryEvent({
    required this.categoryProducts,
    required this.categoryName,
  });
}

class SelectPropertiesEvent extends MainEvent {
  final String prop;
  List<String> selectedProperties;
  final List<String> properties;

  SelectPropertiesEvent({
    required this.prop,
    required this.selectedProperties,
    required this.properties,
  });
}
