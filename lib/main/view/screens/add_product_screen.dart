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
    discountController.text = "0";
    bloc.imagesFiles = [];
    bloc.selectedProductCategory = null;
    Merchant merchant = ConstantsManager.appUser as Merchant;
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
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
                  style: TextStyle(
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

double newPriceAfterDiscount({
  required double price,
  required double discount,
}) {
  return (price * (100 - discount) / 100);
}
