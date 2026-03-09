import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/account/cubit/account_cubit.dart';
import 'package:pharmago/presentation/features/account/cubit/account_state.dart';
import 'package:pharmago/shared/constants/pref_key.dart';

import '../../../constants/colors.dart';

@RoutePage()
class AccountInfoEditPage extends StatefulWidget {
  @override
  State<AccountInfoEditPage> createState() => _AccountInfoEditPageState();
}

class _AccountInfoEditPageState extends State<AccountInfoEditPage> {
  final myBloc = getIt.get<AccountCubit>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: BaseAppBar(title: 'Chỉnh sửa thông tin'),
        body: Container(
            width: widthDevice(context),
            height: heightDevice(context),
            padding: const EdgeInsets.symmetric(
              vertical: sp24,
              horizontal: sp16,
            ),
            child: ListView(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                Stack(children: [
                  Container(
                      width: sp80,
                      height: sp80,
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(sp40),
                          child: const BaseCacheImage(
                              url: PrefKeys.avatarDefault, fit: BoxFit.cover))),
                  // Positioned(
                  //   bottom: 0,
                  //   left: 65,
                  //   child: InkWell(
                  //       onTap: () async {},
                  //       child: Container(
                  //           margin: EdgeInsets.fromLTRB(10, 5, 0, 5),
                  //           padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                  //           decoration: BoxDecoration(
                  //             color: whiteColor,
                  //             borderRadius: BorderRadius.circular(sp40),
                  //           ),
                  //           child: Icon(Icons.edit_outlined,
                  //               size: 18, color: bg_1))),
                  // )
                ])
              ]),

              // Container(
              //     padding: const EdgeInsets.symmetric(
              //         vertical: sp20, horizontal: sp16),
              //     width: widthDevice(context),
              //     decoration: BoxDecoration(
              //         color: whiteColor,
              //         borderRadius: BorderRadius.circular(sp12),
              //         boxShadow: [
              //           BoxShadow(
              //               color: blackColor.withOpacity(0.1),
              //               offset: const Offset(1, 1),
              //               blurRadius: 1)
              //         ]),
              //     child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //         children: [
              //           Text('Gói tài khoản cơ bản', style: p3),
              //           Text('Thay đổi', style: p3.copyWith(color: blue_1)),
              //         ])),
              // gapHeight(sp28),
              BlocProvider<AccountCubit>(
                  create: (context) => myBloc..getDetail(),
                  child: BlocBuilder<AccountCubit, AccountState>(
                      builder: (context, state) {
                    if (state.account == null) return Container();
                    return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: sp20, horizontal: sp16),
                        width: widthDevice(context),
                        decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(sp12),
                            boxShadow: [
                              BoxShadow(
                                  color: blackColor.withOpacity(0.1),
                                  offset: const Offset(1, 1),
                                  blurRadius: 1)
                            ]),
                        child: Column(children: [
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text('Thông tin tài khoản', style: p3)),
                          Divider(height: 15, color: borderColor_2),
                          AppInputSupport(
                            label: 'Email',
                            hintText: 'Nhập tên email',
                            initialValue: state.account?.email ?? "",
                            // onChanged: myBloc.changeName,
                          ),
                          gapHeight(sp12),
                          AppInputSupport(
                            label: 'Số điện thoại',
                            hintText: 'Nhập số điện thoại',
                            initialValue: state.account?.phone ?? "",
                            // onChanged: myBloc.changeName,
                          ),
                          gapHeight(sp12),
                        ]));
                  })),
              gapHeight(sp28),
              // Container(
              //     padding: const EdgeInsets.symmetric(
              //         vertical: sp20, horizontal: sp16),
              //     width: widthDevice(context),
              //     decoration: BoxDecoration(
              //         color: whiteColor,
              //         borderRadius: BorderRadius.circular(sp12),
              //         boxShadow: [
              //           BoxShadow(
              //               color: blackColor.withOpacity(0.1),
              //               offset: const Offset(1, 1),
              //               blurRadius: 1)
              //         ]),
              //     child: Column(children: [
              //       Container(
              //           alignment: Alignment.centerLeft,
              //           child: Text('Thông tin doanh nghiệp', style: p3)),
              //       Divider(height: 15, color: borderColor_2),
              //       gapHeight(sp12),
              //       AppInputSupport(
              //         label: 'Tên doanh nghiệp',
              //         hintText: 'Nhập tên doanh nghiệp',
              //         initialValue: "Nhà Thuốc Thae",
              //         // onChanged: myBloc.changeName,
              //       ),
              //       gapHeight(sp12),
              //       AppInputSupport(
              //         label: 'Mã số thuế',
              //         hintText: 'Nhập mã số thuế',
              //         initialValue: "123456798",
              //         // onChanged: myBloc.changeName,
              //       ),
              //       gapHeight(sp12),
              //       AppInputSupport(
              //         label: 'Địa chỉ doanh nghiệp ',
              //         hintText: 'Nhập địa chỉ doanh nghiệp ',
              //         initialValue: "48 Tố Hữu, Nam Từ Liêm Hà Nội",
              //         // onChanged: myBloc.changeName,
              //       ),
              //       gapHeight(sp12),
              //       AppInputSupport(
              //         label: 'Số điện thoại doanh nghiệp',
              //         hintText: 'Nhập số điện thoại',
              //         initialValue: "0923430722",
              //         // onChanged: myBloc.changeName,
              //       ),
              //       gapHeight(sp12),
              //       AppInputSupport(
              //         label: 'Loại hình doanh nghiệp',
              //         hintText: 'Nhập số điện thoại',
              //         initialValue: "0923430722",
              //         // onChanged: myBloc.changeName,
              //       ),
              //       gapHeight(sp12),
              //       CommonDropdown(
              //         label: 'Loại hình doanh nghiệp',
              //         items: [
              //           DropdownMenuItem(
              //               value: 1, child: Text('Hộ gia đình', style: p6)),
              //         ],
              //         value: 1,
              //         hintText: 'Chọn loại hình doanh nghiệp',
              //         onChanged: (v) => {},
              //       ),
              // gapHeight(sp12),
              // ])),
              gapHeight(sp12),
            ])),
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
                      largeButton: false,
                      event: () => context.router.pop(),
                      backgroundColor: bg_4,
                      borderColor: borderColor_2)),
              SizedBox(width: 10),
              Expanded(
                  child: MainButton(
                      largeButton: false,
                      title: 'Lưu lại',
                      event: () => context.router.pop()))
            ])));
  }
}
