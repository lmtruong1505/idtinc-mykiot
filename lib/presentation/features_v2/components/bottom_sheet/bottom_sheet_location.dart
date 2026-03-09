import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/features/address/cubit/location/location_bloc.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/main_button.dart';
import '../../../../shared/components/input/input_column.dart';
import '../../../../shared/style_app/init_style.dart';
import '../../blocs/state/init_state.dart';
import '../../../features/address/data/models/location_model.dart';


class BottomSheetLocationPage extends StatefulWidget {
  final BackAddress? value;
  const BottomSheetLocationPage({this.value});
  @override
  State<BottomSheetLocationPage> createState() =>
      _BottomSheetLocationPageState();
}

class _BottomSheetLocationPageState extends State<BottomSheetLocationPage> {
  final bloc = LocationBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getDataDefault(value: widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        final list = bloc.province == null
            ? bloc.provinces
            : bloc.district == null
                ? bloc.districts
                : bloc.wards;
        return Container(
          decoration: BoxDecoration(
            color: ColorApp.white,
            borderRadius: 16.radiusTop,
          ),
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.sp24,
            horizontal: Dimensions.sp16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Chọn vị trí',
                style: StyleApp.semibold(
                  fontSize: 16,
                ),
              ),
              Dimensions.sp16.height,
              Wrap(
                children: [
                  _buildLocation(
                    bloc.province,
                    'Tỉnh/ Thành phố',
                    onTap: () {
                      bloc.setProvince(null);
                    },
                  ),
                  if (bloc.province != null)
                    _buildLocation(
                      bloc.district,
                      'Quận/ Huyện',
                      onTap: () {
                        bloc.setDistict(null);
                      },
                    ),
                  if (bloc.district != null)
                    _buildLocation(
                      bloc.ward,
                      'Phường/ Xã',
                      onTap: () {
                        bloc.setWard(null);
                      },
                    ),
                  if (bloc.ward != null)
                    Padding(
                      padding: Dimensions.sp4.padingVer,
                      child: Text(
                        bloc.address ?? 'Chi tiết',
                        style: StyleApp.medium(
                          color: bloc.address == null
                              ? ColorApp.main
                              : ColorApp.black,
                        ),
                      ),
                    ),
                ],
              ),
              Dimensions.sp16.height,
              if (state.status == BlocStatus.loading && bloc.ward == null)
                const Center(
                  child: BaseLoading(),
                ).expanded(),
              if (state.status == BlocStatus.success && bloc.ward == null)
                ListView.separated(
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) => _buildItem(
                    list[index],
                  ),
                  separatorBuilder: (context, index) => const Divider(
                    height: 0,
                    color: ColorApp.greyE2,
                  ),
                  itemCount: list.length,
                ).expanded(),
              if (bloc.ward != null)
                InputColumn(
                  label: 'Địa chỉ chi tiết',
                  isRequired: true,
                  initialValue: widget.value?.address,
                  padding: EdgeInsets.zero,
                  onChanged: (p0) {
                    bloc.setAddress(p0);
                  },
                ).expanded(),
              if (bloc.address != null)
                MainButtonV2(
                  title: 'Xác nhận',
                  onTap: () {
                    context.pop(
                      result: BackAddress(
                        address: bloc.address,
                        ward: bloc.ward,
                        district: bloc.district,
                        province: bloc.province,
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildItem(LocationModel item) {
    return InkWell(
      onTap: () {
        if (bloc.province == null) {
          bloc.setProvince(item);
          return;
        }
        if (bloc.district == null) {
          bloc.setDistict(item);
          return;
        }
        if (bloc.ward == null) {
          bloc.setWard(item);
          return;
        }
      },
      child: Padding(
        padding: Dimensions.sp12.padingVer,
        child: Text(
          item.title ?? '',
          style: StyleApp.normal(),
        ),
      ),
    );
  }

  Widget _buildLocation(
    LocationModel? item,
    String key, {
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: Dimensions.sp4.padingVer,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item?.title ?? key,
              style: StyleApp.medium(
                color: item == null ? ColorApp.main : ColorApp.black,
              ),
            ),
            if (item != null)
              const Icon(
                Icons.circle,
                color: ColorApp.greyAA,
                size: 5,
              ).padding(6.padingHor),
          ],
        ),
      ),
    );
  }
}
