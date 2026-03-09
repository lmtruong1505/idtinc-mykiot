import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/base/expandable.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/employee/role/cubit/role_cubit.dart';
import 'package:pharmago/presentation/features/employee/role/cubit/role_state.dart';
import 'package:pharmago/presentation/features/employee/role/domain/entities/item_entity.dart';

@RoutePage()
class RoleUpdatePage extends StatefulWidget {
  final int? id;
  const RoleUpdatePage({super.key, this.id});

  @override
  State<RoleUpdatePage> createState() => _RoleUpdatePageState();
}

class _RoleUpdatePageState extends State<RoleUpdatePage> {
  final myBloc = getIt.get<RoleCubit>();
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: bg_4,
        appBar: BaseAppBar(
          title: widget.id != null ? 'Chỉnh sửa vai trò' : 'Tạo mới vai trò',
        ),
        body: Container(
          margin: const EdgeInsets.all(sp16),
          child: BlocProvider<RoleCubit>(
            create: (context) => myBloc..getDetail(context, widget.id),
            child: BlocBuilder<RoleCubit, RoleState>(
              builder: (context, state) {
                if (widget.id != null && state.role.id == null) {
                  return Container();
                }
                return SingleChildScrollView(
                  controller: myBloc.scrollController,
                  child: Column(
                    children: [
                      Expandable(
                        header: 'Thêm mới vai trò',
                        child: Column(
                          children: [
                            gapHeight(sp12),
                            AppInputSupport(
                              label: 'Tên vai trò',
                              hintText: 'Nhập tên vai trò',
                              required: true,
                              initialValue: state.role.title,
                              onChanged: myBloc.changeTitle,
                              backgroundColor: bg_4,
                              borderColor: bg_4,
                            ),
                            gapHeight(sp12),
                            AppInputSupport(
                              label: 'Mã vai trò',
                              hintText: 'Nhập mã vai trò',
                              initialValue: state.role.code,
                              onChanged: myBloc.changeCode,
                              backgroundColor: bg_4,
                              borderColor: bg_4,
                            ),
                            gapHeight(sp12),
                            AppInputSupport(
                              label: 'Ghi chú',
                              hintText: 'Nhập ghi chú',
                              initialValue: state.role.note,
                              onChanged: myBloc.changeNote,
                              backgroundColor: bg_4,
                              borderColor: bg_4,
                              maxLines: 3,
                            ),
                            gapHeight(sp12),
                          ],
                        ),
                      ),
                      gapHeight(sp20),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text('Phân quyền vai trò', style: p3),
                      ),
                      gapHeight(sp20),
                      for (final it in state.role.items)
                        _oneItemRole(state, it),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(sp16),
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
          child: Row(
            children: [
              Expanded(
                child: ExtraButton(
                  title: 'Huỷ bỏ',
                  event: () => context.router.pop(),
                  backgroundColor: bg_4,
                  borderColor: borderColor_2,
                ),
              ),
              gapWidth(sp12),
              Expanded(
                child: MainButton(
                  title: widget.id != null ? 'Lưu lại' : 'Tạo mới',
                  event: () => widget.id != null
                      ? myBloc.update(context)
                      : myBloc.create(context),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _oneItemRole(RoleState state, ItemEntity it) => Container(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, sp16),
        child: Expandable(
          header: it.title,
          headerWidget: Expanded(
            child: Row(
              children: [
                BaseCheckbox(
                  value: state.optionSelected.contains(
                    it.code,
                  ),
                  onChanged: (value) =>
                      myBloc.changeOption(value == true, it.code),
                ),
                gapWidth(sp12),
                Expanded(
                  child: Text(
                    it.title,
                    style: p5.copyWith(color: blackColor),
                  ),
                ),
              ],
            ),
          ),
          child: Column(
            children: [
              for (final ito in it.items) _oneCheckbox(state, ito),
            ],
          ),
        ),
      );

  Widget _oneCheckbox(RoleState state, ItemEntity it) => Container(
        padding: const EdgeInsets.symmetric(vertical: sp4),
        child: Row(
          children: [
            BaseCheckbox(
              value: state.optionSelected.contains(
                it.code,
              ),
              onChanged: (value) => myBloc.changeOption(value == true, it.code),
            ),
            gapWidth(sp12),
            Expanded(
              child: Text(
                it.title,
                style: p5.copyWith(color: blackColor),
              ),
            ),
          ],
        ),
      );
}
