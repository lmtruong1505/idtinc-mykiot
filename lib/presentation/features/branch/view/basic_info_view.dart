import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/utils/launch_url.dart';

import '../../../../shared/style_app/color_app.dart';
import '../../../../shared/style_app/style_text.dart';
import '../../../base/date.dart';
import '../../../base/expandable.dart';
import '../bloc/branch_detail_bloc/branch_detail_bloc.dart';
import '../bloc/branch_detail_bloc/branch_detail_state.dart';

class BasicInfoView extends StatefulWidget {
  const BasicInfoView({super.key, required this.myBloc});

  final BranchDetailBloc myBloc;

  @override
  State<BasicInfoView> createState() => _BasicInfoViewState();
}

class _BasicInfoViewState extends State<BasicInfoView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorApp.greyF5,
      child: BlocBuilder<BranchDetailBloc, BranchDetailState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildBranchInfo(state),
                16.height,
                _buildAccountInfo(state),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBranchInfo(BranchDetailState state) {
    return Container(
      decoration: BoxDecoration(
        color: ColorApp.white,
        borderRadius: 8.radius,
      ),
      padding: 16.pading,
      margin: 16.pading,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thông tin cơ sở',
                style: StyleApp.semibold(
                  fontSize: 14,
                  color: ColorApp.grey79,
                ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  borderRadius: 8.radius,
                  color: ColorApp.greenE6,
                ),
                padding: 12.pading,
                alignment: Alignment.center,
                child: Text(
                  'Đang hoạt động',
                  style: StyleApp.semibold(
                    fontSize: 14,
                    color: ColorApp.green,
                  ),
                ),
              ),
            ],
          ),
          16.height,
          RowItem(title: 'Tên cơ sở', content: state.company?.name ?? ''),
          16.height,
          RowItem(
            title: 'Loại cơ sở',
            content: state.company?.type?.title ?? '',
          ),
          16.height,
          RowItem(
            title: 'Quản lý',
            content: state.company?.manager?.fullName ?? '',
          ),
          16.height,
          RowItem(
            title: 'Số điện thoại quản lý',
            content: state.company?.manager?.username ?? '',
          ),
          16.height,
          Row(
            children: [
              const Spacer(),
              InkWell(
                onTap: () => LaunchUrl.phone(
                  state.company?.manager?.username ?? '0',
                ),
                child: Text(
                  'Gọi quản lý',
                  style:
                      StyleApp.semibold(fontSize: 14, color: ColorApp.blue20),
                ),
              ),
            ],
          ),
          16.height,
          RowItem(
            title: 'Số lượng nhân viên',
            content: state.company?.totalStaff.toString() ?? '',
          ),
          16.height,
          RowItem(
            title: 'Vị trí',
            content: state.company?.address?.fullAddress ?? '',
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfo(BranchDetailState state) {
    return Container(
      margin: 16.padingHor,
      child: Expandable(
        header: 'Thông tin tài khoản',
        child: Column(
          children: [
            RowItem(
              title: 'Người tạo',
              content: state.company?.userCreated?.fullName ?? '',
            ),
            16.height,
            RowItem(
              title: 'Thời gian tạo',
              content:
                  Date.formatDateTime(state.company?.userCreated?.createdAt),
            ),
            16.height,
            RowItem(
              title: 'Người cập nhật',
              content: state.company?.userUpdated?.fullName ?? '',
            ),
            16.height,
            const RowItem(
              title: 'Thời gian cập nhật',
              content: '',
            ),
          ],
        ),
      ),
    );
  }
}
