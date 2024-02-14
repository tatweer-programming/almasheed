import 'package:almasheed/authentication/data/models/address.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/font_manager.dart';
import 'package:almasheed/main/data/models/product.dart';
import 'package:almasheed/payment/data/models/order.dart';
import 'package:almasheed/payment/data/models/orderItem.dart';
import 'package:almasheed/payment/presentation/components.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../core/utils/color_manager.dart';
import '../../../generated/l10n.dart';
import '../../../main/view/widgets/widgets.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 100.w,
              child: ClipPath(
                clipper: HalfCircleCurve(18.h),
                child: Container(
                  height: 35.h,
                  color: ColorManager.primary,
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                        start: 8.w, end: 8.w, top: 1.h),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 6.h,
                        ),
                        Text(
                          S.of(context).orderDetails,
                          style: TextStyle(
                              color: ColorManager.white,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 3.h),
                        Icon(
                          Icons.list_outlined,
                          color: ColorManager.white,
                          size: 40.sp,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 1.h),
            Padding(
              padding: EdgeInsets.all(5.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        "${S.of(context).date}: ",
                        style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeightManager.bold,
                            color: ColorManager.black),
                      ),
                      Expanded(
                        child: Text(
                          "${DateTime.parse(order.id).year} - ${DateTime.parse(order.id).month} - ${DateTime.parse(order.id).day}",
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeightManager.bold,
                              color: ColorManager.primary),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    S.of(context).products,
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeightManager.bold,
                        color: ColorManager.black),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 9.sp),
                    child: Row(
                      children: [
                        Expanded(child: Text(S.of(context).product)),
                        Text(S.of(context).quantity)
                      ],
                    ),
                  ),
                  ListView.separated(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => OrderItemBuilder(
                            item: orderModel.orderItems[0],
                          ),
                      separatorBuilder: (context, index) => SizedBox(
                            height: 10.sp,
                          ),
                      itemCount: 3),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    S.of(context).address,
                    style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeightManager.bold,
                        color: ColorManager.black),
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  AddressBuilder(address: order.address)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

OrderModel orderModel = OrderModel(
    id: "2024-01-10 10:39:52.532789",
    totalPrice: 100,
    orderItems: [
      OrderItem(
          product: Product(
              productName: "شكارة اسمنت خمسين كيلو",
              productId: "",
              productOldPrice: 100,
              productNewPrice: 90,
              productCity: ConstantsManager.getSaudiCities[0],
              merchantId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
              productOverview:
                  "شكارة اسمنت الممتاز خمسين كيلوجرام لاغراض البناء",
              productMainUses:
                  "شكارة اسمنت الممتاز خمسين كيلوجرام لاغراض البناء",
              productWorkCharacteristics:
                  "شكارة اسمنت الممتاز خمسين كيلوجرام لاغراض البناء",
              merchantName: "عبده اسمنت"),
          quantity: 5),
      OrderItem(
          product: Product(
              productName: "شكارة اسمنت خمسين كيلو",
              productId: "",
              productOldPrice: 100,
              productNewPrice: 90,
              productCity: ConstantsManager.getSaudiCities[0],
              merchantId: "oVtWmHhUWJcVfi7MT1GyVvANHIA1",
              productOverview:
              "شكارة اسمنت الممتاز خمسين كيلوجرام لاغراض البناء",
              productMainUses:
              "شكارة اسمنت الممتاز خمسين كيلوجرام لاغراض البناء",
              productWorkCharacteristics:
              "شكارة اسمنت الممتاز خمسين كيلوجرام لاغراض البناء",
              merchantName: "عبده اسمنت"),
          quantity: 2),
      OrderItem(
          product: Product(
              productName: "شكارة جبس",
              productId: "",
              productOldPrice: 100,
              productNewPrice: 90,
              productCity: ConstantsManager.getSaudiCities[0],
              merchantId: "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
              productOverview:
              "شكارة اسمنت الممتاز خمسين كيلوجرام لاغراض البناء",
              productMainUses:
              "شكارة اسمنت الممتاز خمسين كيلوجرام لاغراض البناء",
              productWorkCharacteristics:
              "شكارة اسمنت الممتاز خمسين كيلوجرام لاغراض البناء",              merchantName: "عبده اسمنت"),
          quantity: 2),
    ],
    merchantIds: [
      "oVtWmHhUWJcVfi7MT1GyVvANHIA2",
      "oVtWmHhUWJcVfi7MT1GyVvANHIA1"
    ],
    address: Address(
        street: "شارع س المتفرع من شارع ص",
        city: "المدينة المنورة",
        houseNumber: 9,
        floor: 4,
        apartmentNumber: 2,
        area: "منطقة أ",
        plot: "القطعة ب",
        avenue: "الجادة الاولى",
        type: "منزل"));
