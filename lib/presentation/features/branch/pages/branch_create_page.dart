import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/ext/ext_num.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../../base/dialog.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../di/di.dart';
import '../../address/screens/select_address.dart';
import '../../product/widgets/service_create/bts_chose_emp.dart';
import '../bloc/branch_create_bloc/branch_create_bloc.dart';
import '../bloc/branch_create_bloc/branch_create_state.dart';

@RoutePage()
class BranchCreatePage extends StatefulWidget {
  const BranchCreatePage({super.key, this.company});

  final CompanyEntity? company;

  @override
  State<BranchCreatePage> createState() => _BranchCreatePageState();
}

class _BranchCreatePageState extends State<BranchCreatePage> {
  final myBloc = getIt<BranchCreateBloc>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc..init(widget.company),
      lazy: false,
      child: BlocBuilder<BranchCreateBloc, BranchCreateState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: ColorApp.greyF5,
            appBar: AppBar(
              title: Text(
                widget.company == null ? 'Tạo cơ sở' : 'Chỉnh sửa cơ sở',
                style: const TextStyle(
                  color: ColorApp.black,
                ),
              ),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: ColorApp.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              backgroundColor: ColorApp.white,
            ),
            body: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildBody(),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              padding: 16.pading,
              color: ColorApp.white,
              child: MainButton(
                title: widget.company == null ? 'Tạo cơ sở' : 'Xác nhận ',
                event: widget.company == null ? _createBranch : _updateBranch,
              ).size(
                width: double.infinity,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      decoration: BoxDecoration(borderRadius: 8.radius, color: ColorApp.white),
      margin: 16.pading,
      padding: 16.pading,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CommonDropdown(
            items: List.generate(
              myBloc.state.branchType.length,
              (index) => DropdownMenuItem(
                value: myBloc.state.branchType[index],
                child: Text(myBloc.state.branchType[index].title),
              ),
            ),
            hintText: 'Chọn loại hình',
            label: 'Loại hình',
            value: myBloc.state.type,
            required: true,
            onChanged: (value) {
              myBloc.formChange(type: value);
            },
            radius: 8,
          ),
          16.height,
          AppInputSupport(
            hintText: 'Nhập tên cơ sở',
            label: 'Tên cơ sở',
            initialValue: myBloc.state.name,
            required: true,
            onChanged: (value) {
              myBloc.formChange(name: value);
            },
            validate: (value) {
              if (value?.isEmpty ?? true) {
                return 'Vui lòng nhập tên cơ sở';
              }
              return null;
            },
          ),
          16.height,
          BlocBuilder<BranchCreateBloc, BranchCreateState>(
            builder: (context, state) {
              return AppInputSupport(
                controller: TextEditingController(
                  text: SelectAddressView.formatAddress(
                    state.address,
                  ),
                ),
                label: 'Vị trí',
                required: true,
                hintText: 'Chọn vị trí',
                backgroundColor: ColorApp.white,
                borderColor: borderColor_2,
                readOnly: true,
                suffixIcon: const Icon(
                  Icons.location_on_outlined,
                  size: sp20,
                  color: greyColor,
                ),
                maxLines: 1,
                onTap: () => context.bottomSheet(
                  SizedBox(
                    height: 0.9 * heightDevice(context),
                    child: SelectAddressView(
                      onConfirm: myBloc.updateAddress,
                      province: state.address?.province,
                      district: state.address?.district,
                      ward: state.address?.ward,
                      detail: state.address?.detail,
                    ),
                  ),
                ),
                validate: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng chọn vị trí';
                  }
                  return null;
                },
              );
            },
          ),
          16.height,
          BlocBuilder<BranchCreateBloc, BranchCreateState>(
            builder: (context, state) {
              return AppInputSupport(
                required: true,
                controller: TextEditingController(
                  text: state.staffSelected?.fullName ?? '',
                ),
                hintText: 'Quản lý',
                label: 'Chọn quản lý',
                backgroundColor: whiteColor,
                borderColor: borderColor_2,
                suffixIcon: const Icon(
                  Icons.arrow_drop_down,
                ),
                validate: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Vui lòng chọn nhân viên';
                  }
                  return null;
                },
                readOnly: true,
                onTap: () {
                  context.bottomSheet(
                    isScrollControlled: false,
                    BTSChoseEmp(
                      staffSelected: state.staffSelected,
                      onConfirm: (value) {
                        myBloc.selectStaff(value);
                        FocusScope.of(context).unfocus();
                      },
                      onRemove: () {
                        myBloc.selectStaff(null);
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _createBranch() {
    final validate = formKey.currentState!.validate();
    if (!validate) return;
    DialogUtils.showLoadingDialog(context, 'Đang tạo cơ sở vui lòng đợi!');
    myBloc.createCompany().then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        DialogUtils.showSuccessDialog(
          context,
          content: 'Tạo cơ sở thành công',
          titleClose: 'Danh sách',
          titleConfirm: 'Truy cập',
          close: () => context.router.popUntil(
            (route) => route.settings.name == 'BranchManagementRoute',
          ),
          accept: () {
            context.router.popUntil(
              (route) => route.settings.name == 'BranchManagementRoute',
            );
            context.pushRoute(BranchDetailRoute(id: value.data?.id ?? 1));
          },
        );
        return;
      }
      DialogUtils.showErrorDialog(
        context,
        content: 'Tạo WorkSapce thất bại',
      );
    });
  }

  void _updateBranch() {
    final validate = formKey.currentState!.validate();
    if (!validate) return;
    myBloc.updateCompany(widget.company?.id ?? -1).then((value) {
      if (value.code == 200) {
        DialogUtils.showSuccessDialog(
          context,
          content: 'Cập nhật cơ sở thành công',
          titleClose: 'Danh sách',
          titleConfirm: 'Truy cập',
          close: () => context.router.popUntil(
            (route) => route.settings.name == 'BranchManagementRoute',
          ),
          accept: () {
            context.router.popUntil(
              (route) => route.settings.name == 'BranchManagementRoute',
            );
            context.pushRoute(BranchDetailRoute(id: value.data ?? -1));
          },
        );
        return;
      }
      DialogUtils.showErrorDialog(
        context,
        content: 'Cập nhật cơ sở thất bại',
      );
    });
  }
}
