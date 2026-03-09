import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product_standard/cubit/product_standard_cubit.dart';
import 'package:pharmago/presentation/features/product_standard/cubit/product_standard_state.dart';

@RoutePage()
class ProductStandardUpdatePage extends StatefulWidget {
  final int? id;
  const ProductStandardUpdatePage({super.key, this.id});

  @override
  State<ProductStandardUpdatePage> createState() =>
      _ProductStandardUpdatePageState();
}

class _ProductStandardUpdatePageState extends State<ProductStandardUpdatePage> {
  final myBloc = getIt.get<ProductStandardCubit>();
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: BaseAppBar(
          title: widget.id != null
              ? 'Chỉnh sửa tiêu chuẩn sản xuất'
              : 'Thêm mới tiêu chuẩn sản xuất'),
      body: Container(
          margin: const EdgeInsets.all(sp16),
          child: BlocProvider<ProductStandardCubit>(
              create: (context) => myBloc..getDetail(context, widget.id),
              child: BlocBuilder<ProductStandardCubit, ProductStandardState>(
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
                              label: 'Mã tiêu chuẩn sản xuất',
                              hintText: 'Nhập mã tiêu chuẩn sản xuất',
                              initialValue: state.item.code,
                              onChanged: myBloc.changeCode),
                          gapHeight(sp12),
                          AppInputSupport(
                              label: 'Tên tiêu chuẩn sản xuất',
                              hintText: 'Nhập tên tiêu chuẩn sản xuất',
                              required: true,
                              initialValue: state.item.name,
                              onChanged: myBloc.changeName),
                          gapHeight(sp12),
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
