import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/features/customer/cubit/selection_customer_cubit/selection_customer_cubit.dart';
import 'package:pharmago/presentation/features/customer/cubit/selection_customer_cubit/selection_customer_state.dart';

import '../../../base/app_bar.dart';
import '../../../base/button.dart';
import '../../../base/empty_container.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../di/di.dart';
import '../cubit/customer_cubit.dart';
import '../cubit/customer_group_create_cubit/customer_group_create_cubit.dart';
import '../cubit/customer_state.dart';

@RoutePage()
class SelectionCustomerPage extends StatefulWidget {
  const SelectionCustomerPage({required this.customerGroupCreateCubit, super.key});

  final CustomerGroupCreateCubit customerGroupCreateCubit;

  @override
  State<SelectionCustomerPage> createState() => _SelectionCustomerPageState();
}

class _SelectionCustomerPageState extends State<SelectionCustomerPage> {
  final _customerBloc = getIt.get<CustomerCubit>();
  final _myBloc = getIt.get<SelectionCustomerCubit>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => _customerBloc,
        ),
        BlocProvider(
          create: (context) => _myBloc,
        ),
      ],
      child: BlocBuilder<CustomerCubit, CustomerState>(
        builder: (BuildContext context, CustomerState state) {
          return Scaffold(
            backgroundColor: whiteColor,
            appBar: const BaseAppBar(
              title: 'Chọn khách hàng',
            ),
            body: Container(
              padding: const EdgeInsets.all(sp16).copyWith(top: sp0),
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(sp12),
                ),
                color: bg_5,
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.1),
                    offset: const Offset(1, 1),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  _customerBloc.entityILC.onRefresh();
                },
                child: ListView(
                  controller: _customerBloc.scrollController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    gapHeight(sp16),
                    AppInputSupport(
                      hintText: 'Tìm kiếm khách hàng',
                      prefixIcon: const Icon(Icons.search_rounded),
                      backgroundColor: whiteColor,
                      onChanged: _customerBloc.changeSearch,
                    ),
                    gapHeight(sp16),
                    InfiniteList(
                      shrinkWrap: true,
                      getData: (page) async {
                        return _customerBloc.getList(page);
                      },
                      itemBuilder: (context, item, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: sp16),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(sp12),
                            boxShadow: [
                              BoxShadow(
                                color: blackColor.withOpacity(0.1),
                                offset: const Offset(1, 1),
                                blurRadius: 1,
                              ),
                            ],
                          ),
                          child: BlocBuilder<SelectionCustomerCubit,
                              SelectionCustomerState>(
                            builder: (context, state) {
                              return ListTile(
                                title: Text(item.name ?? ''),
                                subtitle: Text(item.phone ?? ''),
                                contentPadding: EdgeInsets.zero,
                                leading: BaseCheckbox(
                                  value: _myBloc.state.customers.contains(item),
                                  onChanged: (value) {
                                    if (value != null) {
                                      if (value) {
                                        _myBloc.addCustomer(
                                          item,
                                        );
                                      } else {
                                        _myBloc.removeCustomer(
                                          item,
                                        );
                                      }
                                    }
                                  },
                                ),
                              );
                            },
                          ),
                        );
                      },
                      scrollController: _customerBloc.scrollController,
                      infiniteListController: _customerBloc.entityILC,
                      circularProgressIndicator: const BaseLoading(),
                      noItemFoundWidget: const EmptyContainer(),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.1),
                    offset: const Offset(0, -1),
                    blurRadius: sp4,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(sp16),
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: ExtraButton(
                      title: 'Huỷ bỏ',
                      event: () {
                        context.router.maybePop();
                      },
                    ),
                  ),
                  gapWidth(sp16),
                  Expanded(
                    child: MainButton(
                      title: 'Xác nhận',
                      event: () {
                        if (_myBloc.state.customers.isNotEmpty) {
                          widget.customerGroupCreateCubit.selectCustomer(
                            _myBloc.state.customers,
                          );
                        }
                        context.router.maybePop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
