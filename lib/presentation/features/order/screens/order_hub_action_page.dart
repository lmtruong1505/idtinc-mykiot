import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../gen/assets.dart';
import '../../../base/button.dart';
import '../../../di/di.dart';
import '../cubit/cubit_hub_cubit/order_hub_cubit.dart';
import '../cubit/cubit_hub_cubit/order_hub_state.dart';

@RoutePage()
class OrderHubActionPage extends StatefulWidget {
  const OrderHubActionPage({
    super.key,
    required this.notiId,
    required this.dataHub,
  });

  final int notiId;
  final Map<dynamic, dynamic> dataHub;

  @override
  State<OrderHubActionPage> createState() => _OrderHubActionPageState();
}

class _OrderHubActionPageState extends State<OrderHubActionPage> {
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
        appBar: const BaseAppBar(title: 'Đơn thuốc HUB'),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _prescription,
                16.height,
                _doctor,
                16.height,
                _patient,
                16.height,
                _products,
              ],
            ),
          ),
        ),
        bottomNavigationBar: _bottomBar,
      ),
    );
  }

  Widget get _prescription {
    return Container(
      child: Stack(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(16).copyWith(top: 32),
            decoration: BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                RowItem2(
                  title: 'Mã đơn thuốc',
                  content: Text(
                    _dataHub.containsKey('Id') ? _dataHub['Id'] : '',
                    style: p5.copyWith(color: blackColor),
                  ),
                  titleStyle: p7.copyWith(color: greyTextColor),
                ),
                4.height,
                RowItem2(
                  title: 'BHYT',
                  content: Text(
                    _dataHub.containsKey('SoTheBHYT')
                        ? _dataHub['SoTheBHYT']
                        : '',
                    style: p5.copyWith(color: blackColor),
                  ),
                  titleStyle: p7.copyWith(color: greyTextColor),
                ),
                4.height,
                RowItem2(
                  title: 'Mã CCHN',
                  content: Text(
                    _dataHub.containsKey('MaCCHN')
                        ? _dataHub['MaCCHN']
                        : 'chưa có',
                    style: p5.copyWith(color: blackColor),
                  ),
                  titleStyle: p7.copyWith(color: greyTextColor),
                ),
                4.height,
                RowItem2(
                  title: 'Địa chỉ',
                  content: Text(
                    '${_dataHub.containsKey('DiaChi') ? _dataHub['DiaChi'] : ''}, ${_dataHub.containsKey('PhuongXa') ? _dataHub['PhuongXa'] : ''}, ${_dataHub.containsKey('QuanHuyen') ? _dataHub['QuanHuyen'] : ''}',
                    style: p5.copyWith(color: blackColor),
                  ),
                  titleStyle: p7.copyWith(color: greyTextColor),
                ),
                4.height,
                RowItem2(
                  title: 'Chẩn đoán',
                  content: Text(
                    _dataHub.containsKey('ChanDoan')
                        ? _dataHub['ChanDoan']
                        : '',
                    style: p5.copyWith(color: mainColor),
                  ),
                  titleStyle: p7.copyWith(color: greyTextColor),
                ),
              ],
            ),
          ),
          Positioned(
            left: 16,
            child: Image.asset(
              Assets.prescription,
              width: 32,
            ),
          ),
        ],
      ),
    );
  }

  Widget get _doctor {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor_2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(Assets.doctor),
          ),
        ),
        title: Text(
          _dataHub.containsKey('BacSiKe') ? _dataHub['BacSiKe'] : '',
          style: p5.copyWith(color: blackColor),
        ),
        subtitle: Text(
          'Khoa: ${_dataHub.containsKey('TenKhoa') ? _dataHub['TenKhoa'] : ''}',
          style: p9.copyWith(color: greyTextColor),
        ),
      ),
    );
  }

  Widget get _patient {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(0),
        leading: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: borderColor_2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(Assets.patient),
          ),
        ),
        title: Text(
          _dataHub.containsKey('TenBenhNhan') ? _dataHub['TenBenhNhan'] : '',
          style: p5.copyWith(color: blackColor),
        ),
        subtitle: Text(
          'SĐT: ${_dataHub.containsKey('DienThoaiBenhNhan') ? _dataHub['DienThoaiBenhNhan'] : ''}',
          style: p9.copyWith(color: greyTextColor),
        ),
      ),
    );
  }

  Widget get _products {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin thuốc trong đơn',
          style: p3.copyWith(color: blackColor),
        ),
        12.height,
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListView.separated(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final e = _dataHub.containsKey('ChiTiets')
                  ? _dataHub['ChiTiets'][index]
                  : {};
              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: borderColor_2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(Assets.drugImg),
                  ),
                ),
                title: Text(
                  e.containsKey('ChiTiets') ? e['ChiTiets'] : '',
                  style: p3.copyWith(color: blackColor),
                ),
                subtitle: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Số lượng: ',
                        style: p9.copyWith(color: greyTextColor),
                      ),
                      TextSpan(
                        text:
                            '${e.containsKey('SoLuong') ? e['SoLuong'] : 0} ${e.containsKey('DonViKe') ? e['DonViKe'] : ''}',
                        style: p5.copyWith(color: mainColor),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: ((_dataHub.containsKey('ChiTiets')
                    ? _dataHub['ChiTiets']
                    : []) as List)
                .length,
          ),
        ),
      ],
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseCheckbox2(
                    value: state.isCommit,
                    onChanged: (_) {
                      _cubit.stateChange(isCommit: !state.isCommit);
                    },
                  ),
                  8.width,
                  Expanded(
                    child: InkWell(
                      onTap: () =>
                          _cubit.stateChange(isCommit: !state.isCommit),
                      child: Text(
                        'Tôi cam kết giao đúng hàng trong đơn thuốc tới bệnh nhân',
                        style: p5.copyWith(color: greyTextColor),
                      ),
                    ),
                  ),
                ],
              ),
              12.height,
              Row(
                children: [
                  Expanded(
                    child: ExtraButton(
                      title: 'Từ chối',
                      event: () {
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
                          if (!mounted) return;
                          if (res?.code != 200) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: yellow_1,
                                content: Text(
                                  'Đơn hàng đã được nhận bởi đơn vị khác',
                                  style: p5.copyWith(color: whiteColor),
                                ),
                              ),
                            );
                          } else {
                            context.router.back();
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
