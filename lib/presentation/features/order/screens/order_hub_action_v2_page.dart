import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_custom.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/components/widgets/label_container.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../base/button.dart';
import '../../../di/di.dart';
import '../cubit/cubit_hub_cubit/order_hub_cubit.dart';
import '../cubit/cubit_hub_cubit/order_hub_state.dart';

@RoutePage()
class OrderHubActionV2Page extends StatefulWidget {
  const OrderHubActionV2Page({
    super.key,
    required this.notiId,
    required this.dataHub,
  });

  final int notiId;
  final Map<dynamic, dynamic> dataHub;

  @override
  State<OrderHubActionV2Page> createState() => _OrderHubActionV2PageState();
}

class _OrderHubActionV2PageState extends State<OrderHubActionV2Page> {
  final _cubit = getIt.get<OrderHubCubit>();
  Map<dynamic, dynamic> get _dataHub => widget.dataHub;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderHubCubit>(
      create: (context) => _cubit
        ..stateChange(
          notiId: widget.notiId,
        ),
      child: Scaffold(
        backgroundColor: bg_6,
        appBar: const BaseAppBar(title: 'Đơn thuốc HUB V2'),
        body: BlocBuilder<OrderHubCubit, OrderHubState>(
          builder: (context, state) {
            return Padding(
              padding: 16.pading,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _orderInfor(),
                    16.height,
                    BaseContainer(
                      padding: 8.pading,
                      child: Column(
                        children: [
                          LabelContainer(title: 'Thông tin bác sĩ'),
                          12.height,
                          _item(
                            title: 'Bác sĩ kê đơn',
                            content: _dataHub.containsKey('nhan_vien')
                                ? _dataHub['nhan_vien']['ho_va_ten']
                                : '',
                          ),
                          4.height,
                          _item(
                            title: 'Tên khoa',
                            content: _dataHub.containsKey('phong_ban')
                                ? _dataHub['phong_ban']['ten_phong_ban']
                                : '',
                          ),
                          4.height,
                          _item(
                            title: 'Cơ sở',
                            content: _dataHub.containsKey('thong_tin_benh_vien')
                                ? _dataHub['thong_tin_benh_vien']
                                    ['ten_benh_vien']
                                : '',
                            maxLines: 3,
                          ),
                          4.height,
                          _item(
                            title: 'Mã bệnh viện',
                            content: _dataHub.containsKey('thong_tin_benh_vien')
                                ? _dataHub['thong_tin_benh_vien']
                                    ['ma_benh_vien']
                                : '',
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                    16.height,
                    BaseContainer(
                      padding: 8.pading,
                      child: Column(
                        children: [
                          LabelContainer(title: 'Thông tin bệnh nhân'),
                          12.height,
                          _item(
                            title: 'Tên bệnh nhân',
                            content: _dataHub.containsKey('benh_nhan')
                                ? _dataHub['benh_nhan']['ho_va_ten']
                                : '',
                          ),
                          if (state.isReceive)
                            Column(
                              children: [
                                4.height,
                                _item(
                                  title: 'Giới tính',
                                  content: _dataHub.containsKey('gioi_tinh')
                                      ? _dataHub['gioi_tinh']['label']
                                      : '',
                                ),
                                4.height,
                                _item(
                                  title: 'Số điện thoại',
                                  content: _dataHub.containsKey('benh_nhan')
                                      ? _dataHub['benh_nhan']['dien_thoai']
                                      : '',
                                ),
                                4.height,
                                _item(
                                  title: 'Ngày sinh',
                                  content: _dataHub.containsKey('ngay_sinh')
                                      ? (_dataHub['ngay_sinh'] as String)
                                          .fomatDate2()
                                      : '',
                                ),
                                4.height,
                                _item(
                                  title: 'CCCD',
                                  content: _dataHub.containsKey('so_cccd')
                                      ? _dataHub['so_cccd']
                                      : '',
                                ),
                                4.height,
                                _item(
                                  title: 'Địa chỉ',
                                  content: _dataHub.containsKey('dia_chi')
                                      ? _dataHub['dia_chi']
                                      : '',
                                  maxLines: 3,
                                ),
                              ],
                            )
                          else
                            Padding(
                              padding: 8.padingTop,
                              child: BaseContainer(
                                width: double.infinity,
                                borderColor: AppColors.carrot20,
                                padding: 4.pading,
                                child: Text(
                                  'Thông tin khác của bệnh nhân chỉ hiện sau khi nhận đơn',
                                  style: s12w400.copyWith(
                                    color: AppColors.carrot60,
                                  ),
                                  maxLines: 2,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    DividerCustom().padding(16.pading),
                    const Text(
                      'Thông tin thuốc trong đơn',
                      style: s18w700,
                    ),
                    16.height,
                    if (_dataHub.containsKey('chi_tiet_don_thuoc'))
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final e = (_dataHub['chi_tiet_don_thuoc'] as List)[index];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${index + 1}.',
                                    style: s14w500.copyWith(
                                      color: AppColors.bg_black,
                                    ),
                                  ),
                                  4.width,
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        e.containsKey('ten_thuoc')
                                            ? e['ten_thuoc']
                                            : '',
                                        style: s14w400.copyWith(
                                          color: AppColors.text_primary,
                                        ),
                                      ),
                                      4.height,
                                      RowItem2(
                                        title:
                                            '# ${e.containsKey('ma_thuoc') ? e['ma_thuoc'] : ''}',
                                        content: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Text.rich(
                                            TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${e.containsKey('so_luong') ? e['so_luong'] : ''}',
                                                  style: s12w600.copyWith(
                                                    color: AppColors
                                                        .text_quaternary,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      ' ${e.containsKey('don_vi_ke') ? e['don_vi_ke']['ten_danh_muc'] : ''}',
                                                  style: s12w400.copyWith(
                                                    color: AppColors
                                                        .text_secondary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        titleStyle: s12w600.copyWith(
                                          color: AppColors.text_secondary,
                                        ),
                                      ),
                                    ],
                                  ).expanded(),
                                ],
                              ),
                              4.height,
                              BaseContainer(
                                color: AppColors.bg_primary_active,
                                padding: 8.padingHor + 4.padingVer,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    const Text('Liều dùng: ', style: s14w400),
                                    4.height,
                                    Text(
                                      e.containsKey('lieu_dung')
                                          ? e['lieu_dung']
                                          : 'Chưa có thông tin',
                                      style: s12w400.copyWith(
                                        color: AppColors.text_secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                        separatorBuilder: (context, index) =>
                            DividerCustom().padding(
                          12.padingVer,
                        ),
                        itemCount: (_dataHub['chi_tiet_don_thuoc'] as List).length,
                      ),
                    DividerCustom().padding(12.padingVer),
                    BlocBuilder<OrderHubCubit, OrderHubState>(
                      builder: (context, state) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                BaseCheckbox2(
                                  value: state.isCommit,
                                  onChanged: (_) {
                                    _cubit.stateChange(
                                      isCommit: !state.isCommit,
                                    );
                                  },
                                ),
                                8.width,
                                Expanded(
                                  child: InkWell(
                                    onTap: () => _cubit.stateChange(
                                      isCommit: !state.isCommit,
                                    ),
                                    child: const Text(
                                      'Tôi cam kết có đủ hàng và giao đúng hàng trong đơn thuốc tới bệnh nhân',
                                      style: s14w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        bottomNavigationBar: _bottomBar,
      ),
    );
  }

  BaseContainer _orderInfor() {
    return BaseContainer(
      padding: 8.pading,
      child: Column(
        children: [
          LabelContainer(title: 'Thông tin đơn thuốc'),
          12.height,
          _item(
            title: 'Mã đơn thuốc',
            content: _dataHub.containsKey('ma_don_thuoc')
                ? _dataHub['ma_don_thuoc']
                : '',
            maxLines: 2,
          ),
          4.height,
          _item(
            title: 'BHYT',
            content: _dataHub.containsKey('ma_bhyt')
                ? _dataHub['ma_bhyt']
                : 'Chưa có',
          ),
          4.height,
          _item(
            title: 'Mã CCHN',
            content: _dataHub.containsKey('ma_cchn')
                ? _dataHub['ma_cchn']
                : 'chưa có',
          ),
          4.height,
          _item(
            title: 'Địa chỉ',
            content:
                '${_dataHub.containsKey('dia_chi') ? _dataHub['dia_chi'] : ''}',
            maxLines: 3,
          ),
          4.height,
          _item(
            title: 'Chẩn đoán',
            content:
                _dataHub.containsKey('chan_doan') ? _dataHub['chan_doan'] : '',
            maxLines: 2,
          ),
        ],
      ),
    );
  }

  Widget _item({
    required String title,
    required String? content,
    int? maxLines,
  }) {
    return RowCustom(
      title: title,
      data: content,
      maxLine: maxLines,
      titleStyle: s14w500.copyWith(color: AppColors.text_quaternary),
      dataStyle: s14w500.copyWith(color: AppColors.text_primary),
    );
  }

  Widget get _bottomBar {
    return BlocBuilder<OrderHubCubit, OrderHubState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: whiteColor,
            boxShadow: [
              BoxShadow(
                color: black5o,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ExtraButton(
                      title: 'Bỏ qua',
                      borderRadius: 999,
                      event: () {
                        context.pop();
                        // myBloc.orderHubActionHandler(
                        //   accept: false,
                        //   workspace: getCompany!,
                        //   notiId: item.id!,
                        // );
                      },
                      largeButton: false,
                      icon: null,
                      backgroundColor: whiteColor,
                      borderColor: borderColor_2,
                    ),
                  ),
                  8.width,
                  Expanded(
                    child: MainButton(
                      radius: 999,
                      title: state.isLoadingAction ? '' : 'Nhận đơn',
                      largeButton: false,
                      icon: state.isLoadingAction
                          ? const BaseLoading(
                              color: whiteColor,
                              size: 16,
                            )
                          : null,
                      event: () {
                        _cubit.acceptHandle().then((res) {
                          if (!context.mounted) return;
                          if (res?.code != 200) {
                            // ignore: use_build_context_synchronously
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //   SnackBar(
                            //     behavior: SnackBarBehavior.floating,
                            //     margin: const EdgeInsets.all(12),
                            //     shape: RoundedRectangleBorder(
                            //       borderRadius: BorderRadius.circular(12),
                            //     ),
                            //     backgroundColor: yellow_1,
                            //     content: Text(
                            //       'Đơn hàng đã được nhận bởi đơn vị khác',
                            //       style: p5.copyWith(color: whiteColor),
                            //     ),
                            //   ),
                            // );
                            DialogUtils.showErrorDialog(
                              header: 'Nhận đơn thuốc thất bại!',
                              context,
                              content:
                                  'Đơn thuốc đã có nhà thuốc khác nhận!Vui lòng tìm đơn thuốc khác',
                            );
                          } else {
                            DialogUtils.showSuccessDialog(
                              barrierDismissible: true,
                              context,
                              content:
                                  'Chúc mừng! Bạn đã nhận đơn thuốc thành công. Vui lòng giao đúng thuốc cho khách.',
                            );
                            // context.router.back();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
