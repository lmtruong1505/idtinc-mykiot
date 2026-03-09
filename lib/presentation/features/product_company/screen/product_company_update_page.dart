import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product_company/cubit/product_company_cubit.dart';
import 'package:pharmago/presentation/features/product_company/cubit/product_company_state.dart';

import '../../../base/select.dart';

@RoutePage()
class ProductCompanyUpdatePage extends StatefulWidget {
  final int? id;
  const ProductCompanyUpdatePage({super.key, this.id});

  @override
  State<ProductCompanyUpdatePage> createState() =>
      _ProductCompanyUpdatePageState();
}

class _ProductCompanyUpdatePageState extends State<ProductCompanyUpdatePage> {
  final myBloc = getIt.get<ProductCompanyCubit>();
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: BaseAppBar(
          title: widget.id != null
              ? 'Chỉnh sửa công ty sản xuất'
              : 'Thêm mới công ty sản xuất'),
      body: Container(
          margin: const EdgeInsets.all(sp16),
          child: BlocProvider<ProductCompanyCubit>(
              create: (context) => myBloc..getDetail(context, widget.id),
              child: BlocBuilder<ProductCompanyCubit, ProductCompanyState>(
                  builder: (context, state) {
                if (widget.id != null && state.item.id == null) {
                  return Container();
                }
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
                          gapHeight(sp12),
                          AppInputSupport(
                              label: 'Mã công ty sản xuất',
                              hintText: 'Nhập mã công ty sản xuất',
                              required: true,
                              initialValue: state.item.code,
                              onChanged: myBloc.changeCode),
                          gapHeight(sp12),
                          AppInputSupport(
                              label: 'Tên công ty sản xuất',
                              hintText: 'Nhập tên công ty sản xuất',
                              required: true,
                              initialValue: state.item.name,
                              onChanged: myBloc.changeName),
                          gapHeight(sp12),
                          CommonDropdown(
                            label: 'Nước sản xuất',
                            items: [
                              DropdownMenuItem(
                                  value: 'Việt Nam',
                                  child: Text('Việt Nam', style: p6)),
                              DropdownMenuItem(
                                  value: 'Lào', child: Text('Lào', style: p6)),
                            ],
                            value: state.item.country,
                            hintText: 'Chọn nước sản xuất',
                            onChanged: myBloc.changeCountry,
                          ),
                          gapHeight(sp12),
                          AppInputSupport(
                              label: 'Địa chỉ sản xuất',
                              hintText: 'Nhập địa chỉ',
                              required: true,
                              initialValue: state.item.name,
                              onChanged: myBloc.changeAddress),
                          gapHeight(sp12),
                          SizedBox(height: 12),
                          AppInputSupport(
                              label: 'Mô tả',
                              hintText: 'Nhập mô tả',
                              initialValue: state.item.description,
                              onChanged: myBloc.changeDescription),
                          gapHeight(sp12),
                        ])),
                  ]),
                );
              }))),
      bottomNavigationBar: Container(
          padding: const EdgeInsets.all(sp16),
          decoration: BoxDecoration(color: whiteColor, boxShadow: [
            BoxShadow(
                color: blackColor.withOpacity(0.1),
                offset: const Offset(0, -1),
                blurRadius: sp4)
          ]),
          child: Row(children: [
            Expanded(
                child: ExtraButton(
                    title: 'Huỷ bỏ',
                    event: () => context.router.pop(),
                    largeButton: false,
                    backgroundColor: bg_4,
                    borderColor: borderColor_2)),
            SizedBox(width: 10),
            Expanded(
                child: MainButton(
                    title: widget.id != null ? 'Lưu lại' : 'Tạo mới',
                    largeButton: false,
                    event: () => widget.id != null
                        ? myBloc.update(context)
                        : myBloc.create(context)))
          ])));
}
