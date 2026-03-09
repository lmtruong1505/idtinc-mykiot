import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/features/address/cubit/select_address_cubit/select_address_cubit.dart';
import 'package:pharmago/presentation/features/address/data/models/location_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/components/widgets/dash.dart';

import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/double_button.dart';
import '../../../config/app_style/init_app_style.dart';
import '../cubit/location/location_bloc.dart';

@RoutePage()
class AddressScreen extends StatefulWidget {
  final BackAddress? model;
  const AddressScreen({this.model});
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final bloc = LocationBloc();
  final addressController = TextEditingController();
  final searchAddress = TextEditingController();
  final scroll = ScrollController();
  final _streamController = StreamController<List<LocationModel>>.broadcast();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getDataDefault(value: widget.model);
    addressController.text = widget.model?.address ?? '';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    addressController.dispose();
    searchAddress.dispose();
    scroll.dispose();
    _streamController.close();
    bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_primary,
      appBar: const BaseAppBar(
        title: 'Chọn địa chỉ',
        elevation: 0.5,
      ),
      bottomNavigationBar: DoubleButton(
        onCancel: () {
          context.pop();
        },
        onConfirm: () {
          if (bloc.addressOk) {
            // TODO: geolocation
            context.pop(
              result: BackAddress(
                province: bloc.province,
                district: bloc.district,
                ward: bloc.ward,
                address: bloc.address?.trim(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Vui lòng nhập thông tin địa chỉ'),
                backgroundColor: AppColors.red70,
              ),
            );
          }
        },
      ).container(
        padding: 16.pading + (Platform.isIOS ? 9.padingBottom : 0.pading),
      ),
      body: SingleChildScrollView(
        // padding: 16.pading,
        controller: scroll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildView(),
            BlocBuilder<LocationBloc, CubitState>(
              bloc: bloc,
              builder: (context, state) {
                final list = bloc.district != null
                    ? bloc.wards
                    : bloc.province != null
                        ? bloc.districts
                        : bloc.provinces;
                final title = bloc.district != null
                    ? 'Chọn Phường/Xã'
                    : bloc.province != null
                        ? 'Chọn Quận/Huyện'
                        : 'Chọn Tỉnh/Thành Phố';
                return LoadPage(
                  state: state,
                  listEmpty: list.isEmpty,
                  height: 200,
                  child: bloc.province != null &&
                          bloc.district != null &&
                          bloc.ward != null
                      ? Container()
                      : _buildList(
                          list,
                          title: title,
                          onPressed: (value) {
                            if (bloc.province == null) {
                              bloc.setProvince(value);
                            } else if (bloc.district == null) {
                              bloc.setDistict(value);
                            } else if (bloc.ward == null) {
                              bloc.setWard(value);
                            }
                          },
                        ),
                );
              },
            ),
          ],
        ).container(),
      ),
    );
  }

  Widget _buildList(
    List<LocationModel> list, {
    Function(LocationModel)? onPressed,
    required String title,
  }) {
    groupBy(
      list,
      (p0) => p0.title2![0],
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        24.height,
        AppInputV2(
          hintText: 'Tìm kiếm địa điểm',
          controller: searchAddress,
          radius: 30,
          prefixIcon: const Icon(Icons.search),
          suffixIcon: InkWell(
            onTap: () {
              searchAddress.clear();

              _streamController.sink.add(
                list,
              );
            },
            child: const Icon(
              Icons.close,
              size: 20,
            ),
          ),
          onChanged: (p0) {
            final data = list
                .where(
                  (e) =>
                      e.title!.toLowerCase().contains(
                            p0.toLowerCase(),
                          ) ||
                      e.title2!.toLowerCase().contains(
                            p0.toLowerCase(),
                          ),
                )
                .toList();
            _streamController.sink.add(
              data,
            );
          },
        ),
        12.height,
        Text(
          title,
          style: AppStyle.bodyBsMedium.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        StreamBuilder<List<LocationModel>>(
          stream: _streamController.stream,
          initialData: list,
          builder: (context, snapshot) {
            if (snapshot.data.validator.isEmpty) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'Không tìm thấy địa chỉ',
                    style: AppStyle.normal(),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            final data = groupBy(
              snapshot.data!,
              (p0) => p0.title2![0],
            );
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: data.entries.map(
                (e) {
                  return ListView.separated(
                    itemCount: e.value.length,
                    shrinkWrap: true,
                    padding: 0.pading,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(
                      height: 0,
                    ),
                    itemBuilder: (context, index) => LabelButton(
                      prefixIcon: Text(
                        e.key,
                        style: AppStyle.medium(
                          color:
                              index == 0 ? AppColors.grey60 : AppColors.white,
                        ),
                      ),
                      label: e.value[index].title ?? '',
                      labelStyle: AppStyle.bodyBsMedium,
                      backgroundColor: Colors.transparent,
                      alignment: Alignment.centerLeft,
                      radius: 0.radius,
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        scroll.scrollToTop();
                        searchAddress.clear();
                        onPressed?.call(e.value[index]);
                      },
                    ),
                  );
                },
              ).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _buildView() {
    return BlocBuilder<LocationBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.text_tertiary,
                  size: 16,
                ),
                Text(
                  'Địa điểm được chọn',
                  style: AppStyle.bodyBsMedium.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
                10.width,
                const Divider(
                  height: 0,
                ).expanded(),
                10.width,
                InkWell(
                  onTap: () {
                    bloc.setProvince(null);
                    addressController.clear();
                  },
                  child: Center(
                    child: Text(
                      'Thiết lập lại',
                      style:
                          AppStyle.medium(color: AppColors.brand, fontSize: 12),
                    ),
                  ).size(height: 20),
                ),
              ],
            ),
            8.height,
            Stack(
              children: [
                if (bloc.province == null &&
                    bloc.district == null &&
                    bloc.ward == null)
                  Positioned(
                    left: 13,
                    top: 20,
                    bottom: 20,
                    child: const Dash(
                      color: AppColors.bg_tertiary,
                      direction: Axis.vertical,
                      height: 3,
                      dashWidth: 2,
                    ).size(height: 3 * 40),
                  ),
                if (bloc.province != null &&
                    bloc.district != null &&
                    bloc.ward != null)
                  Positioned(
                    left: 13,
                    top: 20,
                    bottom: 20,
                    child: const VerticalDivider(
                      color: AppColors.bg_tertiary,
                      thickness: 2,
                      width: 0,
                    ).size(height: 3 * 40),
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildStep(
                      isChoose: bloc.province == null,
                      hint: 'Tỉnh/Thành phố',
                      value: bloc.province,
                      onTap: () {
                        addressController.clear();
                        bloc.setProvince(null);
                      },
                    ),
                    _buildStep(
                      isChoose: bloc.district == null && bloc.province != null,
                      hint: 'Quận/Huyện',
                      value: bloc.district,
                      onTap: () {
                        if (bloc.province != null) addressController.clear();
                        {
                          bloc.setDistict(null);
                        }
                      },
                    ),
                    _buildStep(
                      isChoose: bloc.ward == null &&
                          bloc.district != null &&
                          bloc.province != null,
                      hint: 'Phường/Xã',
                      value: bloc.ward,
                      onTap: () {
                        if (bloc.district != null) {
                          addressController.clear();
                          bloc.setWard(null);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            8.height,
            InputColumn(
              label: 'Địa chỉ chi tiết',
              isRequired: true,
          
              padding: EdgeInsets.zero,
              readOnly: !(bloc.ward != null &&
                  bloc.district != null &&
                  bloc.province != null),
              controller: addressController,
              onChanged: bloc.setAddress,
              fillColor: bloc.ward != null &&
                      bloc.district != null &&
                      bloc.province != null
                  ? AppColors.bg_primary
                  : AppColors.input_backgroundDisable,
            ),
          ],
        );
      },
    ).container(boxShadow: AppShadows.elevator1);
  }

  Widget _buildStep({
    bool isChoose = false,
    LocationModel? value,
    required String hint,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            Icons.circle,
            color: isChoose || value != null
                ? AppColors.brand
                : AppColors.bg_tertiary,
            size: 10,
          ),
          10.width,
          Text(
            value?.title ?? hint,
            style: value?.title == null
                ? AppStyle.bodyBsRegular.copyWith(color: AppColors.grey60)
                : AppStyle.bodyBsMedium,
            overflow: TextOverflow.ellipsis,
          ).expanded(),
        ],
      ).container(
        border:
            Border.all(color: isChoose ? AppColors.brand : Colors.transparent),
        bgColor: Colors.transparent,
        padding: 12.padingVer + 8.padingHor,
      ),
    );
  }
}
