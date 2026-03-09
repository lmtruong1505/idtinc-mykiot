import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features/address/cubit/location/latlng_by_address_bloc.dart';
import 'package:pharmago/presentation/features/address/cubit/location/location_bloc.dart';
import 'package:pharmago/shared/components/widgets/view_map_by_latlng.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

import '../../../../../../shared/style_app/init_style.dart';
import '../../../../blocs/state/init_state.dart';
import '../../../../../features/address/data/models/location_model.dart';
import '../bg_action.dart';

class TabSubInfoCustomer extends StatefulWidget {
  final CustomerModel customer;
  const TabSubInfoCustomer({
    super.key,
    required this.customer,
  });

  @override
  State<TabSubInfoCustomer> createState() => _TabSubInfoCustomerState();
}

class _TabSubInfoCustomerState extends State<TabSubInfoCustomer>
    with AutomaticKeepAliveClientMixin {
  final latlngBloc = LatlngByAddressBloc();
  final address = BackAddress();

  final titleStyle = StyleApp.normal(color: ColorApp.grey79);
  final contentStyle = StyleApp.semibold();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    address.address = widget.customer.contactAddress?.title;
    address.ward = LocationModel(
      code: widget.customer.contactAddress?.ward?.code,
      title: widget.customer.contactAddress?.ward?.name,
    );
    address.district = LocationModel(
      code: widget.customer.contactAddress?.district?.code,
      title: widget.customer.contactAddress?.district?.name,
    );
    address.province = LocationModel(
      code: widget.customer.contactAddress?.province?.code,
      title: widget.customer.contactAddress?.province?.name,
    );

    if (!address.addressDetail.isEmptyOrNull) {
      latlngBloc.getLatlng(
        address: address.addressDetail!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: sp16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _subInfor(),
          Dimensions.sp16.height,
          _contact(),
          Dimensions.sp16.height,
          _bank(),
          context.padding.bottom.height,
        ],
      ),
    );
  }

  Widget _bank() {
    return BgAction(
      click: true,
      title: 'Thông tin tài khoản ngân hàng',
      child: Container(
        padding: Dimensions.sp16.pading,
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: Dimensions.sp8.radius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextRow2(
              title: 'Số tài khoản',
              content: widget.customer.accountNumber,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            Dimensions.sp8.height,
            TextRow2(
              title: 'Tên ngân hàng',
              content: widget.customer.bankName,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            Dimensions.sp8.height,
            TextRow2(
              title: 'Cơ sở',
              content: widget.customer.bankBranch,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _contact() {
    return BgAction(
      click: true,
      title: 'Thông tin người liên hệ',
      child: Container(
        padding: Dimensions.sp16.pading,
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: Dimensions.sp8.radius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextRow2(
              title: 'Họ và tên người liên hệ',
              content: widget.customer.contactName,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            Dimensions.sp8.height,
            TextRow2(
              title: 'Chức danh người liên hệ',
              content: widget.customer.contactTitle,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            Dimensions.sp8.height,
            TextRow2(
              title: 'Số điện thoại',
              content: widget.customer.contactPhone,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            Dimensions.sp8.height,
            textRow(
              title: 'Email',
              content: widget.customer.contactEmail ?? 'Chưa có thông tin',
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            Dimensions.sp8.height,
            _boxAddress(),
          ],
        ),
      ),
    );
  }

  Widget _boxAddress() {
    return BlocBuilder<LatlngByAddressBloc, CubitState>(
      bloc: latlngBloc,
      builder: (context, state) {
        return Container(
          padding: Dimensions.sp8.pading,
          decoration: BoxDecoration(
            color: ColorApp.greyF2,
            borderRadius: Dimensions.sp8.radius,
          ),
          child: Row(
            children: [
              Container(
                margin: Dimensions.sp16.padingRight,
                height: 75,
                width: 75,
                decoration: BoxDecoration(
                  borderRadius: Dimensions.sp8.radius,
                  border: Border.all(
                    color: ColorApp.white,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: Dimensions.sp8.radius,
                  child: state.status != BlocStatus.loading
                      ? ViewMapByLatLng(
                          latLng: MapLatLng(
                            latlngBloc.lat,
                            latlngBloc.lng,
                          ),
                        )
                      : const BaseLoading(
                          height: 75,
                        ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Địa chỉ',
                      style: StyleApp.medium(
                        color: ColorApp.grey79,
                        fontSize: 12,
                      ),
                    ),
                    Dimensions.sp4.height,
                    Text(
                      address.addressDetail ?? 'Chưa có thông tin',
                      style: StyleApp.medium().copyWith(
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _subInfor() {
    return BgAction(
      click: true,
      title: 'Thông tin thêm',
      child: Container(
        padding: Dimensions.sp16.pading,
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: Dimensions.sp8.radius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextRow2(
              title: 'Số CMND/CCCD',
              content: widget.customer.license,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            Dimensions.sp8.height,
            TextRow2(
              title: 'Ngày cấp',
              content: widget.customer.licenseDate.fomatDefaulft,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            Dimensions.sp8.height,
            TextRow2(
              title: 'Nơi cấp',
              content: widget.customer.issuedBy,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
            Dimensions.sp8.height,
            TextRow2(
              title: 'Xưng hô',
              content: widget.customer.title,
              titleStyle: titleStyle,
              contentStyle: contentStyle,
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
