import 'package:auto_route/auto_route.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:highlight_text/highlight_text.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_item_entity.dart';
import 'package:pharmago/presentation/features/branch/bloc/branch_management_bloc/branch_management_bloc.dart';
import 'package:pharmago/presentation/features/branch/page_v2/companents/bottom_sheets/bts_list_staff.dart';
import 'package:pharmago/presentation/features/company/domain/entities/bank_entity.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/features/company/screen_v2/components/bts_bank.dart';
import 'package:pharmago/presentation/features/employee/employee/domain/entities/employee_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/basic_entity.dart';
import 'package:pharmago/presentation/features_v2/models/employee/user_data_model.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/double_button.dart';
import 'package:pharmago/shared/components/button/icon_btn.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/components/input/drop_column.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/input/range_input.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/components/widgets/avatar_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/components/widgets/icon_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../gen/flutter_assets.dart';
import '../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../features_v2/blocs/menu/menu_company_bloc.dart';
import '../../../features_v2/models/employee/pre_emp_model.dart';
import '../../address/cubit/location/location_bloc.dart';
import '../cubit/company_choose_bloc.dart';
import '../cubit/create_company_cubit/create_company_cubit.dart';
import '../cubit/create_company_cubit/create_company_state.dart';
import '../cubit/work_space/work_space_cubit.dart';
import '../domain/enum/enum_data.dart';
import 'components/hour_mins_formatter.dart';

part 'components/create/build_staff_manage.dart';
part 'components/create/build_address.dart';
part 'components/create/build_time.dart';

@RoutePage()
class CreateWorkspaceScreen extends StatefulWidget {
  final CompanyEntity? company;
  final TypeCreateCompany type;

  const CreateWorkspaceScreen({
    super.key,
    this.company,
    this.type = TypeCreateCompany.company,
  });

  @override
  State<CreateWorkspaceScreen> createState() => _CreateWorkspaceScreenState();
}

class _CreateWorkspaceScreenState extends State<CreateWorkspaceScreen> {
  final bloc = getIt<CreateCompanyCubit>();
  final _keyForm = GlobalKey<FormState>();
  final bankAccName = TextEditingController();
  final bankName = TextEditingController();

  CompanyEntity? get companyData {
    if (widget.company == null) {
      return CompanyEntity(
        name: getIt<CompanyChooseBloc>().company?.name,
        address: getIt<CompanyChooseBloc>().company?.address,
        phone: getIt<CompanyChooseBloc>().company?.phone,
        bankId: getIt<CompanyChooseBloc>().company?.bankId,
        bankName: getIt<CompanyChooseBloc>().company?.bankName,
        accountName: getIt<CompanyChooseBloc>().company?.accountName,
        accountNumber: getIt<CompanyChooseBloc>().company?.accountNumber,
        timeStart: getIt<CompanyChooseBloc>().company?.timeStart,
        timeEnd: getIt<CompanyChooseBloc>().company?.timeEnd,
      );
    }
    return widget.company;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bankName.text = companyData?.bankName ?? '';
    // bankAccName.text = companyData?.accountName ?? '';
    bloc.init(
      company: companyData,
      isBranch: widget.type == TypeCreateCompany.branch,
    );
  }

  backScreen() async {
    if (widget.type == TypeCreateCompany.branch) {
      getIt<BranchManagementBloc>().changeBranchType(
        TypeCompany.fromCode(bloc.state.type?.code ?? companyType ?? ''),
      );
      context.read<MenuCompanyBloc>().getCompanyMenu();
      context.router.popUntil(
        (route) => route.settings.name == ListBranchV2Route.name,
      );
      //context.pop();
    } else {
      getIt<WorkSpaceCubit>().init();
      context.router.popUntil(
        (route) => route.settings.name == ListWorkspaceRoute.name,
      );
      // context.pop();
    }
  }

  PageRouteInfo pushDetailScreen(int id) {
    if (widget.type == TypeCreateCompany.branch) {
      return DetailBranchV2Route(id: id);
    }
    return DetailWpV2Route(id: id);
  }

  Map<String, HighlightedWord> get highlightWords {
    return {
      bloc.state.name: HighlightedWord(
        onTap: () {},
        textStyle: AppStyle.bodyBsSemiBold.copyWith(
          color: AppColors.text_secondary,
        ),
      ),
    };
  }

