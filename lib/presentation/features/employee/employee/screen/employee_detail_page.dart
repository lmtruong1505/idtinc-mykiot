import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/expandable.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/address/screens/select_address.dart';
import 'package:pharmago/presentation/router/router.gr.dart';

import '../cubit/employee_cubit.dart';
import '../cubit/employee_state.dart';

@RoutePage()
class EmployeeDetailPage extends StatefulWidget {
  final int id;
  const EmployeeDetailPage({super.key, required this.id});

  @override
  State<EmployeeDetailPage> createState() => _EmployeeDetailPageState();
}

class _EmployeeDetailPageState extends State<EmployeeDetailPage> {
  final myBloc = getIt.get<EmployeeCubit>();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BaseAppBar(
          title: 'Chi tiết nhân viên',
          actions: [
            IconButton(
              onPressed: () async {
                await context.router
                    .push(EmployeeUpdateRoute(id: widget.id))
                    .then(
                      (value) => myBloc.getDetail(context, widget.id).then(
                            (value) => myBloc.entityILC.onRefresh(),
                          ),
                    );
              },
              icon: const Icon(
                Icons.edit_outlined,
                size: sp20,
                color: greyTextColor,
              ),
            ),
            IconButton(
              onPressed: () => myBloc.delete(context, widget.id),
              icon: const Icon(
                Icons.delete_outline,
                size: sp20,
                color: greyTextColor,
              ),
            ),
          ],
        ),
        body: Container(
          margin: const EdgeInsets.all(sp16),
          child: BlocProvider<EmployeeCubit>(
            create: (context) => myBloc..getDetail(context, widget.id),
            child: BlocBuilder<EmployeeCubit, EmployeeState>(
              builder: (context, state) {
                return SingleChildScrollView(
                  controller: myBloc.scrollController,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.fromLTRB(sp12, sp6, sp0, sp6),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(sp8)),
                          color: whiteColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Trạng thái', style: p6),
                                ],
                              ),
                            ),
                            Transform.scale(
                              scale: 0.8,
                              child: CupertinoSwitch(
                                value: state.employee.active,
                                onChanged: myBloc.changeActive,
                              ),
                            ),
                          ],
                        ),
                      ),
                      gapHeight(sp12),
                      Expandable(
                        header: 'Thông tin tài khoản',
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                '${state.employee.fullName}',
                                style: p3,
                              ),
                            ),
                            // gapHeight(sp6),
                            // Container(
                            //   alignment: Alignment.centerLeft,
                            //   child: Text(
                            //     'Mã nhân viên: ${state.employee.code}',
                            //     style: p3,
                            //   ),
                            // ),
                            gapHeight(sp12),
                            RowItem(
                              title: 'Tên đăng nhập',
                              content: state.employee.username ?? '',
                            ),
                            // gapHeight(sp12),
                            // RowItem(
                            //     title: 'Người tạo',
                            //     content: state.employee.deputyName),
                            gapHeight(sp12),
                            RowItem(
                              title: 'Thời gian tạo',
                              content: state.employee.createdAt == null
                                  ? ''
                                  : DateFormat('dd/M/y')
                                      .format(state.employee.createdAt!),
                            ),
                            // gapHeight(sp12),
                            // RowItem(
                            //     title: 'Người cập nhật',
                            //     content: state.employee.deputyName),
                            gapHeight(sp12),
                            // RowItem(
                            //     title: 'Thời gian cập nhật',
                            //     content: '10:11 11-02-2022'),
                            // gapHeight(sp12),
                            const RowItem(
                              title: 'Vai trò nhân viên',
                              content: 'Kiểm duyệt',
                            ),
                            gapHeight(sp12),
                          ],
                        ),
                      ),
                      gapHeight(sp28),
                      Expandable(
                        header: 'Thông tin cá nhân',
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.employee.email ?? '', style: h6),
                            gapHeight(sp12),
                            Text(
                              SelectAddressView.formatAddress(
                                state.employee.address,
                              ),
                              style: h6.copyWith(color: greyColor),
                            ),
                            gapHeight(sp12),
                            RowItem(
                              title: 'Số điện thoại',
                              content: state.employee.username ?? '',
                            ),
                            gapHeight(sp12),
                            const RowItem(
                              title: 'Ngày sinh',
                              content: '03/01/2024',
                            ),
                            gapHeight(sp12),
                          ],
                        ),
                      ),
                      gapHeight(sp16),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(sp16),
          child: MainButton(
            title: 'Đổi mật khẩu',
            event: () => context.router.push(
              const EmployeeChangePassRoute(),
            ),
          ),
        ),
      );
}
