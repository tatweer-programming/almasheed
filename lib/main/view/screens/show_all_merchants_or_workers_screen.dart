import 'package:almasheed/authentication/data/models/worker.dart';
import 'package:almasheed/core/services/dep_injection.dart';
import 'package:almasheed/core/utils/navigation_manager.dart';
import 'package:almasheed/main/bloc/main_bloc.dart';
import 'package:almasheed/main/view/screens/categories/category_screen.dart';
import 'package:almasheed/main/view/screens/worker_details_screen.dart';
import 'package:almasheed/main/view/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../authentication/data/models/merchant.dart';
import '../../../generated/l10n.dart';
import '../../data/models/category.dart';

class ShowAllMerchantsOrWorkers extends StatelessWidget {
  final List<Merchant> merchants;
  final List<Worker> workers;

  const ShowAllMerchantsOrWorkers(
      {super.key, required this.merchants, required this.workers});

  @override
  Widget build(BuildContext context) {
    MainBloc mainBloc = sl();
    return Scaffold(
      body: Column(
        children: [
          appBarWidget(
              merchants.isNotEmpty
                  ? S.of(context).merchants
                  : S.of(context).workers,
              Icons.work),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              child: ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => merchantAndWorkerWidget(
                        name: merchants.isNotEmpty
                            ? merchants[index].companyName
                            : workers[index].name,
                        details: merchants.isNotEmpty
                            ? merchants[index].city
                            : workers[index].works.first,
                        onTap: () {
                          if (merchants.isNotEmpty) {
                            context.push(CategoryScreen(
                              category: Category(
                                categoryName: merchants[index].companyName,
                                products: mainBloc.products
                                    .where((product) => merchants[index]
                                        .productsIds
                                        .contains(product.productId))
                                    .toList(),
                                productsIds: merchants[index].productsIds,
                              ),
                            ));
                          } else {
                            context.push(WorkerDetailsScreen(
                              worker: workers[index],
                            ));
                          }
                        },
                      ),
                  separatorBuilder: (context, index) => SizedBox(height: 1.h),
                  itemCount:
                      merchants.isNotEmpty ? merchants.length : workers.length),
            ),
          ),
        ],
      ),
    );
  }
}
