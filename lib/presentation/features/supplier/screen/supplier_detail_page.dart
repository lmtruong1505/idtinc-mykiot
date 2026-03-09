import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/address/screens/select_address.dart';
import 'package:pharmago/presentation/features/supplier/cubit/supplier_cubit.dart';
import 'package:pharmago/presentation/features/supplier/cubit/supplier_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

@RoutePage()
class SupplierDetailPage extends StatefulWidget {
  final int id;
  const SupplierDetailPage({super.key, required this.id});

  @override
  State<SupplierDetailPage> createState() => _SupplierDetailPageState();
}

class _SupplierDetailPageState extends State<SupplierDetailPage> {
  final myBloc = getIt.get<SupplierCubit>();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BaseAppBar(title: 'Chi tiết nhà cung cấp', actions: [
          InkWell(
              onTap: () async {
                await context.router.push(SupplierUpdateRoute(id: widget.id));
                await myBloc.getDetail(context, widget.id);
                myBloc.entityILC.onRefresh();
              },
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Icon(Icons.edit_outlined, size: 25, color: bg_1))),
          InkWell(
              onTap: () => myBloc.delete(context, widget.id),
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Icon(Icons.delete_outline, size: 25, color: bg_1)))
        ]),
        body: Container(
            margin: const EdgeInsets.all(sp16),
            child: BlocProvider<SupplierCubit>(
                create: (context) => myBloc..getDetail(context, widget.id),
                child: BlocBuilder<SupplierCubit, SupplierState>(
                    builder: (context, state) {
                  return SingleChildScrollView(
                    controller: myBloc.scrollController,
                    child: Column(children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: sp24, horizontal: sp16),
                          width: widthDevice(context),
                          decoration:
                              BoxDecoration(color: whiteColor, boxShadow: [
                            BoxShadow(
                                color: blackColor.withOpacity(0.1),
                                offset: const Offset(1, 1),
                                blurRadius: 1)
                          ]),
                          child: Column(children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text('Nhà cung cấp', style: p3)),
                            Divider(height: 15, color: borderColor_2),
                            gapHeight(sp12),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    'Mã nhà cung cấp: ${state.supplier.code}',
                                    style: p3)),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                    'Tên nhà cung cấp : ${state.supplier.name}',
                                    style: p6)),
                            gapHeight(sp12),
                            Row(children: [
                              Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 3, horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: bg_4,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(4))),
                                  child: Text("Nhà cung cấp thân thiết",
                                      style: p3.copyWith(color: greyColor))),
                            ]),
                            gapHeight(sp12),
                            RowItem(
                                title: 'Số điện thoại',
                                content: state.supplier.phone),
                            gapHeight(sp12),
                            RowItem(
                                title: 'Đại diện nhà cung cấp',
                                content: state.supplier.deputyName),
                            gapHeight(sp12),
                            RowItem(
                                title: 'Số điện thoại đại diện',
                                content: state.supplier.phone),
                            gapHeight(sp12),
                            RowItem(
                                title: 'Địa chỉ',
                                content: SelectAddressView.formatAddress(
                                    state.supplier.address)),
                            gapHeight(sp12),
                            RowItem(
                                title: 'Email', content: state.supplier.email),
                            gapHeight(sp12),
                            RowItem(
                                title: 'Người tạo',
                                content: state.supplier.deputyName),
                            gapHeight(sp12),
                            RowItem(
                                title: 'Thời gian tạo',
                                content: '10:11 11-02-2022'),
                            gapHeight(sp12),
                            RowItem(
                                title: 'Người cập nhật',
                                content: state.supplier.deputyName),
                            gapHeight(sp12),
                            RowItem(
                                title: 'Thời gian cập nhật',
                                content: '10:11 11-02-2022'),
                            gapHeight(sp12),
                          ])),
                      gapHeight(sp28),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Danh sách đơn nhập kho', style: p3)),
                      gapHeight(sp16),
                      BlocBuilder<SupplierCubit, SupplierState>(
                          builder: (context, state) {
                        return SingleChildScrollView(
                            controller: myBloc.scrollController,
                            child: Column(children: [
                              AppInputSupport(
                                  hintText: 'Tìm kiếm theo tên/mã sản phẩm',
                                  backgroundColor: whiteColor,
                                  onConfirm: myBloc.changeSearch,
                                  prefixIcon: const Icon(Icons.search_rounded)),
                              gapHeight(sp16),
                              RowItem(
                                  title: 'Tổng số đơn nhập kho',
                                  content: '16.000.000'),
                              // for (var i = 0; i < variants!.length; i++)
                              //   variants[i].name.contains(state.search)
                              //       ? _oneItem(variants[i])
                              //       : Container(),
                            ]));
                      })
                    ]),
                  );
                }))),
      );
}
