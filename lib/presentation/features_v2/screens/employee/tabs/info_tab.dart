import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/presentation/features/company/domain/enum/enum_data.dart';
import 'package:pharmago/presentation/features_v2/blocs/employee/emp_information_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/profile_bloc/profile_edit_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/employee/component/working_info_item.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/dialog/dialog_confirm.dart';
import '../../../../../shared/components/dialog/dialog_message.dart';
import '../../../../../shared/utils/launch_url.dart';
import '../../../../base/cache_image.dart';
import '../../../../base/row_item.dart';
import '../../../../base/svg.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../profile/components/header_item.dart';

class InfoTab extends StatelessWidget {
  const InfoTab({
    super.key,
    required this.bloc,
    this.onTerminated,
  });

  final EmpInformationBloc bloc;
  final VoidCallback? onTerminated;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmpInformationBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        if (state.status == BlocStatus.loading) {
          return const Center(
            child: BaseLoading(),
          );
        }
        return Container(
          padding: 16.pading,
          child: Column(
            children: [
              SingleChildScrollView(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildInfo(),
                    Positioned(
                      top: 0,
                      child: _buildAvatar(),
                    ),
                  ],
                ),
              ).expanded(),
            ],
          ),
        );
      },
    );
  }

  Container _buildInfo() {
    return Container(
      padding: 12.pading,
      margin: 54.padingTop,
      decoration: BoxDecoration(
        borderRadius: 16.radius,
        border: Border.all(color: AppColors.bg_secondary),
      ),
      child: Column(
        children: [
          54.height,
          _buildInfoBasic(),
          24.height,
          _buildCCCD(),
          24.height,
          _buildBank(),
          24.height,
          _buildWorkingInfo(),
        ],
      ),
    );
  }

  Container _buildAvatar() {
    return Container(
      height: 108,
      width: 108,
      decoration: BoxDecoration(
        color: AppColors.bg_primary,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.input_backgroundDisable,
          width: 6,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.bg_border1,
            blurRadius: 8,
            offset: Offset(0, 3),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: AppColors.bg_border2,
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: -1,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: BaseCacheImage(
        url: '',
        // url:
        //     'https://hoanghamobile.com/tin-tuc/wp-content/webp-express/webp-images/uploads/2024/03/anh-meme-hai-36.jpg.webp',
        borderRadius: 999.radius,
        errorWidget: const Icon(
          CupertinoIcons.person,
        ),
      ),
    );
  }

  Column _buildInfoBasic() {
    return Column(
      children: [
        headerItem(
          prefix: IcSvg.asset('/profile_info.svg'),
          title: 'Thông tin chung',
        ),
        16.height,
        RowItem(
          title: 'Tên tài khoản',
          content: bloc.model?.userData?.fullName ?? '',
        ),
        8.height,
        RowItem(
          title: 'Mã tài khoản',
          content: bloc.model?.userData?.code ?? '',
        ),
        8.height,
        RowItem2(
          title: 'Số điện thoại',
          content: InkWell(
            onTap: () {
              LaunchUrl.phone(bloc.model?.userData?.phoneNumber ?? '');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  bloc.model?.userData?.phoneNumber ?? '',
                  style: AppStyle.bodyBsMedium.copyWith(
                    color: AppColors.text_hyperlink,
                  ),
                ),
                8.width,
                Container(
                  padding: 3.pading,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.button_neutral_alpha_backgroundDefault
                        .withOpacity(0.05),
                  ),
                  child: const Icon(
                    CupertinoIcons.phone,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
        8.height,
        RowItem(title: 'Email', content: bloc.model?.userData?.email ?? ''),
        8.height,
        RowItem(
          title: 'Giới tính',
          content: bloc.model?.userData?.gender.getGender.getName ?? '',
        ),
        8.height,
        RowItem(
          title: 'Ngày sinh',
          content: bloc.model?.userData?.dateOfBirth.fomatDate2() ?? '',
        ),
        8.height,
        RowItem(
          title: 'Địa chỉ',
          content: bloc.model?.userData?.address?.fullAddress ?? '',
        ),
        8.height,
        RowItem(
          title: 'Mã số thuế',
          content: bloc.model?.userData?.taxNumber ?? '',
        ),
        8.height,
        RowItem(
          title: 'Số fax',
          content: bloc.model?.userData?.faxNumber ?? '',
        ),
        8.height,
        RowItem(title: 'Website', content: bloc.model?.userData?.website ?? ''),
        8.height,
      ],
    );
  }

  Column _buildCCCD() {
    return Column(
      children: [
        headerItem(
          prefix: IcSvg.asset('/profile_cccd.svg'),
          title: 'Căn cước công dân',
        ),
        16.height,
        RowItem(
          title: 'Số CCCD',
          content: bloc.model?.userData?.identifyNumber ?? '',
        ),
        8.height,
        RowItem(
          title: 'Ngày cấp',
          content: bloc.model?.userData?.providedDate.fomatDate2() ?? '',
        ),
        8.height,
        RowItem(
          title: 'Nơi cấp',
          content: bloc.model?.userData?.providedPlace ?? '',
        ),
        8.height,
      ],
    );
  }

  Column _buildBank() {
    return Column(
      children: [
        headerItem(
          prefix: IcSvg.asset('/profile_bank.svg'),
          title: 'Thông tin ngân hàng',
        ),
        16.height,
        RowItem(
          title: 'Số tài khoản',
          content: bloc.model?.userData?.accountNumber ?? '',
        ),
        8.height,
        RowItem(
          title: 'Chủ tài khoản',
          content: bloc.model?.userData?.accountName ?? '',
        ),
        8.height,
        RowItem(
          title: 'Tên ngân hàng',
          content: bloc.model?.userData?.bank?.name ?? '',
        ),
        8.height,
      ],
    );
  }

  RenderObjectWidget _buildWorkingInfo() {
    if (bloc.model?.workingData == null) {
      return const SizedBox();
    }
    return Column(
      children: [
        headerItem(
          prefix: IcSvg.asset('/profile_working.svg'),
          title: 'Thông tin công việc',
        ),
        16.height,
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return WorkingInfoItem(
              model: bloc.model!.workingData![index],
              terminate: () {
                _buildDialog(context, index, EmployeeStatus.terminate, null);
              },
              onChanged: (value) {
                _buildDialog(
                  context,
                  index,
                  value ? EmployeeStatus.active : EmployeeStatus.suspended,
                  value,
                );
              },
            );
          },
          separatorBuilder: (context, index) => const Divider(
            color: AppColors.border_tertiary,
            thickness: 1,
          ),
          itemCount: bloc.model?.workingData?.length ?? 0,
        ),
      ],
    );
  }

  _buildDialog(
    BuildContext context,
    int index,
    EmployeeStatus status,
    bool? active,
  ) {
    context.dialog(
      DialogConfirm(
        title: status == EmployeeStatus.active
            ? 'Kích hoạt nhân viên'
            : 'Vô hiệu hóa nhân viên',
        content: getContent(active, index),
        actionConfirmBorder: status != EmployeeStatus.active,
        colorConfirmBtn: status != EmployeeStatus.active
            ? AppColors.button_negative_outlined_textDefault
            : AppColors.button_brand_solid_backgroundDefault,
        icon: IconDiaLog(
          color: status == EmployeeStatus.active
              ? AppColors.fg_positive.withOpacity(0.1)
              : AppColors.fg_negative.withOpacity(0.1),
          icon: FaIcon(
            type: FaIconType.solid,
            iconCode: active == null
                ? 'f506'
                : active
                    ? 'f00c'
                    : 'f023',
            color: status == EmployeeStatus.active
                ? AppColors.fg_positive
                : AppColors.fg_negative,
            size: 32,
          ),
        ),
        confirm: () {
          context.pop();
          bloc
              .changeStatus(
            bloc.model!.workingData![index].id ?? -1,
            status.code,
          )
              .then((value) {
            if (value.code == 200) {
              if (active == null) {
                onTerminated?.call();
              } else {
                bloc.init(bloc.model!.userData!.id ?? -1);
              }
            } else {
              context.dialog(
                DialogConfirm(
                  title: 'Cảnh báo',
                  content: Text(
                    value.message ?? '',
                    textAlign: TextAlign.center,
                  ),
                  closeLabel: 'Trở lại',
                  isWarning: true,
                  icon: IconDiaLog(
                    color: AppColors.fg_warning.withOpacity(0.1),
                    icon: FaIcon(
                        iconCode: 'f071',
                        color: AppColors.fg_warning,
                        type: FaIconType.solid),
                  ),
                ),
              );
            }
          });
        },
      ),
    );
  }

  Widget getContent(bool? active, int index) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: active == null
            ? 'Bạn có chắc chắn xác nhận hủy yêu cầu thêm nhân viên '
            : active == false
                ? 'Bạn có chắc chắn muốn vô hiệu hóa nhân viên '
                : 'Bạn có chắc chắn muốn ngưng nhân viên ',
        style: AppStyle.bodyBsRegular.copyWith(
          color: AppColors.text_secondary,
        ),
        children: [
          TextSpan(
            text: bloc.model!.userData?.fullName.validator,
            style: AppStyle.bodyBsSemiBold.copyWith(
              color: AppColors.text_secondary,
            ),
          ),
          TextSpan(
            text: active == null ? ' vào ' : ' tại cơ sở ',
            style: AppStyle.bodyBsRegular.copyWith(
              color: AppColors.text_secondary,
            ),
          ),
          TextSpan(
            text: bloc
                .model!.workingData![index].company?.workspaceName.validator,
            style: AppStyle.bodyBsSemiBold.copyWith(
              color: AppColors.text_secondary,
            ),
          ),
          TextSpan(
            text: ' không?',
            style: AppStyle.bodyBsRegular.copyWith(
              color: AppColors.text_secondary,
            ),
          ),
        ],
      ),
    );
  }
}
