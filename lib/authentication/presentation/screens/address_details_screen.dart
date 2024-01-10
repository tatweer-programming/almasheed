import 'package:almasheed/authentication/data/models/address.dart';
import 'package:almasheed/authentication/data/models/customer.dart';
import 'package:almasheed/authentication/presentation/components.dart';
import 'package:almasheed/core/utils/constance_manager.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../core/error/remote_error.dart';
import '../../../core/utils/color_manager.dart';
import '../../../generated/l10n.dart';
import '../../bloc/auth_bloc.dart';

class AddressDetailsScreen extends StatelessWidget {
  final Address address;

  const AddressDetailsScreen({super.key, required this.address});

  @override
  Widget build(BuildContext context) {
    AuthBloc bloc = AuthBloc.get(context);
    return BlocBuilder<AuthBloc, AuthState>(
      bloc: bloc,
      builder: (context, state) {
        return BlocListener<AuthBloc, AuthState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is RemoveAddressSuccessfulState) {
              defaultToast(msg: S.of(context).removedSuccessfully);
              context.pop();
            } else if (state is RemoveAddressErrorState) {
              defaultToast(
                  msg: ExceptionManager(state.exception).translatedMessage());
            }
          },
          child: Scaffold(
            body: Column(
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
                              height: 5.h,
                            ),
                            Text(
                              address.type,
                              style: TextStyle(
                                  color: ColorManager.white,
                                  fontSize: 28.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 3.h),
                            Icon(
                              Icons.map_outlined,
                              color: ColorManager.white,
                              size: 40.sp,
                            ),
                            SizedBox(width: 3.h),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: 5.w, end: 5.w),
                    child: Column(
                      children: [
                        AddressItem(
                            label: S.of(context).city, value: address.city),
                        SizedBox(
                          height: 1.h,
                        ),
                        AddressItem(
                            label: S.of(context).plot, value: address.plot),
                        SizedBox(
                          height: 1.h,
                        ),
                        AddressItem(
                            label: S.of(context).area, value: address.area),
                        SizedBox(
                          height: 1.h,
                        ),
                        AddressItem(
                            label: S.of(context).avenue, value: address.avenue),
                        SizedBox(
                          height: 1.h,
                        ),
                        AddressItem(
                            label: S.of(context).street, value: address.street),
                        SizedBox(
                          height: 1.h,
                        ),
                        AddressItem(
                            label: S.of(context).houseNumber,
                            value: address.houseNumber.toString()),
                        SizedBox(
                          height: 1.h,
                        ),
                        AddressItem(
                            label: S.of(context).floor,
                            value: address.floor.toString()),
                        SizedBox(
                          height: 1.h,
                        ),
                        AddressItem(
                            label: S.of(context).apartmentNumber,
                            value: address.apartmentNumber.toString()),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                ConstantsManager.appUser is Customer
                    ? Padding(
                        padding:
                            EdgeInsetsDirectional.only(start: 5.w, end: 5.w),
                        child: state is RemoveAddressLoadingState
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : defaultButton(
                                text: S.of(context).delete,
                                onPressed: () {
                                  bloc.add(RemoveAddressEvent(address));
                                }),
                      )
                    : SizedBox(
                        height: 5.h,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
