import 'dart:io';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/error/remote_error.dart';
import '../../../core/services/dep_injection.dart';
import '../../bloc/main_bloc.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController productCategoryController = TextEditingController();
    TextEditingController discountController = TextEditingController();
    discountController.text = "0";
    // Merchant merchant = ConstantsManager.appUser as Merchant;
    MainBloc bloc = sl();
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is SetProductErrorState) {
          errorToast(msg: ExceptionManager(state.error).translatedMessage());
        }
        if (state is SetProductLoadingState) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                  shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.sp)
                  ),
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
          context.pop();
          context.pop();
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.sp)
                ),
                content: const Text(
                  "The product has been added successfully",
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
                          SizedBox(height: 1.h,),
                          defaultFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter a name";
                                }
                                return null;
                              },
                              controller: nameController,
                              label: "Name"),
                          SizedBox(
                            height: 1.h,
                          ),
                          defaultFormField(
                              type: TextInputType.number,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter a price";
                                }
                                return null;
                              },
                              controller: priceController,
                              label: "Price"),
                          SizedBox(
                            height: 1.h,
                          ),
                          defaultFormField(
                              type: TextInputType.number,
                              validator: (value) {
                                if (double.parse(value) > 100 ||
                                    double.parse(value) < 0) {
                                  return "Please enter a valid discount from 0% to 100%";
                                }
                                return null;
                              },
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
                          defaultFormField(
                              controller: productCategoryController,
                              label: "Product Category"),
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
                        ],
                      ),
                    ),
                  ),
                  defaultButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          bloc.add(SetProductEvent(
                              product: Product(
                                  productName: nameController.text,
                                  productCategory: productCategoryController.text,
                                  productsImagesFile: bloc.imagesFiles,
                                  productId: DateTime.now().toString(),
                                  productOldPrice:
                                      double.parse(priceController.text),
                                  productNewPrice: newPriceAfterDiscount(
                                    price: double.parse(priceController.text),
                                      discount: double.parse(discountController.text)),
                                  productCity: "city",
                                  productDescription: discountController.text,
                                  merchantName: "companyName")));
                        }
                      },
                      text: "Add Product",
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
}){
  return (price *
      (100 - discount ) / 100);
}