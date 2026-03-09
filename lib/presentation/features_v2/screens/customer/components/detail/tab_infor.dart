import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features/address/cubit/location/latlng_by_address_bloc.dart';
import 'package:pharmago/presentation/features/address/cubit/location/location_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features/address/data/models/location_model.dart';
import 'package:pharmago/shared/components/widgets/view_map_by_latlng.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/launch_url.dart';

import 'package:syncfusion_flutter_maps/maps.dart';
import '../../../../../../shared/style_app/init_style.dart';

class TabInforCustomer extends StatefulWidget {
  final CustomerModel customer;
  const TabInforCustomer({required this.customer});

  @override
  State<TabInforCustomer> createState() => _TabInforCustomerState();
}

class _TabInforCustomerState extends State<TabInforCustomer>
    with AutomaticKeepAliveClientMixin {
  final latlngBloc = LatlngByAddressBloc();
  final address = BackAddress();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    address.address = widget.customer.address?.title;
    address.ward = LocationModel(
      code: widget.customer.address?.ward?.code,
      title: widget.customer.address?.ward?.name,
    );
    address.district = LocationModel(
      code: widget.customer.address?.district?.code,
      title: widget.customer.address?.district?.name,
    );
    address.province = LocationModel(
      code: widget.customer.address?.province?.code,
      title: widget.customer.address?.province?.name,
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
      padding: Dimensions.sp16.pading,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _detailInfor(),
          Dimensions.sp16.height,
          _buildCreateUser(),
        ],
      ),
    );
  }

  Widget _detailInfor() {
    final titleStyle = StyleApp.normal(color: ColorApp.grey79);
    final contentStyle = StyleApp.semibold();
    return Container(
      padding: Dimensions.sp16.pading,
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: Dimensions.sp8.radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.customer.fullName ?? '',
                  style: StyleApp.normal(
                    fontSize: 16,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  final String phone = widget.customer.phone ?? '';
                  if (phone.isNotEmpty) {
                    LaunchUrl.phone(phone);
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorApp.greenE6,
                    border: Border.all(
                      color: ColorApp.main,
                    ),
                  ),
                  child: const Icon(
                    Icons.phone,
                    color: ColorApp.main,
                  ),
                ),
              ),
            ],
          ),
          Dimensions.sp8.height,
          TextRow2(
            title: 'Số điện thoại',
            content: widget.customer.phone,
            titleStyle: titleStyle,
            contentStyle: contentStyle,
          ),
          Dimensions.sp8.height,
          TextRow2(
            title: 'Email',
            content: widget.customer.email,
            titleStyle: titleStyle,
            contentStyle: contentStyle,
          ),
          Dimensions.sp8.height,
          TextRow2(
            title: 'Loại khách hàng',
            content: 'Cá nhân',
            titleStyle: titleStyle,
            contentStyle: contentStyle,
          ),
          Dimensions.sp8.height,
          TextRow2(
            title: 'Ngày sinh',
            content: widget.customer.birthday.fomatDefaulft,
            titleStyle: titleStyle,
            contentStyle: contentStyle,
          ),
          Dimensions.sp8.height,
          TextRow2(
            title: 'Giới tính',
            content: widget.customer.gender.toGender.name,
            titleStyle: titleStyle,
            contentStyle: contentStyle,
          ),
          Dimensions.sp8.height,
          _boxAddress(),
        ],
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

  Widget _buildCreateUser() {
    final titleStyle = StyleApp.normal(color: ColorApp.grey79);
    final contentStyle = StyleApp.semibold();
    return Container(
      padding: Dimensions.sp16.pading,
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: Dimensions.sp8.radius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          textRow(
            title: 'Người tạo: ',
            content: widget.customer.userCreated ?? 'Chưa có dữ liệu',
            titleStyle: titleStyle,
            contentStyle: contentStyle,
            textAlign: TextAlign.left,
          ),
          Dimensions.sp16.height,
          textRow(
            title: 'Thời gian tạo: ',
            content: widget.customer.createdAt.fomatDate2(
              fomat: 'HH:mm dd/MM/yyyy',
              parseFormat: "yyyy-MM-dd'T'HH:mm:ss",
              hours: 7,
              defaultReturn: 'Chưa có dữ liệu',
            ),
            titleStyle: titleStyle,
            contentStyle: contentStyle,
            textAlign: TextAlign.left,
          ),
          Dimensions.sp16.height,
          textRow(
            title: 'Người cập nhật: ',
            content: widget.customer.userUpdated ?? 'Chưa có dữ liệu',
            titleStyle: titleStyle,
            contentStyle: contentStyle,
            textAlign: TextAlign.left,
          ),
          Dimensions.sp16.height,
          textRow(
            title: 'Thời gian cập nhật: ',
            content: widget.customer.updateAt.fomatDate2(
              fomat: 'HH:mm dd/MM/yyyy',
              parseFormat: "yyyy-MM-dd'T'HH:mm:ss",
              hours: 7,
              defaultReturn: 'Chưa có dữ liệu',
            ),
            titleStyle: titleStyle,
            contentStyle: contentStyle,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
