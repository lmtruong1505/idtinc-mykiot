import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

import '../../../base/button.dart';
import '../../../base/expandable.dart';
import '../../../base/row_item.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../cubit/customer_group_create_cubit/customer_group_create_cubit.dart';
import '../cubit/customer_group_create_cubit/customer_group_create_state.dart';

@RoutePage()
class CustomerGroupCreatePage extends StatefulWidget {
  const CustomerGroupCreatePage(this.id, {super.key});

  final int? id;

  @override
  State<CustomerGroupCreatePage> createState() =>
      _CustomerGroupCreatePageState();
}

class _CustomerGroupCreatePageState extends State<CustomerGroupCreatePage> {
  final _myBloc = getIt.get<CustomerGroupCreateCubit>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _myBloc..getDetail(widget.id),
      child: BlocBuilder<CustomerGroupCreateCubit, CustomerGroupCreateState>(
        builder: (BuildContext context, CustomerGroupCreateState state) {
          if (state.isLoading) {
            return const Center(
              child: BaseLoading(),
            );
          }
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: bg_5,
              appBar: BaseAppBar(
                title: widget.id == null
                    ? 'Tạo nhóm khách hàng'
                    : 'Sửa nhóm khách hàng',
              ),
              body: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp24,
                  horizontal: sp16,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expandable(
                          header: 'Thông tin cơ bản',
                          child: Column(
                            children: [
                              AppInputSupport(
                                label: 'Mã nhóm khách hàng',
                                hintText: 'Nhập mã nhóm khách hàng',
                                initialValue: state.customerGroup.code,
                                onChanged: _myBloc.changeCode,
                                backgroundColor: whiteColor,
                                borderColor: bg_1,
                              ),
                              gapHeight(sp16),
                              AppInputSupport(
                                label: 'Tên nhóm khách hàng',
                                hintText: 'Nhập tên nhóm khách hàng',
                                onChanged: _myBloc.changeName,
                                initialValue: state.customerGroup.name,
                                required: true,
                                backgroundColor: whiteColor,
                                borderColor: bg_1,
                                validate: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return 'Tên nhóm khách hàng không được để trống';
                                  }
                                  return null;
                                },
                              ),
                              gapHeight(sp16),
                              AppInputSupport(
                                label: 'Ghi chú',
                                hintText: 'Nhập ghi chú',
                                initialValue: state.customerGroup.note,
                                onChanged: _myBloc.changeName,
                                backgroundColor: whiteColor,
                                borderColor: bg_1,
                              ),
                            ],
                          ),
                        ),
                        gapHeight(sp16),
                        Visibility(
                          visible: widget.id == null,
                          child: Row(
                            children: [
                              const Text(
                                'Danh sách khách hàng trong nhóm',
                                style: p5,
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  context.router.push(
                                    SelectionCustomerRoute(
                                      customerGroupCreateCubit: _myBloc,
                                    ),
                                  );
                                },
                                child: Text(
                                  'Chọn khách hàng',
                                  style: p5.copyWith(color: blue_1),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: widget.id == null,
                          child: gapHeight(sp16),
                        ),
                        Visibility(
                          visible: widget.id == null,
                          child: AppInputSupport(
                            hintText: 'Tìm kiếm khách hàng',
                            prefixIcon: const Icon(Icons.search_rounded),
                            backgroundColor: whiteColor,
                            onChanged: (value) {
                              _myBloc.searchCustomer(value);
                            },
                          ),
                        ),
                        Visibility(
                          visible: widget.id == null,
                          child: gapHeight(sp16),
                        ),
                        _myBloc.state.customerSearchList.isEmpty
                            ? Visibility(
                                visible: widget.id == null,
                                child: const Center(
                                  child: Text(
                                    'Chưa có khách hàng nào được chọn vào nhóm.\n Vui lòng thử lại',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : Visibility(
                                visible: widget.id == null,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final item =
                                        _myBloc.state.customerSearchList[index];
                                    return _customerItem(context, item);
                                  },
                                  separatorBuilder: (context, index) =>
                                      gapHeight(sp16),
                                  itemCount:
                                      _myBloc.state.customerSearchList.length,
                                ),
                              ),
                      ],
                    ),
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
                        title: widget.id == null ? 'Xác nhận' : 'Lưu lại',
                        event: widget.id == null ? _handleCreate : _handleUpdate,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _customerItem(BuildContext context, CustomerEntity item) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp12),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(item.code ?? ''),
            subtitle: Text(item.name ?? ''),
            contentPadding: EdgeInsets.zero,
            trailing: IconButton(
              onPressed: () {},
              icon: Container(
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(sp8),
                ),
                height: sp32,
                width: sp32,
                child: InkWell(
                  onTap: () {
                    _myBloc.removeCustomer(item);
                  },
                  child: const Icon(Icons.delete_outline),
                ),
              ),
              color: Colors.red,
            ),
          ),
          gapHeight(sp8),
          RowItem(title: 'Số điện thoại', content: item.phone ?? ''),
          gapHeight(sp8),
          const RowItem(title: 'Đơn hàng hoàn thành', content: '1000'),
          gapHeight(sp8),
          const RowItem(title: 'Người tạo', content: 'Trần Thế Anh'),
        ],
      ),
    );
  }

  void _handleCreate() {
    final validate = _formKey.currentState!.validate();
    if (!validate) {
      return;
    }
    DialogUtils.showLoadingDialog(context, 'Đang tạo nhóm khách hàng...');
    _myBloc.create().then((value) {
      Navigator.pop(context);
      if (value?.code == 200) {
        DialogUtils.showSuccessDialog(
          context,
          content: 'Tạo nhóm khách hàng thành công',
          barrierDismissible: true,
        );
        return;
      }
      DialogUtils.showErrorDialog(
        context,
        content: 'Tạo nhóm khách hàng thất bại \n ${value?.message}',
      );
    });
  }

  void _handleUpdate(){
    final validate = _formKey.currentState!.validate();
    if (!validate) {
      return;
    }
    DialogUtils.showLoadingDialog(context, 'Đang cập nhật nhóm khách hàng...');
    _myBloc.update().then((value) {
      Navigator.pop(context);
      if (value?.code == 200) {
        DialogUtils.showSuccessDialog(
          context,
          content: 'Cập nhật nhóm khách hàng thành công',
          barrierDismissible: true,
        );
        return;
      }
      DialogUtils.showErrorDialog(
        context,
        content: 'Cập nhật nhóm khách hàng thất bại \n ${value?.message}',
      );
    });
  }
}
