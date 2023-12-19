import 'dart:io';

import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/error/remote_error.dart';
import '../../../core/services/dep_injection.dart';
import '../../data/models/product.dart';
import '../widgets/widgets.dart';

class ModifyProductScreen extends StatelessWidget {
  final Product product;
  const ModifyProductScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController discountController = TextEditingController();
    MainBloc bloc = sl();
    nameController.text = product.productName;
    priceController.text = product.productOldPrice.toString();
    discountController.text = product.productNewPrice.toString();
    descriptionController.text = product.productDescription;
    bloc.imagesFiles = [];
    product.productsImagesDelete??=[];
    product.productsImagesUrl??=[];
    // Merchant merchant = ConstantsManager.appUser as Merchant;
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is GetProductsSuccessfullyState) {
          print(state);
          bloc.add(GetCategoriesEvent());
        }
        if (state is UpdateProductErrorState)errorToast(msg: ExceptionManager(state.error).translatedMessage());
        if(state is UpdateProductLoadingState){
          showDialog(context: context,
              barrierDismissible: true,
              builder: (context) {
                return const AlertDialog(
                  content:
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(child: CircularProgressIndicator()),
                      ],
                    )
                );
              },
          );
        }if(state is UpdateProductSuccessfullyState){
          bloc.add(GetProductsEvent());
          context.pop();
          context.pop();
          context.pop();
          showDialog(context: context,
              builder: (context) {
                return const AlertDialog(
                  content:  Text("The product has been modified successfully",style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),),
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
                          defaultFormField(
                              controller: nameController, label: "Name"),
                          SizedBox(
                            height: 1.h,
                          ),
                          defaultFormField(
                              controller: priceController, label: "Price"),
                          SizedBox(
                            height: 1.h,
                          ),
                          defaultFormField(
                              controller: discountController,
                              label: "Discount"),
                          SizedBox(
                            height: 1.h,
                          ),
                          defaultFormField(
                              controller: descriptionController,
                              label: "Description"),
                          SizedBox(
                            height: 1.h,
                          ),
                          defaultButton(
                              onPressed: () {
                                bloc.add(PickImagesEvent());
                              },
                              text: "Add Image",
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
                                                    imagesUrl:product.productsImagesUrl!,
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
                                productId: product.productId,
                                productsImagesFile: bloc.imagesFiles,
                                productsImagesUrl: product.productsImagesUrl,
                                productsImagesDelete: product.productsImagesDelete,
                                productOldPrice:
                                    double.parse(priceController.text),
                                productNewPrice: double.parse(
                                    discountController.text == ""
                                        ? "0"
                                        : discountController.text),
                                productCity: "merchant.city",
                                productDescription: descriptionController.text,
                                merchantName: "merchant.companyName")));
                      },
                      text: "Modify Product",
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
