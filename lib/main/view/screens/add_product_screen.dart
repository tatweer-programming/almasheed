import 'dart:io';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../authentication/data/models/merchant.dart';
import '../../../core/error/remote_error.dart';
import '../../../core/services/dep_injection.dart';
import '../../../core/utils/constance_manager.dart';
import '../../../generated/l10n.dart';
import '../../bloc/main_bloc.dart';
import '../../data/models/custom_properties.dart';
import 'add_category_screen.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = sl();
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController discountController = TextEditingController();
    List<List<TextEditingController>> propertyList = [
      [TextEditingController()]
    ];
    List<TextEditingController> propertyNameList = [TextEditingController()];
    discountController.text = "0";
    bloc.imagesFiles = [];
    List<String> selectedProperties = [];
    List<List<String>> selectedPropertiesSaved = [];
    bloc.selectedProductCategory = null;
    Merchant merchant = ConstantsManager.appUser as Merchant;
    var formKey = GlobalKey<FormState>();
    Map<String, List<String>> result = {};
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        print(state);
        if (state is SetProductErrorState) {
          bloc.add(MakeImagesFilesEmptyEvent());
          context.pop();
          mainErrorToast(
              msg: ExceptionManager(state.error).translatedMessage());
        }
        if (state is SetProductLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.sp)),
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  ));
            },
          );
        }
        if (state is FinishedAddPropertiesState) {
          result = state.result;
        }
        if (state is SelectPropertiesState) {
          selectedProperties = state.selectedProperties;
        }
        if (state is SelectedPropertiesSavedState) {
          selectedProperties = state.selectedProperties;
        }
        if (state is SetProductSuccessfullyState) {
          bloc.add(GetProductsEvent());
          bloc.add(MakeImagesFilesEmptyEvent());
          context.pop();
          context.pop();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.sp)),
                content: Text(
                  S.of(context).productAdded,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            actions: [
              Padding(
                padding: EdgeInsetsDirectional.only(end: 3.w),
                child: TextButton(
                    onPressed: () {
                      context.push(const AddCategoryScreen());
                    },
                    child: Text(
                      S.of(context).addCategory,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: ColorManager.white,
                          fontSize: 14.sp),
                    )),
              ),
            ],
            leading: IconButton(
                onPressed: () {
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new)),
          ),
          body: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 1.h,
                          ),
                          mainFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return S.of(context).enterName;
                                }
                                return null;
                              },
                              controller: nameController,
                              label: S.of(context).name),
                          SizedBox(
                            height: 1.h,
                          ),
                          mainFormField(
                              type: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return S.of(context).enterPrice;
                                }
                                return null;
                              },
                              controller: priceController,
                              label: S.of(context).price),
                          SizedBox(
                            height: 1.h,
                          ),
                          mainFormField(
                              type: TextInputType.number,
                              validator: (value) {
                                if (double.parse(value) > 100 ||
                                    double.parse(value) < 0) {
                                  return S.of(context).enterValidDiscount;
                                }
                                return null;
                              },
                              controller: discountController,
                              label: S.of(context).discount),
                          SizedBox(
                            height: 1.h,
                          ),
                          mainFormField(
                              controller: descriptionController,
                              label: S.of(context).description),
                          SizedBox(
                            height: 1.h,
                          ),
                          searchDropdownBuilder(
                            text: S.of(context).productCategory,
                            onChanged: (selectedProductCategory) {
                              bloc.add(SelectProductCategoryEvent(
                                  selectedProductCategory:
                                      selectedProductCategory!));
                            },
                            items: bloc.categories
                                .map((category) => category.categoryName)
                                .toList(),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          defaultButton(
                              onPressed: () {
                                bloc.add(PickImagesEvent());
                              },
                              text: S.of(context).addImage,
                              height: 6.h),
                          SizedBox(
                            height: 1.h,
                          ),
                          bloc.imagesFiles.isNotEmpty
                              ? SingleChildScrollView(
                                  child: Wrap(
                                    children: bloc.imagesFiles.map((image) {
                                      return Stack(
                                        children: [
                                          Card(
                                            child: SizedBox(
                                              height: 15.h,
                                              width: 27.w,
                                              child:
                                                  Image.file(File(image.path)),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.w,
                                                vertical: 0.2.h),
                                            child: iconContainer(
                                              onPressed: () {
                                                bloc.add(RemovePickedImageEvent(
                                                    image: image));
                                              },
                                              icon: Icons.close,
                                            ),
                                          ),
                                        ],
                                      );
                                    }).toList(),
                                  ),
                                )
                              : const SizedBox(),
                          Column(
                            children: [
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: propertyNameList.length,
                                itemBuilder: (context, index) => props(
                                  index: index,
                                  propertyNameController:
                                      propertyNameList[index],
                                  propertyList: propertyList[index],
                                  addPropertyName: () {
                                    bloc.add(AddPropertyNameEvent(
                                        propertyList: propertyList,
                                        propertyNameList: propertyNameList));
                                  },
                                  bloc: bloc,
                                  removePropertyName: () {
                                    bloc.add(RemovePropertyNameEvent(
                                        index: index,
                                        propertyList: propertyList,
                                        propertyNameList: propertyNameList));
                                  },
                                ),
                                separatorBuilder: (context, index) => Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2.h),
                                  child: Container(
                                    height: 0.2.h,
                                    color: ColorManager.grey2,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ),
                              defaultButton(
                                  onPressed: () {
                                    bloc.add(FinishedAddPropertiesEvent(
                                        propertyList: propertyList,
                                        propertyNameList: propertyNameList));
                                  },
                                  text: S.of(context).selectAvailableProperties),
                              Column(
                                children: [
                                  ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: result.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        String key =
                                            result.keys.elementAt(index);
                                        List<String> properties = result[key]!;
                                        return ListTile(
                                          title: Text(
                                            key,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600),
                                          ),
                                          subtitle: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: properties
                                                .map((prop) => InkWell(
                                                      onTap: () {
                                                        bloc.add(SelectPropertiesEvent(
                                                            prop: prop,
                                                            properties:
                                                                properties,
                                                            selectedProperties:
                                                                selectedProperties));
                                                      },
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsetsDirectional
                                                                .symmetric(
                                                                    horizontal:
                                                                        2.w,
                                                                    vertical:
                                                                        1.h),
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border.all(
                                                                  color: selectedProperties
                                                                          .contains(
                                                                              prop)
                                                                      ? ColorManager
                                                                          .primary
                                                                      : Colors
                                                                          .transparent),
                                                              color: ColorManager
                                                                  .secondary,
                                                              borderRadius:
                                                                  BorderRadiusDirectional
                                                                      .circular(
                                                                          10.sp),
                                                            ),
                                                            child: Text(
                                                              prop,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: 2.w,
                                                          )
                                                        ],
                                                      ),
                                                    ))
                                                .toList(),
                                          ),
                                        );
                                      }),
                                  if (result.isNotEmpty)
                                    SizedBox(
                                      width: 40.w,
                                      child: defaultButton(
                                          onPressed: () {
                                            bloc.add(SelectedPropertiesSavedEvent(
                                                selectedProperties:
                                                    selectedProperties,
                                                selectedPropertiesSaved:
                                                    selectedPropertiesSaved));
                                          },
                                          text: S.of(context).add),
                                    ),
                                  ListView.separated(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return Row(
                                          children: [
                                            Text(
                                                "${selectedPropertiesSaved[index]}",
                                            style: TextStyle(fontSize: 16.sp),),
                                            const Spacer(),
                                            IconButton(
                                                onPressed: () {
                                                  bloc.add(RemoveSelectedPropertiesSavedEvent(
                                                      index: index,
                                                      selectedPropertiesSaved:
                                                          selectedPropertiesSaved));
                                                },
                                                icon: const Icon(Icons.clear)),
                                          ],
                                        );
                                      },
                                      separatorBuilder: (context, index) =>
                                          SizedBox(
                                            height: 1.h,
                                          ),
                                      itemCount:
                                          selectedPropertiesSaved.length),
                                  SizedBox(
                                    height: 2.h,
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  defaultButton(
                      onPressed: () {
                        if (bloc.selectedProductCategory == null) {
                          mainErrorToast(
                              msg: S.of(context).enterSelectedCategory);
                        } else {
                          if (formKey.currentState!.validate()) {
                            bloc.add(
                              SetProductEvent(
                                product: Product(
                                  customProperties: ProductCustomProperties(
                                      availableProperties: transformList(selectedPropertiesSaved),
                                      properties: convertToMap(
                                          propertyList, propertyNameList)),
                                  productName: nameController.text,
                                  productCategory: bloc.selectedProductCategory,
                                  productsImagesFile: bloc.imagesFiles,
                                  merchantId: merchant.id,
                                  productId: DateTime.now().toString(),
                                  productOldPrice:
                                      double.parse(priceController.text),
                                  productNewPrice: newPriceAfterDiscount(
                                      price: double.parse(priceController.text),
                                      discount: double.parse(
                                          discountController.text)),
                                  productCity: merchant.city,
                                  productDescription:
                                      descriptionController.text,
                                  merchantName: merchant.companyName,
                                ),
                              ),
                            );
                          }
                        }
                      },
                      text: S.of(context).addProduct,
                      height: 6.h),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget props({
  required TextEditingController propertyNameController,
  required List<TextEditingController> propertyList,
  required VoidCallback addPropertyName,
  required VoidCallback removePropertyName,
  required MainBloc bloc,
  required int index,
}) {
  return Column(
    children: [
      Row(
        children: [
          Expanded(
            child: mainFormField(controller: propertyNameController),
          ),
          SizedBox(
            width: 3.w,
          ),
          InkWell(onTap: addPropertyName, child: const Icon(Icons.add_circle)),
          SizedBox(
            width: 1.w,
          ),
          if (index > 0)
            InkWell(
                onTap: removePropertyName,
                child: const Icon(Icons.remove_circle)),
        ],
      ),
      SizedBox(
        height: 1.h,
      ),
      BlocBuilder<MainBloc, MainState>(
        builder: (context, state) {
          return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => Row(
                    children: [
                      Expanded(
                        child: mainFormField(controller: propertyList[index]),
                      ),
                      SizedBox(
                        width: 3.w,
                      ),
                      InkWell(
                          onTap: () {
                            bloc.add(
                                AddPropertyEvent(propertyList: propertyList));
                          },
                          child: const Icon(Icons.add_circle)),
                      SizedBox(
                        width: 1.w,
                      ),
                      if (index > 0)
                        InkWell(
                            onTap: () {
                              bloc.add(RemovePropertyEvent(
                                  index: index, propertyList: propertyList));
                            },
                            child: const Icon(Icons.remove_circle)),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
              separatorBuilder: (context, index) => SizedBox(
                    height: 1.h,
                  ),
              itemCount: propertyList.length);
        },
      )
    ],
  );
}

double newPriceAfterDiscount({
  required double price,
  required double discount,
}) {
  return (price * (100 - discount) / 100);
}
