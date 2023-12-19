import 'dart:io';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/error/remote_error.dart';
import '../../../core/services/dep_injection.dart';
import '../../../core/utils/color_manager.dart';
import '../../bloc/main_bloc.dart';

class AddProductScreen extends StatelessWidget {
  const AddProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();
    TextEditingController discountController = TextEditingController();
    // Merchant merchant = ConstantsManager.appUser as Merchant;
    MainBloc bloc = sl();
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is SetProductErrorState)errorToast(msg: ExceptionManager(state.error).translatedMessage());
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
                            controller: discountController, label: "Discount"),
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
                                            child: Image.file(File(image.path)),
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 2.w, vertical: 0.2.h),
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
                      bloc.add(SetProductEvent(
                          product: Product(
                              productName: nameController.text,
                              productsImagesFile: bloc.imagesFiles,
                              productOldPrice: double.parse(priceController.text),
                              productNewPrice: double.parse(
                                  discountController.text == ""
                                      ? "0"
                                      : discountController.text),
                              productCity: "city",
                              productDescription: discountController.text,
                              merchantName: "companyName")));
                    },
                    text: "Add Product",
                    height: 6.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
