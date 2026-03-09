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
import 'package:pharmago/presentation/features/prepare/cubit/prepare_cubit.dart';
import 'package:pharmago/presentation/features/prepare/cubit/prepare_state.dart';

@RoutePage()
class PrepareUpdatePage extends StatefulWidget {
  final int? id;
  const PrepareUpdatePage({super.key, this.id});

  @override
  State<PrepareUpdatePage> createState() => _PrepareUpdatePageState();
}

class _PrepareUpdatePageState extends State<PrepareUpdatePage> {
  final myBloc = getIt.get<PrepareCubit>();
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: BaseAppBar(
          title: widget.id != null
              ? 'Chỉnh sửa dạng bào chế'
              : 'Thêm mới dạng bào chế'),
      body: Container(
          margin: const EdgeInsets.all(sp16),
          child: BlocProvider<PrepareCubit>(
              create: (context) => myBloc..getDetail(context, widget.id),
              child: BlocBuilder<PrepareCubit, PrepareState>(
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
                              label: 'Mã dạng bào chế',
                              hintText: 'Nhập mã dạng bào chế',
                              initialValue: state.item.code,
                              onChanged: myBloc.changeCode),
                          gapHeight(sp12),
                          AppInputSupport(
                              label: 'Tên dạng bào chế',
                              hintText: 'Nhập tên dạng bào chế',
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
