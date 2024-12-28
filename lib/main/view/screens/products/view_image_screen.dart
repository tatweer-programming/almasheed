import 'package:almasheed/core/utils/color_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:carousel_slider/carousel_controller.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/services/dep_injection.dart';

class ViewImageScreen extends StatelessWidget {
  final List<String> productsImagesUrl;
  final CarouselSliderController carouselController;

  const ViewImageScreen(
      {super.key,
      required this.productsImagesUrl,
      required this.carouselController});

  @override
  Widget build(BuildContext context) {
    MainBloc bloc = sl<MainBloc>();
    return Scaffold(
        body: Column(children: [
      SizedBox(
        height: 2.h,
      ),
      Container(
        color: ColorManager.white,
        child: defaultCarousel(
          height: 90.h,
          fit: BoxFit.contain,
          bloc: bloc,
          autoPlay: false,
          list: productsImagesUrl,
          controller: carouselController,
        ),
      ),
    ]));
  }
}