  Future<void> createWorkspace() async {
    if (_keyForm.currentState?.validate() == true &&
        bloc.state.addressEntity != null) {
      DialogUtils.showLoadingDialog(
        context,
        'Đang tạo ${widget.type.value} vui lòng đợi!',
      );

      final res = await bloc.createCompany(id: widget.company?.id);
      context.pop();
      if (res.code == 200) {
        backScreen();
        ToastCustom.show(
          context,
          title: 'Thành công',
          msg: '${widget.company?.id == null ? "Tạo" : "Chỉnh sửa"} '
              '${widget.type.value} '
              '${bloc.state.name} thành công',
          highlightWords: highlightWords,
          svgIcon:
              widget.type == TypeCreateCompany.branch && widget.company == null
                  ? Assets.iconsBranch
                  : Assets.svgSuccess,
          color: AppColors.ultility_brand_60,
          timeClose: 5.seconds,
          route: pushDetailScreen(res.data?.id ?? widget.company?.id ?? -1),
        );
      } else {
        ToastCustom.show(
          context,
          title: 'Cảnh báo',
          msg: res.message ??
              '${widget.company?.id == null ? "Tạo" : "Chỉnh sửa"} '
                  '${widget.type.value} '
                  '${bloc.state.name} thất bại!',
          highlightWords: highlightWords,
          svgIcon: Assets.svgError,
          color: AppColors.fg_negative,
        );
      }
    } else {
      print(
        !bloc.getTimeStr(bloc.state.timeClose).isTimeOfDay &&
            bloc.state.timeClose == null &&
            bloc.state.timeOpen != null,
      );
      String errorText = 'Vui lòng nhập đầy đủ thông tin';
      if (bloc.state.type == null ||
          bloc.state.phone.isEmptyOrNull ||
          bloc.state.name.isEmptyOrNull) {
        ToastCustom.show(
          context,
          title: 'Cảnh báo',
          msg: errorText,
          highlightWords: highlightWords,
          svgIcon: Assets.svgWarningOutline,
          color: AppColors.ultility_carrot_60,
        );
        return;
      }
      if (bloc.state.addressEntity == null) {
        errorText = 'Vui lòng chọn địa chỉ ${widget.type.value}';
      } else if (!bloc.getTimeStr(bloc.state.timeOpen).isTimeOfDay &&
          bloc.state.timeOpen == null &&
          bloc.state.timeClose != null) {
        errorText = 'Thời gian mở cửa không đúng định đạng';
      } else if (!bloc.getTimeStr(bloc.state.timeClose).isTimeOfDay &&
          bloc.state.timeClose == null &&
          bloc.state.timeOpen != null) {
        errorText = 'Thời gian đóng cửa không đúng định đạng';
      }
      // else if (bloc.state.manager == null) {
      //   errorText = 'Vui lòng chọn quản lý ${widget.type.value}';
      // }

      ToastCustom.show(
        context,
        title: 'Cảnh báo',
        msg: errorText,
        highlightWords: highlightWords,
        svgIcon: Assets.svgWarningOutline,
        color: AppColors.ultility_carrot_60,
      );
    }
  }

