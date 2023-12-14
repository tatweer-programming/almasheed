import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AccountTypeItem extends StatelessWidget {
 final String type ;
final Widget nextScreen;
  const AccountTypeItem({super.key , required this.type  , required this.nextScreen});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
     context.push(nextScreen);
      },
      child: SizedBox(
        height: 35.w,
        width: 35.w,
        child: Card(
          elevation: 5,
          child: Center(
            child: Text(
              type ,
              style: TextStyle(fontSize: 16.sp,
                fontWeight: FontWeight.bold ,
              ),

            ),
          ),
        ),
      ),
    );
  }
}



