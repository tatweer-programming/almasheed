import 'dart:io';
import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/data/models/category.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../../../core/error/remote_error.dart';
import '../../../core/services/dep_injection.dart';
import '../../bloc/main_bloc.dart';

class AddCategoryScreen extends StatelessWidget {
  const AddCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = sl();
    TextEditingController nameController = TextEditingController();
    bloc.add(MakeImagesFilesEmptyEvent());
    var formKey = GlobalKey<FormState>();
    return BlocConsumer<MainBloc, MainState>(
      listener: (context, state) {
        if (state is SetCategoryErrorState) {
          bloc.add(MakeImagesFilesEmptyEvent());
          errorToast(msg: ExceptionManager(state.error).translatedMessage());
        }
        if (state is SetCategoryLoadingState) {
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
        if (state is SetCategorySuccessfullyState) {
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
                content: const Text(
                  "The Category has been added successfully",
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
                  bloc.add(MakeImagesFilesEmptyEvent());
                  context.pop();
                },
                icon: const Icon(Icons.arrow_back_ios_new)),
          ),
          body: WillPopScope(
            onWillPop: () async {
              bloc.add(MakeImagesFilesEmptyEvent());
              return true;
            },
            child: Form(
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
                            defaultButton(
                                onPressed: () {
                                  bloc.add(PickImagesEvent());
                                },
                                text: "Add Image",
                                height: 6.h),
                            SizedBox(
                              height: 1.h,
                            ),
                            bloc.imagesFiles.isNotEmpty ?
                            Stack(
                              children: [
                                Card(
                                  child: SizedBox(
                                    height: 15.h,
                                    width: 27.w,
                                    child: Image.file(
                                        File(bloc.imagesFiles.first.path)),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 2.w, vertical: 0.2.h),
                                  child: iconContainer(
                                    onPressed: () {
                                      bloc.add(
                                          RemovePickedImageEvent(image: bloc.imagesFiles.first));
                                    },
                                    icon: Icons.close,
                                  ),
                                ),
                              ],
                            ):const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                    defaultButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            bloc.add(SetCategoryEvent(
                                category: Category(
                                    categoryName: nameController.text,
                                    categoryImageFile: bloc.imagesFiles.first,
                                    productsIds: const [])));
                          }
                        },
                        text: "Add Category",
                        height: 6.h),
                  ],
                ),
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