  chooseAddress() {
    context
        .pushRoute(
      AddressRoute(
        model: bloc.state.addressEntity != null
            ? BackAddress.mapAddressEntity(bloc.state.addressEntity)
            : null,
      ),
    )
        .then(
      (value) {
        if (value is BackAddress) {
          bloc.updateAddress(
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

  chooseManager() {
    context
        .bottomSheet(
      BtsListStaff(
        value: bloc.state.manager?.id == null
            ? null
            : PreEmpModel(
                userData: UserDataModel(
                  id: bloc.state.manager?.id,
                  fullName: bloc.state.manager?.fullName,
                  avatar: bloc.state.manager?.avatar,
                  phoneNumber: bloc.state.manager?.phoneNumber,
                  code: bloc.state.manager?.code,
                ),
              ),
      ),
    )
        .then(
      (value) {
        if (value is PreEmpModel) {
          bloc.formChange(
            manager: EmployeeEntity(
              id: value.userData?.id,
              fullName: value.userData?.fullName,
              avatar: value.userData?.avatar,
              phoneNumber: value.userData?.phoneNumber,
              code: value.userData?.code,
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg_primary,
      appBar: AppBarCustom(
        title: 'Trở về',
      ),
      bottomNavigationBar: DoubleButton(
        onConfirm: createWorkspace,
        onCancel: () => context.pop(),
      ).container(),
      body: BlocBuilder<CreateCompanyCubit, CreateCompanyState>(
        bloc: bloc,
        builder: (context, state) {
          bankAccName.text = state.nameAccount ?? '';
          return SingleChildScrollView(
            padding: 16.padingVer,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _keyForm,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildIcon(),
                  Padding(
                    padding: 16.padingHor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        16.height,
                        Text(
                          widget.company != null
                              ? 'Chỉnh sửa ${widget.type == TypeCreateCompany.branch ? "cơ sở" : 'Workspace'}'
                              : 'Thêm mới ${widget.type == TypeCreateCompany.branch ? "cơ sở" : 'Workspace'}',
                          style: AppStyle.heading2xl,
                          textAlign: TextAlign.left,
                        ),
                        if (isCAD || widget.type == TypeCreateCompany.company)
                          buildType(state),
                        InputColumn(
                          label: 'Tên ${widget.type.value}',
                          isRequired: true,
                          padding: 16.padingTop,
                          initialValue: state.name,
                          onChanged: (p0) => bloc.formChange(name: p0),
                        ),
                        InputColumn(
                          label: 'Số điện thoại',
                          initialValue: state.phone,
                          isRequired: true,
                          textInputType: TextInputType.phone,
                          padding: 16.padingTop,
                          onChanged: (p0) => bloc.formChange(phone: p0),
                        ),
                        BuildAddress(
                          addressEntity: state.addressEntity,
                          onTap: chooseAddress,
                        ),
                        _buildTime(
                          bloc: bloc,
                          onTap: () => _keyForm.currentState?.validate(),
                        ),
                        if (widget.type == TypeCreateCompany.branch)
                          _buildStaffManager(
                            state: state,
                            onTap: chooseManager,
                          ),
                        InputColumn(
                          label: 'Mã số thuế',
                          initialValue: state.taxCode,
                          textInputType: TextInputType.number,
                          padding: 16.padingTop,
                          onChanged: (p0) => bloc.formChange(taxCode: p0),
                        ),
                        InputColumn(
                          label: 'Số đăng kí nhà thuốc',
                          initialValue: state.taxCode,
                          textInputType: TextInputType.number,
                          padding: 16.padingTop,
                          onChanged: (p0) =>
                              bloc.formChange(registerNumber: p0),
                        ),
                        InputColumn(
                          label: 'Số chứng chỉ hành nghề',
                          initialValue: state.taxCode,
                          textInputType: TextInputType.number,
                          padding: 16.padingTop,
                          onChanged: (p0) =>
                              bloc.formChange(praticeCetificateNumber: p0),
                        ),
                        InputColumn(
                          label: 'Mô tả',
                          minLines: 5,
                          padding: 16.padingTop,
                          initialValue: state.description,
                          onChanged: (p0) => bloc.formChange(description: p0),
                        ),
                        InputColumn(
                          label: 'Mã khách hàng từ KAFA',
                          initialValue: state.kafa,
                          padding: 16.padingTop,
                          onChanged: (p0) => bloc.formChange(kafa: p0),
                        ),
                        buildBank(state),
                        InputColumn(
                          label: 'Số tài khoản',
                          padding: 16.padingTop,
                          initialValue: state.accountNumber,
                          onChanged: bloc.changeAccNumber,
                          // validate: (value) {
                          //   if (value.isEmptyOrNull) {
                          //     return 'Số tài khoản không chính xác';
                          //   }
                          //   return null;
                          // },
                        ),
                        InputColumn(
                          label: 'Tên chủ tài khoản',
                          padding: 16.padingTop,
                          // readOnly: true,
                          // fillColor: AppColors.input_backgroundDisable,
                          hintText: 'Chủ tài khoản',
                          controller: bankAccName,
                          // validate: (value) {
                          //   if (value.isEmptyOrNull) {
                          //     return 'Bạn chưa nhập tên chủ tài khoản';
                          //   }
                          //   return null;
                          // },
                        ),
                        60.height,
                      ],
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

  Widget buildIcon() {
    return Row(
      children: [
        if (widget.company != null)
          Container(
            padding: 6.pading,
            margin: 16.padingLeft,
            decoration: const BoxDecoration(
              color: AppColors.bg_secondary,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(
              Assets.iconsEdit,
            ),
          ),
        if (widget.company == null)
          IconCustom(
            icon: SvgPicture.asset(
              widget.type == TypeCreateCompany.branch
                  ? Assets.iconsBranch
                  : Assets.iconsWokrspaceIcon,
              color: AppColors.bg_primary,
            ),
            color: AppColors.ultility_brand_60,
          ),
      ],
    );
  }

  Widget buildBank(CreateCompanyState state) {
    return InputColumn(
      label: 'Ngân hàng',
      hintText: 'Chọn ngân hàng',
      readOnly: true,
      padding: 16.padingTop,
      controller: bankName,
      suffixIcon: Center(
        child: FaIcon(
          iconCode: 'f0d7',
          type: FaIconType.solid,
        ),
      ).size(height: 16, width: 16),
      onTap: () {
        context
            .bottomSheet(
          BtsBank(
            banks: state.banks,
            bank: state.bank,
          ),
        )
            .then(
          (value) {
            if (value is BankEntity) {
              bankName.text = value.shortName ?? '';
              bloc.changeBank(value);
            }
          },
        );
      },
    );
    // return DropDownColumn<BankEntity>(
    //   label: 'Ngân hàng',
    //   padding: 16.padingTop,
    //   onChanged: (p0) => bloc.changeBank(p0),
    //   value: state.bank,
    //   items: state.banks
    //       .map(
    //         (e) => DropdownMenuItem(
    //           value: e,
    //           child: Text(
    //             e.shortName ?? '',
    //             style: AppStyle.bodyBsMedium,
    //           ),
    //         ),
    //       )
    //       .toList(),
    // );
  }

  Widget buildType(CreateCompanyState state) {
    return DropDownColumn<BasicEntity>(
      label: 'Loại hình',
      isRequired: true,
      padding: 16.padingTop,
      onChanged: (p0) => bloc.formChange(type: p0),
      value: state.type,
      items: state.companyTypes.map(
        (e) {
          final enabled = e.code == TypeCompany.gym.code;
          return DropdownMenuItem(
            value: e,
            enabled: !enabled,
            child: Text(
              e.name ?? '',
              style: !enabled
                  ? AppStyle.bodyBsMedium
                  : AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_disable,
                    ),
            ),
          );
        },
      ).toList(),
    );
  }
}
