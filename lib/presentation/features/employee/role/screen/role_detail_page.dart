import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/base/expandable.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/entities/employee_entity.dart';
import 'package:pharmago/presentation/features/employee/role/cubit/role_cubit.dart';
import 'package:pharmago/presentation/features/employee/role/cubit/role_state.dart';
import 'package:pharmago/presentation/features/employee/role/domain/entities/item_entity.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

@RoutePage()
class RoleDetailPage extends StatefulWidget {
  final int id;
  const RoleDetailPage({super.key, required this.id});

  @override
  State<RoleDetailPage> createState() => _RoleDetailPageState();
}

class _RoleDetailPageState extends State<RoleDetailPage> {
  final myBloc = getIt.get<RoleCubit>();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BaseAppBar(
          title: 'Chi tiết vai trò',
          actions: [
            InkWell(
              onTap: () async {
                await context.router.push(RoleUpdateRoute(id: widget.id));
                if (context.mounted) {
                  await myBloc.getDetail(context, widget.id);
                }
                myBloc.entityILC.onRefresh();
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                decoration: const BoxDecoration(color: Colors.white),
                child: const Icon(Icons.edit_outlined, size: 25, color: bg_1),
              ),
            ),
            InkWell(
              onTap: () => myBloc.delete(context, widget.id),
              child: Container(
                margin: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                decoration: const BoxDecoration(color: Colors.white),
                child: const Icon(Icons.delete_outline, size: 25, color: bg_1),
              ),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(sp16),
          child: BlocProvider<RoleCubit>(
            create: (context) => myBloc..getDetail(context, widget.id),
            child: BlocBuilder<RoleCubit, RoleState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  controller: myBloc.scrollController,
                  child: Column(
                    children: [
                      Expandable(
                        header: 'Thông tin vai trò',
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Tên vai trò: ${state.role.title}',
                                style: p6,
                              ),
                            ),
                            gapHeight(sp6),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text('150 nhân viên', style: p3),
                            ),
                            gapHeight(sp12),
                            RowItem(
                              title: 'Người tạo',
                              content: state.role.userCreatedName,
                            ),
                            gapHeight(sp12),
                            RowItem(
                              title: 'Thời gian tạo',
                              content: state.role.createdAt,
                            ),
                            gapHeight(sp12),
                            RowItem(
                              title: 'Người cập nhật',
                              content: state.role.userUpdatedName,
                            ),
                            gapHeight(sp12),
                            RowItem(
                              title: 'Thời gian cập nhật',
                              content: state.role.updatedAt,
                            ),
                            gapHeight(sp12),
                          ],
                        ),
                      ),
                      gapHeight(sp28),
                      Expandable(
                        header: 'Các quyền trong vai trò',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final key in state.optionRoles.keys)
                              //   for(final it in state.optionRoles[key]!)
                              _oneCheckbox(state, key, state.optionRoles[key]!),
                          ],
                        ),
                      ),
                      gapHeight(sp16),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: const Text(
                          'Danh sách nhân viên được gán',
                          style: p3,
                        ),
                      ),
                      gapHeight(sp16),
                      BlocBuilder<RoleCubit, RoleState>(
                        builder: (context, state) {
                          return SingleChildScrollView(
                            controller: myBloc.scrollController,
                            child: Column(
                              children: [
                                AppInputSupport(
                                  hintText: 'Tìm kiếm nhân viên',
                                  backgroundColor: whiteColor,
                                  onConfirm: myBloc.changeSearch,
                                  prefixIcon: const Icon(Icons.search_rounded),
                                ),
                                gapHeight(sp16),
                                for (final it in state.employees)
                                  (it.fullName?.contains(state.search) ?? false)
                                      ? _oneItem(it)
                                      : Container(),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

  Widget _oneCheckbox(
    RoleState state,
    ItemEntity root,
    List<ItemEntity> child,
  ) {
    return Expandable(
      headerWidget: Row(
        children: [
          BaseCheckbox(
            value: root.checked,
            onChanged: (value) => myBloc.changeRootCheckbox(root),
          ),
          gapWidth(sp8),
          Text(root.title, style: h5),
        ],
      ),
      header: '',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final it in child)
            Row(
              children: [
                BaseCheckbox(
                  value: it.checked,
                  onChanged: (value) => myBloc.changeChildCheckbox(
                    root,
                    it,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: sp8, horizontal: sp8),
                  child: Text(it.title, style: p3),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _oneItem(EmployeeEntity item) => GestureDetector(
        onTap: () async {
          await context.router.push(EmployeeDetailRoute(id: item.id!));
          myBloc.entityILC.onRefresh();
        },
        child: Container(
          padding: const EdgeInsets.all(sp16),
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 20),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(sp12),
            boxShadow: [
              BoxShadow(
                color: blackColor.withOpacity(0.1),
                blurRadius: 2,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tên nhân viên: ${item.fullName}',
                        style: p6.copyWith(color: blackColor),
                      ),
                      Text(
                        'Mã nhân viên: ${item.code}',
                        style: p5.copyWith(color: borderColor_4),
                      ),
                    ],
                  ),
                  Container(
                    width: 15,
                    margin: const EdgeInsets.fromLTRB(10, 5, 0, 10),
                    decoration: const BoxDecoration(color: Colors.white),
                    child: const Icon(Icons.more_vert, size: 20),
                  ),
                ],
              ),
              gapHeight(sp16),
              Row(
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                    decoration: const BoxDecoration(
                      color: green_2,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Text(
                      'Đang hoạt động',
                      style: p3.copyWith(color: green_1),
                    ),
                  ),
                ],
              ),
              gapHeight(sp16),
              // RowItem(title: 'Vai trò', content: "Nhân viên"),
              // gapHeight(sp12),
              RowItem(title: 'Số điện thoại', content: item.username ?? ''),
              gapHeight(sp12),
            ],
          ),
        ),
      );
}
