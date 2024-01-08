// import 'package:almasheed/core/utils/color_manager.dart';
// import 'package:almasheed/generated/l10n.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
//
// class AddAddressScreen extends StatelessWidget {
//   const AddAddressScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
// appBar: AppBar(
//         title: Text(S.of(context).addAddress),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(
//               height: 5.h,
//             ),
//             Padding(
//               padding: EdgeInsetsDirectional.only(start: 8.w, end: 8.w),
//               child: Column(
//                 children: [
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                   Text(
//                     S.of(context).addAddress,
//                     style: TextStyle(
//                         color: ColorManager.primary,
//                         fontSize: 30.sp,
//                         fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(width: 3.h),
//                   Icon(
//                     Icons.map_outlined,
//                     color: ColorManager.primary,
//                     size: 40.sp,
//                   ),
//                   SizedBox(width: 3.h),
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: S.of(context).street,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: S.of(context).city,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: S.of(context).state,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: S.of(context).houseNumber,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: S.of(context).floor,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: S.of(context).apartmentNumber,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: S.of(context).area,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                   TextFormField(
//                     decoration: InputDecoration(
//                       labelText: S.of(context).plot,
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 5.h,
//                   ),
//                     ],
//                   ),
//
//     );
//   }
// }
