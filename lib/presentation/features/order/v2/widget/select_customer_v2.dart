import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/order/v2/widget/customer_view.dart';
import 'package:pharmago/shared/ext/ext_context.dart';

import '../../../../../shared/style_app/init_style.dart';
import '../../../../base/dialog.dart';
import '../../../../base/empty_container.dart';
import '../../../../base/infinite_list.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../../customer/cubit/customer_cubit.dart';
import '../../../customer/cubit/customer_state.dart';
import '../../../customer/domain/entities/customer_entity.dart';
import 'customer_fast_create_view.dart';

class SelectCustomerV2 extends StatefulWidget {
  const SelectCustomerV2({
    this.customerSelected,
    this.onConfirm,
    super.key,
  });

  final CustomerEntity? customerSelected;
  final Function(CustomerEntity? value)? onConfirm;

  @override
  State<SelectCustomerV2> createState() => _BTSChoseCustomerState();
}

class _BTSChoseCustomerState extends State<SelectCustomerV2> {
  final _customerBloc = getIt.get<CustomerCubit>();

  CustomerEntity? _customerEntity;
  var isEmpty = ValueNotifier(false);
  final search = TextEditingController();

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
              BlocBuilder<CustomerCubit, CustomerState>(
                builder: (context, state) {
                  return AppInputSupport(
                    hintText: 'Tìm kiếm khách hàng',
                    controller: search,
                    prefixIcon: const Icon(Icons.search_rounded),
                    onChanged: _customerBloc.changeSearch,
                    backgroundColor: whiteColor,
                    maxLines: 1,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () {
                            _showBtsCreateCustomer(null);
                          },
                          child: SizedBox(
                            height: 30,
                            child: Center(
                              child: Text(
                                'Tạo mới',
                                style: StyleApp.semibold(
                                  fontSize: 16,
                                  color: ColorApp.main,
                                ),
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            search.clear();
                            _customerBloc.changeSearch('');
                            _customerBloc.entityILC.onRefresh();
                          },
                          child: const SizedBox(
                            height: 30,
                            width: 30,
                            child: Icon(
                              Icons.close,
                              size: 17,
                              color: ColorApp.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              gapHeight(sp16),
              BlocBuilder<CustomerCubit, CustomerState>(
                builder: (context, state) {
                  return InfiniteList<CustomerEntity>(
                    shrinkWrap: true,
                    getData: (page) async {
                      final list = await _customerBloc.getList(page);
                      isEmpty.value = list.isEmpty;
                      return list;
                    },
                    itemBuilder: (context, item, index) => Container(
                      decoration: BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.circular(sp12),
                      ),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _customerEntity = item;
                          });
                          widget.onConfirm?.call(_customerEntity);
                        },
                        child: CustomerView(
                          item: item,
                          isSelected: _customerEntity?.id == item.id,
                          onUpdated: (value) {
                            _showBtsCreateCustomer(value);
                          },
                        ),
                      ),
                    ),
                    scrollController: _customerBloc.scrollController,
                    infiniteListController: _customerBloc.entityILC,
                    noItemFoundWidget: const EmptyContainer(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBtsCreateCustomer(CustomerEntity? customer) {
    context.bottomSheet(
      CustomerFastCreateView(
        customer: customer,
        onConfirm: handleFastCreate,
        onUpdate: handleFastUpdate,
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void handleFastCreate(String phone, String name) {
    Navigator.pop(context);
    DialogUtils.showLoadingDialog(
      context,
      'Đang tạo khách hàng vui lòng đợi',
    );
    _customerBloc.fastCreate(phone, name).then((value) async {
      Navigator.of(context).pop();
      if (value.code == 200) {
        await DialogUtils.showSuccessDialog(
          context,
          barrierDismissible: true,
          content: 'Tạo khách hàng thành công',
        );
        _customerBloc.entityILC.onRefresh();
      } else if (value.code == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: yellow_1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp12),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text(
              value.message ?? '',
              style: p5.copyWith(color: whiteColor),
            ),
          ),
        );
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: 'Tạo khách hàng thất bại ${value.message}',
        );
      }
    });
  }

  void handleFastUpdate(CustomerEntity? customer) {
    if (customer == null) return;
    Navigator.pop(context);
    DialogUtils.showLoadingDialog(
      context,
      'Đang cập nhật khách hàng vui lòng đợi',
    );
    _customerBloc.fastUpdate(customer).then((value) async {
      Navigator.of(context).pop();
      if (value.code == 200) {
        await DialogUtils.showSuccessDialog(
          context,
          content: 'Cập nhật khách hàng thành công',
          barrierDismissible: true,
        );
        _customerBloc.entityILC.onRefresh();
      } else if (value.code == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: yellow_1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp12),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text(
              value.message ?? '',
              style: p5.copyWith(color: whiteColor),
            ),
          ),
        );
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: 'Cập nhật khách hàng thất bại ${value.message}',
        );
      }
    });
  }
}
