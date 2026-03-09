import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_item_entity.dart';

import '../cubit/select_address_cubit/select_address_cubit.dart';
import '../cubit/select_address_cubit/select_address_state.dart';

class SelectAddressView extends StatefulWidget {
  const SelectAddressView({
    super.key,
    this.onConfirm,
    this.detail,
    this.district,
    this.province,
    this.ward,
  });

  final AddressItemEntity? province;
  final AddressItemEntity? district;
  final AddressItemEntity? ward;
  final String? detail;
  final Function({
    AddressItemEntity? province,
    AddressItemEntity? district,
    AddressItemEntity? ward,
    String? detail,
  })? onConfirm;

  @override
  State<SelectAddressView> createState() => _SelectAddressViewState();

  static String formatAddress(AddressEntity? address) {
    if (address == null) return '';
    return '${address.detail}, ${address.ward?.name}, '
        '${address.district?.name}, ${address.province?.name}';
  }
}

class _SelectAddressViewState extends State<SelectAddressView> {
  final myBloc = getIt.get<SelectAddressCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SelectAddressCubit>(
      create: (context) => myBloc
        ..getProvince()
        ..init(
          province: widget.province,
          district: widget.district,
          ward: widget.ward,
          detail: widget.detail,
        ),
      child: BlocBuilder<SelectAddressCubit, SelectAddressState>(
        builder: (context, state) {
          return Scaffold(
            body: Container(
              decoration: const BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(sp16),
                ),
              ),
              width: widthDevice(context),
              padding: const EdgeInsets.symmetric(
                vertical: sp24,
                horizontal: sp16,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Chọn vị trí',
                          style: p1.copyWith(color: blackColor),
                        ),
                      ),
                      // const Ic
                      //   Icons.location_on_outlined,
                      //   size: sp20,
                      //   color: mainColor,
                      // ),
                      // gapWidth(sp8),
                      // Text(
                      //   'Sử dụng vị trí hiện tại',
                      //   style: p6.copyWith(color: mainColor),
                      // ),
                    ],
                  ),
                  gapHeight(sp24),
                  SizedBox(
                    width: widthDevice(context),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      children: [
                        InkWell(
                          onTap: () =>
                              myBloc.clearDataAddress(AddressUnit.province),
                          child: Text(
                            state.province?.name ?? 'Tỉnh (Thành phố)',
                            style: p5.copyWith(
                              color: state.province == null
                                  ? mainColor
                                  : blackColor,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: state.province != null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              gapWidth(sp8),
                              const Icon(
                                Icons.circle,
                                size: sp6,
                                color: greyColor,
                              ),
                              gapWidth(sp8),
                              InkWell(
                                onTap: () => myBloc
                                    .clearDataAddress(AddressUnit.district),
                                child: Text(
                                  state.district?.name ?? 'Quận/Huyện',
                                  style: p5.copyWith(
                                    color: state.district == null
                                        ? mainColor
                                        : blackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: state.district != null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              gapWidth(sp8),
                              const Icon(
                                Icons.circle,
                                size: sp6,
                                color: greyColor,
                              ),
                              gapWidth(sp8),
                              InkWell(
                                onTap: () =>
                                    myBloc.clearDataAddress(AddressUnit.ward),
                                child: Text(
                                  state.ward?.name ?? 'Phương(Xã)',
                                  style: p5.copyWith(
                                    color: state.ward == null
                                        ? mainColor
                                        : blackColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: state.ward != null,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              gapWidth(sp8),
                              const Icon(
                                Icons.circle,
                                size: sp6,
                                color: greyColor,
                              ),
                              gapWidth(sp8),
                              Text(
                                state.detail.isEmpty
                                    ? 'Chi tiết'
                                    : state.detail,
                                style: p5.copyWith(color: mainColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  gapHeight(sp24),
                  state.ward == null
                      ? SizedBox(
                          height: 0.9 * heightDevice(context) - 150,
                          child: ListView.separated(
                            controller: myBloc.scrollController,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              final item = state.listAddress[index];
                              final i = state.listAddress.firstWhere(
                                  (e) => e.nameEn![0] == item.nameEn![0]);
                              return InkWell(
                                onTap: () => myBloc.selectAddressItem(item),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: sp16,
                                      child: Visibility(
                                        visible: item.code == i.code,
                                        child: Text(
                                          item.nameEn![0],
                                          style: p6.copyWith(color: greyColor),
                                        ),
                                      ),
                                    ),
                                    gapWidth(sp16),
                                    Text(
                                      item.name ?? '',
                                      style: p6.copyWith(
                                        color: blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) => const Divider(
                              height: sp24,
                            ),
                            itemCount: state.listAddress.length,
                          ),
                        )
                      : AppInput(
                          label: 'Địa chỉ chi tiết',
                          required: true,
                          hintText: 'Nhập địa chỉ chi tiết',
                          borderColor: bg_5,
                          backgroundColor: bg_5,
                          onChanged: myBloc.detailChange,
                        ),
                  const Spacer(),
                  Visibility(
                    visible: state.ward != null,
                    child: SizedBox(
                      width: double.infinity,
                      child: MainButton(
                        title: 'Xác nhận',
                        event: () {
                          ScaffoldMessenger.of(context).clearSnackBars();
                          if (state.detail.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                behavior: SnackBarBehavior.floating,
                                margin: const EdgeInsets.only(
                                  bottom: sp124 - sp24,
                                  left: sp16,
                                  right: sp16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(sp12),
                                ),
                                content: Text(
                                  'vui lòng nhập địa chỉ chi tiết',
                                  style: p5.copyWith(color: whiteColor),
                                ),
                                backgroundColor: yellow_1,
                              ),
                            );
                            return;
                          }
                          widget.onConfirm?.call(
                            province: state.province,
                            district: state.district,
                            ward: state.ward,
                            detail: state.detail,
                          );
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
