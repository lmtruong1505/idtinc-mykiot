import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/profile_bloc/profile_edit_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/models/profile/profile_model.dart';
import 'package:pharmago/presentation/features_v2/screens/profile/components/image_picker_page.dart';
import 'package:pharmago/presentation/features_v2/screens/profile/components/profile_popup.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/icon_btn.dart';
import '../../../base/dialog.dart';
import '../../../base/v2/text_row.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../router/router.gr.dart';
import '../../blocs/auth/user_bloc.dart';
import '../../blocs/enum/bloc_status.dart';
import '../../blocs/profile_bloc/profile_bloc.dart';
import 'components/header_item.dart';

@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final myBloc = ProfileBloc();

  @override
  void initState() {
    myBloc.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Quản lý cá nhân',
        subTitle: 'Thông tin cá nhân',
        actions: [
          ProfilePopup(
            onTap: (value) {
              switch (value) {
                case ProfileEvent.edit:
                  if (myBloc.state.data != null) {
                    context.router.push(
                      ProfileEditRoute(
                        id: myBloc.state.data!.id ?? -1,
                        onSuccess: () {
                          myBloc.init();
                        },
                      ),
                    );
                  }
                  break;
                case ProfileEvent.changePassword:
                  context.router.push(const ProfileChangePasswordRoute());
                  break;
                case ProfileEvent.changeAvatar:
                  _showActionSheet(context);
                  break;
                case ProfileEvent.inactive:
                  _showInactivePop();
                  break;
              }
            },
            child: IconBtn(
              backgroundColor: AppColors.bg_primary,
              icon: const Icon(
                Icons.more_vert,
                size: 15,
              ),
            ),
          ),
        ],
      ),
      body: BlocListener<ProfileBloc, CubitState<ProfileModel>>(
        bloc: myBloc,
        listener: (context, state) {
          if (state.status != BlocStatus.loading) {
            context.read<UserBloc>().getData();
          }
          if (state.status == BlocStatus.submitSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Cập nhật ảnh đại diện thành công'),
                duration: 1.seconds,
                backgroundColor: AppColors.green50,
              ),
            );
          }
        },
        child: BlocBuilder<ProfileBloc, CubitState<ProfileModel>>(
          bloc: myBloc,
          builder: (context, state) {
            if (state.status == BlocStatus.loading && state.data == null) {
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
        ),
      ),
    );
  }

  Container _buildAvatar() {
    return Container(
      height: 108,
      width: 108,
      decoration: BoxDecoration(
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
        url: myBloc.state.data?.avatar ?? '',
        borderRadius: 999.radius,
        errorWidget: const Icon(
          CupertinoIcons.person,
        ),
      ),
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
        ],
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
        TextRow2(
          title: 'Tên tài khoản',
          content: myBloc.state.data?.fullName ?? '',
          contentStyle: myBloc.state.data?.fullName == null
              ? AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_secondary,
                )
              : null,
        ),
        8.height,
        RowItem(title: 'Mã tài khoản', content: myBloc.state.data?.code ?? ''),
        8.height,
        RowItem(
          title: 'Số điện thoại',
          content: myBloc.state.data?.phoneNumber ?? '',
          contetnColor: myBloc.state.data?.phoneNumber == null
              ? AppColors.text_disable
              : null,
        ),
        8.height,
        RowItem(
          title: 'Email',
          content: myBloc.state.data?.email ?? '',
          contetnColor: (myBloc.state.data?.email == null ||
                  myBloc.state.data!.email!.isEmpty)
              ? AppColors.text_disable
              : null,
        ),
        8.height,
        RowItem(
          title: 'Giới tính',
          content: myBloc.state.data?.gender.getGender.getName ?? '',
          contetnColor: myBloc.state.data?.gender.getGender.getName == null
              ? AppColors.text_disable
              : null,
        ),
        8.height,
        RowItem(
          title: 'Ngày sinh',
          content: myBloc.state.data!.dateOfBirth.fomatDefaulft,
          contetnColor: myBloc.state.data!.dateOfBirth == null
              ? AppColors.text_disable
              : null,
        ),
        8.height,
        RowItem(
          title: 'Địa chỉ',
          content: myBloc.state.data?.address?.fullAddress ?? '',
          contetnColor: myBloc.state.data?.address == null
              ? AppColors.text_disable
              : null,
        ),
        8.height,
        RowItem(
          title: 'Mã số thuế',
          content: myBloc.state.data?.taxNumber ?? '',
          contetnColor: myBloc.state.data?.taxNumber == null
              ? AppColors.text_disable
              : null,
        ),
        8.height,
        RowItem(
          title: 'Số fax',
          content: myBloc.state.data?.faxNumber ?? '',
          contetnColor: myBloc.state.data?.faxNumber == null
              ? AppColors.text_disable
              : null,
        ),
        8.height,
        RowItem(
          title: 'Website',
          content: myBloc.state.data?.website ?? '',
          contetnColor: myBloc.state.data?.website == null
              ? AppColors.text_disable
              : null,
        ),
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
          content: myBloc.state.data?.identifyNumber ?? '',
          contetnColor: myBloc.state.data?.identifyNumber == null
              ? AppColors.text_disable
              : null,
        ),
        8.height,
        RowItem(
          title: 'Ngày cấp',
          content: myBloc.state.data!.providedDate.fomatDefaulft,
          contetnColor: myBloc.state.data?.providedDate == null
              ? AppColors.text_disable
              : null,
        ),
        8.height,
        RowItem(
          title: 'Nơi cấp',
          content: myBloc.state.data?.providedPlace ?? '',
          contetnColor: myBloc.state.data?.providedPlace == null
              ? AppColors.text_disable
              : null,
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
          content: myBloc.state.data?.accountNumber ?? '',
          contetnColor: myBloc.state.data?.accountNumber == null
              ? AppColors.text_disable
              : null,
        ),
        8.height,
        RowItem(
          title: 'Chủ tài khoản',
          content: myBloc.state.data?.accountName ?? '',
          contetnColor: myBloc.state.data?.accountName == null
              ? AppColors.text_disable
              : null,
        ),
        8.height,
        RowItem(
          title: 'Tên ngân hàng',
          content: myBloc.state.data?.bank?.name ?? '',
          contetnColor:
              myBloc.state.data?.bank == null ? AppColors.text_disable : null,
        ),
        8.height,
      ],
    );
  }

  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            context.pop();
          },
          child: Text(
            'Hủy bỏ',
            style: AppStyle.bodyBsSemiBold.copyWith(
              color: AppColors.text_secondary,
            ),
          ),
        ),
        title: Text(
          'Thay đổi ảnh đại diện',
          style: AppStyle.headingMd.copyWith(
            color: AppColors.text_tertiary,
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () async {
              context.pop();
              final image = await ImagePickerPage().pickCropImage(
                aspectRatio: const CropAspectRatio(ratioX: 16, ratioY: 9),
                source: ImageSource.gallery,
              );
              myBloc.setAvt(image).then((value) {
                if (value) {
                  myBloc.init();
                }
              });
            },
            child: Text(
              'Chọn ảnh từ thư viện',
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.text_secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showInactivePop() {
    DialogUtils.showErrorDialog(
      context,
      content:
          'Bạn có chắc chắn vô hiệu hóa tài khoản?\nThao tác này không thể hoàn tác.',
      titleClose: 'Huỷ',
      titleConfirm: 'Xác nhận',
      close: () => Navigator.of(context).pop(),
      accept: () async {
        Navigator.of(context).pop();
        DialogUtils.showLoadingDialog(
          context,
          'Đang vô hiệu hóa tài khoản vui lòng đợi!',
        );
        final res = await myBloc.inActiveAccount();
        Navigator.of(context).pop();
        if (res.code == 200) {
          await DialogUtils.showSuccessDialog(
            context,
            content: 'Vô hiệu hóa tài khoản thành công',
            barrierDismissible: true,
          );
          context.router.replaceAll([const LoginRoute()]);
        } else {
          await DialogUtils.showErrorDialog(
            context,
            content: 'Vô hiệu hóa tài khoản thất bại',
          );
        }
      },
    );
  }
}
