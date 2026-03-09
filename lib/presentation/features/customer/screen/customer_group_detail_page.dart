import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/features/customer/cubit/customer_group_detail_cubit/customer_group_detail_state.dart';

import '../../../base/date.dart';
import '../../../base/expandable.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../di/di.dart';
import '../../../router/router.gr.dart';
import '../cubit/customer_group_detail_cubit/customer_group_detail_cubit.dart';

@RoutePage()
class CustomerGroupDetailPage extends StatefulWidget {
  const CustomerGroupDetailPage({required this.id, super.key});

  final int id;

  @override
  State<CustomerGroupDetailPage> createState() =>
      _CustomerGroupDetailPageState();
}

class _CustomerGroupDetailPageState extends State<CustomerGroupDetailPage> {
  final myBloc = getIt.get<CustomerGroupDetailCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc..getDetail(widget.id),
      child: Scaffold(
        backgroundColor: bg_5,
        appBar: BaseAppBar(
          title: 'Chi tiết nhóm khách hàng',
          actions: [
            IconButton(
              onPressed: () async {
                await context.router.push(
                  CustomerGroupCreateRoute(id: widget.id),
                );
                myBloc.getDetail(widget.id);
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                _handleDelete(context);
              },
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: BlocBuilder<CustomerGroupDetailCubit, CustomerGroupDetailState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: BaseLoading(),
              );
            }
            return Container(
              padding: const EdgeInsets.symmetric(
                vertical: sp24,
                horizontal: sp16,
              ),
              height: heightDevice(context),
              width: widthDevice(context),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expandable(
                      header: 'Thông tin cơ bản',
                      child: Column(
                        children: [
                          ListTile(
                            title: Text(state.customerGroup?.code ?? ''),
                            subtitle: Text(state.customerGroup?.name ?? ''),
                            contentPadding: EdgeInsets.zero,
                          ),
                          const Text(
                            'Lorem ipsum dolor sit amet consectetur. Amet egestas tortor et adipiscing urna at. Dictumst viverra pharetra vitae faucibus phasellus. Pellentesque ut tortor nibh sem. Neque vestibulum egestas urna bibendum.',
                          ),
                          gapHeight(sp16),
                          RowItem(
                              title: 'Người tạo',
                              content:
                                  state.customerGroup?.userCreatedName ?? ''),
                          gapHeight(sp8),
                          RowItem(
                            title: 'Thời gian tạo',
                            content: Date.formatDateDay(
                                state.customerGroup?.createdAt),
                          ),
                          gapHeight(sp8),
                          RowItem(
                            title: 'Người cập nhật',
                            content: state.customerGroup?.userUpdatedName ?? '',
                          ),
                          gapHeight(sp8),
                          RowItem(
                            title: 'Thời gian cập nhật',
                            content: Date.formatDateDay(
                                state.customerGroup?.updatedAt),
                          ),
                        ],
                      ),
                    ),
                    gapHeight(sp16),
                    const Text(
                      'Danh sách khách hàng trong nhóm',
                      style: p5,
                    ),
                    gapHeight(sp16),
                    AppInputSupport(
                      hintText: 'Tìm kiếm khách hàng',
                      prefixIcon: const Icon(Icons.search_rounded),
                      backgroundColor: whiteColor,
                      onConfirm: (value) {},
                    ),
                    gapHeight(sp16),
                    ListView.separated(
                      itemCount: 4,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return _customerItem(context, index);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return gapHeight(sp16);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _customerItem(BuildContext context, int idx) {
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp12),
      ),
      child: Column(
        children: [
          const ListTile(
            title: Text('Mã khách hàng'),
            subtitle: Text('Tên khách hàng'),
            contentPadding: EdgeInsets.zero,
          ),
          gapHeight(sp8),
          const RowItem(title: 'Số điện thoại', content: '0987654321'),
          gapHeight(sp8),
          const RowItem(title: 'Đơn hàng hoàn thành', content: '1000'),
          gapHeight(sp8),
          const RowItem(title: 'Người tạo', content: 'Trần Thế Anh'),
        ],
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    await DialogUtils.showErrorDialog(
      context,
      content:
          'Bạn có chắc muốn xóa nhóm khách hàng, hành động này sẽ không thể hoàn tác',
      titleClose: 'Huỷ bỏ',
      titleConfirm: 'Xác nhận',
      close: () {
        Navigator.of(context).pop();
      },
      accept: () {
         Navigator.of(context).pop();
         myBloc.delete(widget.id);
         context.router.maybePop();
      },
    );
  }
}
