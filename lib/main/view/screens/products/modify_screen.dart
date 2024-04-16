import 'dart:io';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../../authentication/data/models/merchant.dart';
import '../../../../core/error/remote_error.dart';
import '../../../../core/services/dep_injection.dart';
import '../../../../core/utils/constance_manager.dart';
import '../../../../generated/l10n.dart';
import '../../../data/models/product.dart';
import '../../widgets/widgets.dart';

class ModifyProductScreen extends StatelessWidget {
  final Product product;
  const ModifyProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController overviewController = TextEditingController();
    TextEditingController mainUsesController = TextEditingController();
    TextEditingController workCharacteristicsController =
        TextEditingController();
    TextEditingController discountController = TextEditingController();
    MainBloc bloc = sl();
    nameController.text = product.productName;
    priceController.text = product.productOldPrice.toString();
    discountController.text = product.productNewPrice.toString();
    overviewController.text = product.productOverview;
    workCharacteristicsController.text = product.productWorkCharacteristics;
    mainUsesController.text = product.productMainUses;
    bloc.imagesFiles = [];
    product.productsImagesDelete ??= [];
    product.productsImagesUrl ??= [];
    Merchant merchant = ConstantsManager.appUser as Merchant;
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is GetProductsSuccessfullyState) {
          bloc.add(GetCategoriesEvent());
        }
        if (state is UpdateProductErrorState) {
          mainErrorToast(
              msg: ExceptionManager(state.error).translatedMessage());
        }
        if (state is UpdateProductLoadingState) {
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
        if (state is UpdateProductSuccessfullyState) {
          bloc.add(GetProductsEvent());
          bloc.add(MakeImagesFilesEmptyEvent());
          context.pop();
          context.pop();
          context.pop();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.sp)),
                content: Text(
                  S.of(context).productModified,
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
        return DefaultTabController(
          initialIndex: 1,
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    context.pop();
                  },
                  icon: const Icon(Icons.arrow_back_ios_new)),
            ),
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          mainFormField(
                              controller: nameController,
                              label: S.of(context).name),
                          SizedBox(
                            height: 1.h,
                          ),
                          mainFormField(
                              controller: priceController,
                              label: S.of(context).price),
                          SizedBox(
                            height: 1.h,
                          ),
                          mainFormField(
                              controller: discountController,
                              label: S.of(context).discount),
                          SizedBox(
                            height: 1.h,
                          ),
                          mainFormField(
                              controller: overviewController,
                              label: S.of(context).description),
                          SizedBox(
                            height: 1.h,
                          ),
                          mainFormField(
                              controller: mainUsesController,
                              label: S.of(context).description),
                          SizedBox(
                            height: 1.h,
                          ),
                          mainFormField(
                              controller: workCharacteristicsController,
                              label: S.of(context).description),
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
                          product.productsImagesUrl != null
                              ? SingleChildScrollView(
                                  child: Wrap(
                                    children:
                                        product.productsImagesUrl!.map((image) {
                                      return Stack(
                                        children: [
                                          Card(
                                            child: SizedBox(
                                              height: 15.h,
                                              width: 27.w,
                                              child: Image.network(image),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 2.w,
                                                vertical: 0.2.h),
                                            child: iconContainer(
                                              onPressed: () {
                                                bloc.add(RemoveImageEvent(
                                                    imagesUrlDelete: product
                                                        .productsImagesDelete!,
                                                    imagesUrl: product
                                                        .productsImagesUrl!,
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
                        bloc.add(UpdateProductEvent(
                            product: Product(
                                productName: nameController.text,
                                productRating: product.productRating,
                                ratingNumbers: product.ratingNumbers,
                                productId: product.productId,
                                productMainUses: mainUsesController.text,
                                productWorkCharacteristics:
                                    workCharacteristicsController.text,
                                productsImagesFile: bloc.imagesFiles,
                                productsImagesUrl: product.productsImagesUrl,
                                merchantId: merchant.id,
                                productsImagesDelete:
                                    product.productsImagesDelete,
                                productOldPrice:
                                    double.parse(priceController.text),
                                productNewPrice: double.parse(
                                    discountController.text == ""
                                        ? "0"
                                        : discountController.text),
                                productCity: merchant.city,
                                productOverview: overviewController.text,
                                merchantName: merchant.companyName)));
                      },
                      text: S.of(context).modifyProduct,
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
