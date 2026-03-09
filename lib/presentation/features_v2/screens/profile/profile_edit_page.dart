import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/features/address/data/models/address_model.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/button/double_button.dart';
import '../../../../shared/components/button/icon_btn.dart';
import '../../../../shared/components/button/label_button.dart';
import '../../../../shared/components/input/drop_column.dart';
import '../../../../shared/utils/delay_callback.dart';
import '../../../base/svg.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../di/di.dart';
import '../../../features/address/cubit/location/location_bloc.dart';
import '../../../features/address/domain/entities/address_item_entity.dart';
import '../../../features/company/domain/entities/bank_entity.dart';
import '../../../router/router.gr.dart';
import '../../blocs/profile_bloc/profile_edit_bloc.dart';
import '../../blocs/state/init_state.dart';
import 'components/header_item.dart';
import 'components/noti_card.dart';

@RoutePage()
class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key, required this.id, this.onSuccess});

  final int id;
  final VoidCallback? onSuccess;

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final myBloc = getIt.get<ProfileEditBloc>();
  final bankAccName = TextEditingController();
  final birthDay = TextEditingController();
  final providedDay = TextEditingController();
  final DelayCallBack delayCallBack = DelayCallBack(delay: 1500.milliseconds);

  OverlayEntry? _overlayEntry;
  final _key = GlobalKey<FormState>();

  void _showOverlay(BuildContext context, String subTitle, bool isSuccess) {
    final color = isSuccess ? AppColors.green50 : AppColors.red50;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: context.padding.bottom,
        left: 16,
        right: 16,
        child: Material(
          elevation: 5.0,
          color: Colors.white,
          borderRadius: 12.radius,
          child: NotiCard(
            title: isSuccess ? 'Thành công' : 'Thất bại',
            subTitle: subTitle,
            icon: Container(
              padding: 4.pading,
              decoration: BoxDecoration(
                border: Border.all(color: color.withOpacity(0.05), width: 1),
                borderRadius: 999.radius,
              ),
              child: Container(
                padding: 4.pading,
                decoration: BoxDecoration(
                  border: Border.all(color: color.withOpacity(0.1), width: 2),
                  borderRadius: 999.radius,
                ),
                child: Icon(
                  Icons.person_outline,
                  color: color,
                ),
              ),
            ),
            close: () {
              _removeOverlay();
            },
          ),
        ),
      ),
    );

    // Insert the overlay entry into the Overlay
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void initState() {
    myBloc.init(widget.id);
    super.initState();
  }

  @override
  void dispose() {
    bankAccName.dispose();
    birthDay.dispose();
    providedDay.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Trở về',
      ),
      body: BlocBuilder<ProfileEditBloc, CubitState>(
        bloc: myBloc,
        builder: (context, state) {
          if (state.status == BlocStatus.loading) {
            return const BaseLoading();
          }
          birthDay.text = myBloc.model?.dateOfBirth?.fomatDefaulft ?? '';
          providedDay.text = myBloc.model?.providedDate.fomatDefaulft ?? '';
          bankAccName.text = myBloc.userBankName ?? '';
          return Form(
            key: _key,
            child: Container(
              padding: 16.pading,
              height: context.height,
              width: context.width,
              decoration: const BoxDecoration(
                color: AppColors.bg_primary,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildHeader(),
                    16.height,
                    _buildBasicInfo(),
                    32.height,
                    _buildCCCD(),
                    32.height,
                    _buildBank(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottom(),
    );
  }

  Container _buildBottom() {
    return Container(
      padding: 16.padingHor + 12.padingTop + 32.padingBottom,
      child: DoubleButton(
        confirmText: 'Lưu lại',
        onConfirm: _handleUpdate,
        onCancel: () {
          context.pop();
        },
      ),
    );
  }

  Column _buildBasicInfo() {
    return Column(
      children: [
        headerItem(
          prefix: IcSvg.asset('/profile_info.svg'),
          title: 'Thông tin chung',
        ),
        16.height,
        InputColumn(
          label: 'Họ và tên',
          isRequired: true,
          initialValue: myBloc.model?.fullName,
          padding: 0.pading,
          onChanged: (value) {
            myBloc.changeInfo(name: value);
          },
        ),
        16.height,
        InputColumn(
          label: 'Số điện thoại',
          isRequired: true,
          initialValue: myBloc.model?.phoneNumber,
          padding: 0.pading,
          textInputType: TextInputType.phone,
          fillColor: AppColors.input_backgroundDisable,
          readOnly: true,
        ),
        16.height,
        CommonDropdown(
          items: List.generate(Gender.values.length, (index) {
            return DropdownMenuItem(
              value: Gender.values[index].code,
              child: Text(Gender.values[index].getName),
            );
          }),
          onChanged: (value) {
            myBloc.changeInfo(gender: value);
          },
          value: myBloc.model?.gender ?? Gender.values.first.code,
          hintText: 'Chọn giới tính',
          showIconRemove: false,
          label: 'Giới tính',
        ),
        16.height,
        InputColumn(
          label: 'Email',
          initialValue: myBloc.model?.email,
          padding: 0.pading,
          onChanged: (value) {
            myBloc.changeInfo(email: value);
          },
        ),
        16.height,
        InputColumn(
          label: 'Ngày sinh',
          padding: 0.pading,
          suffixIcon: const Icon(
            Icons.calendar_month_outlined,
          ),
          controller: birthDay,
          onTap: () {
            showDatePicker(
              context: context,
              firstDate: DateTime(1700),
              lastDate: DateTime.now(),
              initialDate: myBloc.model?.dateOfBirth ?? DateTime.now(),
              currentDate: DateTime.now(),
            ).then(
              (value) {
                if (value is DateTime) {
                  myBloc.changeInfo(dob: value);
                  birthDay.text = value.fomatDefaulft;
                }
              },
            );
          },
        ),
        16.height,
        _buildAddress(),
        16.height,
        InputColumn(
          label: 'Mã số thuế',
          initialValue: myBloc.model?.taxNumber,
          padding: 0.pading,
          onChanged: (value) {
            myBloc.changeInfo(taxNumber: value);
          },
        ),
        16.height,
        InputColumn(
          label: 'Số fax',
          initialValue: myBloc.model?.faxNumber,
          padding: 0.pading,
          onChanged: (value) {
            myBloc.changeInfo(faxNumber: value);
          },
        ),
        16.height,
        InputColumn(
          label: 'Website',
          initialValue: myBloc.model?.website,
          padding: 0.pading,
          onChanged: (value) {
            myBloc.changeInfo(website: value);
          },
        ),
      ],
    );
  }

  Container _buildHeader() {
    return Container(
      width: double.infinity,
      padding: 12.padingVer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.edit,
            color: AppColors.fg_tertiary,
          ).container(
            padding: 12.pading,
            radius: 999,
            bgColor: AppColors.button_brand_solid_textDefault,
          ),
          16.height,
          Text('Chỉnh sửa thông tin cá nhân', style: AppStyle.heading2xl),
        ],
      ),
    );
  }

  Widget _buildAddress() {
    return FormField(
      validator: (value) {
        if (myBloc.model?.address == null) {
          return 'Vui lòng chọn địa chỉ';
        }
        return null;
      },
      builder: (field) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          16.height,
          RichText(
            text: TextSpan(
              text: 'Địa chỉ',
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.input_label,
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_brand_primary_variant2,
                  ),
                ),
              ],
            ),
          ),
          8.height,
          if (myBloc.model?.address == null)
            LabelButton(
              onPressed: _chooseAddress,
              label: 'Chọn địa chỉ',
              backgroundColor: AppColors.bg_primary,
              border: const BorderSide(
                color: AppColors.button_neutral_outlined_borderDefault,
              ),
              labelStyle: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.button_neutral_outlined_textDefault,
              ),
              suffixIcon: myBloc.model?.address != null
                  ? null
                  : const Icon(
                      Icons.add,
                      size: 17,
                      color: AppColors.button_neutral_outlined_textDefault,
                    ),
            ),
          if (myBloc.model?.address != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconBtn(
                  size: const Size(30, 30),
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.location_on_outlined,
                    size: 20,
                  ),
                ),
                8.width,
                Text(
                  myBloc.model?.address?.fullAddress ?? '',
                  style: AppStyle.bodyBsSemiBold,
                ).expanded(),
                16.width,
                IconBtn(
                  onTap: _chooseAddress,
                  size: const Size(24, 24),
                  padding: EdgeInsets.zero,
                  backgroundColor:
                      AppColors.button_neutral_solid_backgroundDefault,
                  icon: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.bg_primary,
                    size: 17,
                  ),
                ),
              ],
            ).container(
              boxShadow: AppShadows.elevator1,
            ),
          if (field.hasError)
            Text(
              field.errorText ?? '',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
              textAlign: TextAlign.start,
            ).padding(8.padingTop),
        ],
      ),
    );
  }

  _chooseAddress() {
    context
        .pushRoute(
      AddressRoute(
        model: myBloc.model?.address != null
            ? BackAddress.mapData(myBloc.model?.address)
            : null,
      ),
    )
        .then(
      (value) {
        if (value is BackAddress) {
          myBloc.updateAddress(
            detail: value.address,
            ward: AddressItemEntity(
              code: value.ward?.code ?? '',
              name: value.ward?.title ?? '',
            ),
            district: AddressItemEntity(
              code: value.district?.code ?? '',
              name: value.district?.title ?? '',
            ),
            province: AddressItemEntity(
              code: value.province?.code ?? '',
              name: value.province?.title ?? '',
            ),
          );
        }
      },
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
        InputColumn(
          label: 'Số CMND/CCCD',
          initialValue: myBloc.model?.identifyNumber,
          padding: 0.pading,
          onChanged: (value) {
            myBloc.changeCCCD(identifyNumber: value);
          },
        ),
        16.height,
        InputColumn(
          label: 'Ngày cấp',
          controller: providedDay,
          suffixIcon: const Icon(
            Icons.calendar_month_outlined,
          ),
          padding: 0.pading,
          onTap: () {
            showDatePicker(
              context: context,
              firstDate: DateTime(1700),
              lastDate: DateTime.now(),
              initialDate: myBloc.model?.providedDate ?? DateTime.now(),
              currentDate: DateTime.now(),
            ).then(
              (value) {
                if (value is DateTime) {
                  myBloc.changeCCCD(providedDate: value);
                  providedDay.text = value.fomatDefaulft;
                }
              },
            );
          },
        ),
        16.height,
        InputColumn(
          label: 'Nơi cấp',
          initialValue: myBloc.model?.providedPlace,
          padding: 0.pading,
          onChanged: (value) {
            myBloc.changeCCCD(providedPlace: value);
          },
        ),
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
        _buildAllBank(),
        InputColumn(
          label: 'Số tài khoản',
          padding: 16.padingTop,
          initialValue: myBloc.userBankNumber,
          onChanged: (value) {
            myBloc.setBankNumber(value);
          },
        ),
        InputColumn(
          label: 'Tên chủ tài khoản',
          padding: 16.padingTop,
          readOnly: true,
          fillColor: AppColors.input_backgroundDisable,
          hintText: 'Chủ tài khoản',
          controller: bankAccName,
        ),
      ],
    );
  }

  Widget _buildAllBank() {
    return DropDownColumn<BankEntity>(
      label: 'Ngân hàng',
      padding: 16.padingTop,
      onChanged: (value) {
        myBloc.setBank(value);
      },
      value: myBloc.bank,
      items: myBloc.banks
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(
                e.shortName ?? '',
                style: AppStyle.bodyBsMedium,
              ),
            ),
          )
          .toList(),
    );
  }

  void _handleUpdate() {
    if (!_key.currentState!.validate()) {
      return;
    }
    if (myBloc.model?.address == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Vui lòng chọn địa chỉ'),
          duration: 1.seconds,
          backgroundColor: AppColors.red60,
        ),
      );
    }
    DialogUtils.showLoadingDialog(context, 'Đang cập nhật...');
    myBloc.updateProfile().then((value) {
      delayCallBack.debounce(() {
        _removeOverlay();
      });
      context.pop();
      if (value.code == 200) {
        _showOverlay(
          context,
          'Thông tin cá nhân được chỉnh sửa thành công',
          true,
        );
        widget.onSuccess?.call();
        context.pop();
      } else {
        _showOverlay(
          context,
          'Thông tin cá nhân được chỉnh sửa thất bại ${kDebugMode ? '(${value.message})' : ''}',
          false,
        );
      }
    });
  }
}
