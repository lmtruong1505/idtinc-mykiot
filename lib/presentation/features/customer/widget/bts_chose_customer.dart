import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/spacing.dart';

import '../../../base/empty_container.dart';
import '../../../base/infinite_list.dart';
import '../../../constants/colors.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../cubit/customer_cubit.dart';
import '../domain/entities/customer_entity.dart';

class BTSChoseCustomer extends StatefulWidget {
  const BTSChoseCustomer({
    this.customerSelected,
    this.onConfirm,
    super.key,
  });

  final CustomerEntity? customerSelected;
  final Function(CustomerEntity? value)? onConfirm;

  @override
  State<BTSChoseCustomer> createState() => _BTSChoseCustomerState();
}

class _BTSChoseCustomerState extends State<BTSChoseCustomer> {
  final _scrollController = ScrollController();
  final _infiniteListController = InfiniteListController<CustomerEntity>.init();
  final _customerBloc = getIt.get<CustomerCubit>();

  CustomerEntity? _customerEntity;

  @override
  void initState() {
    _customerEntity = widget.customerSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerCubit>(
      create: (context) => _customerBloc,
      child: Container(
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Danh sách khách hàng',
                    style: p3.copyWith(color: blackColor),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _customerEntity = null;
                      });
                    },
                    child: Row(
                      children: [
                        Text(
                          'Chọn lại',
                          style: p3.copyWith(color: blue_1),
                        ),
                        const Icon(
                          Icons.refresh,
                          color: blue_1,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              gapHeight(sp16),
              AppInputSupport(
                hintText: 'Tìm kiếm khách hàng',
                prefixIcon: const Icon(Icons.search_rounded),
                onConfirm: (p0) => _infiniteListController.onRefresh(),
                backgroundColor: whiteColor,
               ),
              gapHeight(sp16),
              InfiniteList<CustomerEntity>(
                shrinkWrap: true,
                getData: (page) async {
                  final list = await _customerBloc.getList(page);
                  return list;
                },
                itemBuilder: (context, item, index) => Container(
                  decoration: BoxDecoration(
                    color: whiteColor,
                    borderRadius: BorderRadius.circular(sp12),
                  ),
                  child: InkWell(
                    onTap: (){
                      setState(() {
                        _customerEntity = item;
                      });
                      widget.onConfirm?.call(_customerEntity);
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(sp16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name ?? '',
                                style: p3.copyWith(color: blackColor),
                              ),
                              gapHeight(sp8),
                              Text(
                                item.phone ?? '',
                                style: p5.copyWith(color: greyColor),
                              ),
                            ],
                          ),
                          Visibility(
                            visible: _customerEntity?.id == item.id,
                            child: const Icon(
                              Icons.check_circle_outline_rounded,
                              color: mainColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                scrollController: _scrollController,
                infiniteListController: _infiniteListController,
                noItemFoundWidget: const EmptyContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
