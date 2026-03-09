import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pharmago/generated/assets.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/bottom_sheet_custom.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/address/domain/entities/address_entity.dart';
import 'package:pharmago/presentation/features/company/cubit/detail_company_bloc.dart';
import 'package:pharmago/presentation/features/company/cubit/electric_invoice_bloc.dart';
import 'package:pharmago/presentation/features/company/cubit/work_space/work_space_cubit.dart';
import 'package:pharmago/presentation/features/company/data/models/user_serial_model.dart';
import 'package:pharmago/presentation/features/company/domain/entities/company_entity.dart';
import 'package:pharmago/presentation/features/company/screen_v2/components/menu_action_dialog.dart';
import 'package:pharmago/presentation/features/company/widgets/setup_invoice_widget.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/bg/bg_detail.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/components/widgets/chip_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:toastification/toastification.dart';

import '../../../../shared/components/button/icon_btn.dart';
import '../../../../shared/components/button/tab_btn.dart';
import '../../../../shared/components/widgets/label_container.dart';
import '../../../constants/typography.dart';
import '../../../features_v2/screens/service/components/items/item_read_more_text.dart';
import '../cubit/action_company_bloc.dart';
import '../cubit/auth_ws_manager_cubit/auth_ws_manager_cubit.dart';
import '../cubit/auth_ws_manager_cubit/auth_ws_manager_state.dart';
import '../cubit/company_choose_bloc.dart';
import '../cubit/e_invoice_cubit/e_invoice_cubit.dart';
import '../cubit/e_invoice_cubit/e_invoice_state.dart';
import 'components/invoice_attributes_setup_bts.dart';
import 'components/menu_popup.dart';
import 'components/setup_auth_code.dart';
import 'components/workspace_associate.dart';

@RoutePage()
class DetailWpV2Screen extends StatefulWidget {
  final int id;
  const DetailWpV2Screen({
    super.key,
    required this.id,
  });

  @override
  State<DetailWpV2Screen> createState() => _DetailWpV2ScreenState();
}

class _DetailWpV2ScreenState extends State<DetailWpV2Screen>
    with TickerProviderStateMixin {
  final bloc = DetailCompanyBloc();
  final _authWsCubit = getIt.get<AuthWsManagerCubit>();
  final actionBloc = ActionCompanyBloc();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    bloc.getDetail(widget.id);

    _tabController = TabController(length: 4, vsync: this);
    _authWsCubit.getAuthWs(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CompanyChooseBloc, CubitState>(
      bloc: getIt<CompanyChooseBloc>(),
      listener: (context, state) {
        try {
          final data = jsonDecode(state.msg);
          final title = switch (data['status']) {
            'processing' => 'Đang phát hành hoá đơn điện tử',
            'success' => 'Phát hành hoá đơn thành công',
            'failed' => 'Phát hành hoá đơn thất bại',
            Object() => throw UnimplementedError(),
            null => throw UnimplementedError(),
          };
          final color = switch (data['status']) {
            'processing' => yellow_1,
            'success' => green_1,
            'failed' => red_1,
            Object() => throw UnimplementedError(),
            null => throw UnimplementedError(),
          };
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 3),
              margin: const EdgeInsets.all(sp16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(sp16),
              ),
              backgroundColor: color,
              content: Column(
                children: [
                  Text(
                    title,
                    style: s14w500.copyWith(
                      color: AppColors.text_white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.router.push(
                        OrderDetailProdV2Route(
                          id: data['order_id'],
                          isProd: true,
                        ),
                      );
                    },
                    child: Text(
                      'Chi tiết đơn hàng',
                      style: s14w500.copyWith(
                        color: AppColors.blue60,
                        decoration: TextDecoration.underline,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        } catch (e) {}
      },
      listenWhen: (previous, current) => previous.msg != current.msg,
      child: BlocListener<ActionCompanyBloc, CubitState>(
        bloc: actionBloc,
        listener: (context, state) {
          CheckStateBloc.check(
            context,
            state,
            isShowMsg: true,
            success: () {
              getIt<WorkSpaceCubit>().getListCompanies();
              if (state.data == 'remove') {
                context.router.popUntil(
                  (route) => route.settings.name == ListWorkspaceRoute.name,
                );
              } else {
                bloc.getDetail(widget.id);
              }
            },
          );
        },
        child: BlocBuilder<DetailCompanyBloc, CubitState<CompanyEntity>>(
          bloc: bloc,
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.bg_primary,
              appBar: AppBarCustom(
                title: 'Danh sách',
                subTitle: 'Chi tiết Workspace',
                actions: [
                  if (state.data != null)
                    MenuPopupWorkSpace(
                      onTap: (value) {
                        if (value == StatusMenuWorkspace.edit) {
                          context.pushRoute(
                            CreateWorkspaceRoute(
                              company: bloc.state.data,
                            ),
                          );
                          return;
                        }
                        menuActionDialog(
                          context,
                          value: value,
                          title: state.data!.name ?? '',
                          confirm: () {
                            context.pop();
                            if (value == StatusMenuWorkspace.remove) {
                              actionBloc.remove(widget.id);
                              return;
                            }
                            if (value == StatusMenuWorkspace.active) {
                              actionBloc.setActive(widget.id, true);
                              return;
                            }
                            if (value == StatusMenuWorkspace.unActive) {
                              actionBloc.setActive(widget.id, false);
                              return;
                            }
                          },
                        );
                      },
                      isActive: state.data!.status,
                      isDetail: true,
                      child: IconBtn(
                        backgroundColor: AppColors.bg_primary,
                        icon: const Icon(
                          Icons.more_vert,
                          size: 15,
                        ),
                      ),
                    ),
                  16.width,
                ],
              ),
              body: LoadPage(
                state: state,
                height: null,
                errorView: SingleChildScrollView(
                  padding: 16.pading,
                  child: const EmptyContainer(
                    msg: 'Không tìm thấy thông tin Workspace',
                  ).container(
                    boxShadow: AppShadows.elevator0,
                    radius: 16,
                  ),
                ),
                child: BgDetail(
                  child: _buildBodyView.size(
                    height: context.height,
                    width: context.width,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget get _buildBodyView {
    return Column(
      children: [
        Container(
          color: AppColors.white,
          child: TabBar(
            labelStyle: AppStyle.bodyBsMedium.copyWith(height: 1.2),
            labelColor: AppColors.brand,
            unselectedLabelStyle: AppStyle.bodyBsRegular.copyWith(height: 1.2),
            unselectedLabelColor: AppColors.text_tertiary,
            indicatorColor: AppColors.border_brandSolid,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: const EdgeInsets.symmetric(horizontal: sp8),
            controller: _tabController,
            isScrollable: true,
            onTap: (value) {},
            tabs: [
              Tab(
                child: TabBtn(
                  label: 'Thông tin cơ bản',
                ),
              ),
              Tab(
                child: TabBtn(
                  label: 'Hoá đơn điện tử',
                ),
              ),
              Tab(
                child: TabBtn(
                  label: 'Thiết lập nội bộ',
                ),
              ),
              Tab(
                child: TabBtn(
                  label: 'Workspace liên kết',
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildInfo,
              _invoice,
              _authCode,
              _wsAssociate,
            ],
          ),
        ),
      ],
    );
  }

  Widget get _buildInfo {
    return BlocBuilder<DetailCompanyBloc, CubitState<CompanyEntity>>(
      bloc: bloc,
      builder: (context, state) {
        if (state.data == null) {
          return const SizedBox.shrink();
        }
        return SingleChildScrollView(
          padding: 16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ChipCustom(
                    color: state.data!.status
                        ? AppColors.ultility_brand_60
                        : AppColors.ultility_negative_60,
                    title:
                        state.data!.status ? 'Đang hoạt động' : 'Vô hiệu hoá',
                  ),
                ],
              ),
              Text(
                state.data!.name ?? 'Chưa có thông tin',
                style: AppStyle.headingXl.copyWith(
                  color: AppColors.text_secondary,
                  height: 1.5,
                ),
              ),
              4.height,
              Text(
                state.data!.typeName ?? '',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              8.height,
              Text(
                state.data!.address?.formatAddress ?? 'Chưa có thông tin',
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
              4.height,
              Text(
                state.data!.phone ?? 'Chưa có thông tin',
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              const Divider(
                color: AppColors.border_tertiary,
                height: 16,
              ),
              rowText(
                title: 'Nhân sự trực thuộc',
                content: '${state.data!.totalEmployeesOnly ?? 0} thành viên',
              ),
              8.height,
              rowText(
                title: 'Tổng nhân sự',
                content: '${state.data!.totalEmployeesAll ?? 0} thành viên',
              ),
              8.height,
              Row(
                children: [
                  Text(
                    'Giờ mở cửa',
                    style: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ),
                  12.width,
                  RichText(
                    textAlign: TextAlign.right,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: state.data!.timeStart ?? '--:--',
                          style: AppStyle.bodyBsMedium,
                        ),
                        TextSpan(
                          text: ' đến ',
                          style: AppStyle.bodyBsRegular.copyWith(
                            color: AppColors.text_secondary,
                          ),
                        ),
                        TextSpan(
                          text: state.data!.timeEnd ?? '--:--',
                          style: AppStyle.bodyBsMedium,
                        ),
                      ],
                    ),
                  ).expanded(),
                ],
              ),
              8.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mã code',
                    style: p6.copyWith(color: blackColor),
                  ),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(
                        ClipboardData(text: '${state.data!.codeAssociate}'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Đã copy vào clipboard')),
                      );
                    },
                    child: Text(
                      '${state.data!.codeAssociate}',
                      style: s14w500.copyWith(
                        color: AppColors.blue50,
                        decoration: TextDecoration.underline,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
              8.height,
              ItemReadMoreText(
                title: 'Mô tả',
                description: state.data!.description,
              ),
              32.height,
              LabelContainer(title: 'Thông tin Ngân hàng'),
              16.height,
              rowText(
                title: 'Số tài khoản',
                content: state.data!.accountNumber,
              ),
              8.height,
              rowText(
                title: 'Chủ tài khoản',
                content: state.data!.accountName,
              ),
              8.height,
              rowText(
                title: 'Ngân hàng',
                content: state.data!.bankName,
              ),
            ],
          ).container(
            boxShadow: AppShadows.elevator0,
            radius: 16,
          ),
        );
      },
    );
  }

  Widget get _invoice {
    return ElectricInvoiceInfor(
      workspaceId: widget.id,
    );
  }

  Widget get _authCode {
    return SetupAuthCode(
      id: widget.id,
      authWscubit: _authWsCubit,
    );
  }

  Widget get _wsAssociate {
    return WorkspaceAssociate(
      workspace: widget.id,
    );
  }
}

class ElectricInvoiceInfor extends StatefulWidget {
  const ElectricInvoiceInfor({
    super.key,
    required this.workspaceId,
  });

  final int workspaceId;

  @override
  State<ElectricInvoiceInfor> createState() => _ElectricInvoiceInforState();
}

class _ElectricInvoiceInforState extends State<ElectricInvoiceInfor> {
  final bloc = ElectricInvoiceBloc();
  final _eInvoiceCubit = getIt.get<EInvoiceCubit>();
  final key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _eInvoiceCubit
        ..getViettelAccountHandle(
          workspaceId: widget.workspaceId,
        )
        ..listInvoiceAttributesHandle(
          workspace: widget.workspaceId,
        ),
      child: Column(
        children: [
          LabelContainer(title: 'Thông tin Hóa đơn điện tử'),
          16.height,
          // BaseContainer(
          //   padding: 8.pading,
          //   child: Column(
          //     children: [
          //       Row(
          //         children: [
          //           if (bloc.userResponse != null)
          //             SvgPicture.asset(
          //               Assets.notiIconNotiSuccess,
          //               width: 18,
          //               height: 18,
          //             )
          //           else
          //             FaIcon(iconCode: 'e1ce', size: 18),
          //           4.width,
          //           const Text(
          //             'VNPT',
          //             style: s18w500,
          //           ),
          //           const Spacer(),
          //           GestureDetector(
          //             onTap: () async {
          //               final result = await context.router.push(
          //                 SetupElectricInvoiceRoute(user: bloc.userInfor),
          //               );
          //               if (result == true) {
          //                 bloc.getInfor();
          //               }
          //             },
          //             child: BaseContainer(
          //               borderRadius: 999,
          //               padding: 4.pading,
          //               child: Row(
          //                 children: [
          //                   FaIcon(
          //                     iconCode: 'f013',
          //                     type: FaIconType.light,
          //                     size: 14,
          //                     color: AppColors.black,
          //                   ),
          //                   8.width,
          //                   Text(
          //                     'Thiết lập',
          //                     style: s14w400.copyWith(height: 1),
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //       Visibility(
          //         visible: bloc.userResponse != null,
          //         child: Column(
          //           children: [
          //             8.height,
          //             rowText(
          //               title: 'Đơn vị cấp',
          //               content: bloc.userResponse?.organizationCA,
          //             ),
          //             8.height,
          //             rowText(
          //               title: 'Tên chủ sở hữu',
          //               content: bloc.userResponse?.ownCA,
          //             ),
          //             8.height,
          //             rowText(
          //               title: 'Serial chứng thư',
          //               content: bloc.userResponse?.serialNumber,
          //             ),
          //             8.height,
          //             rowText(
          //               title: 'Hiệu lực từ',
          //               content: bloc.userResponse?.validFrom,
          //             ),
          //             8.height,
          //             rowText(
          //               title: 'Hiệu lực đến',
          //               content: bloc.userResponse?.validTo,
          //             ),
          //             8.height,
          //             Visibility(
          //               visible: bloc.userSerials?.isEmpty == true,
          //               child: Row(
          //                 children: [
          //                   LabelButton(
          //                     backgroundColor: AppColors.white,
          //                     border:
          //                         const BorderSide(color: AppColors.brand),
          //                     labelStyle:
          //                         s16w500.copyWith(color: AppColors.brand),
          //                     suffixIcon: const Icon(
          //                       Icons.add,
          //                       color: AppColors.brand,
          //                     ),
          //                     label: 'Thiết lập mẫu hóa đơn',
          //                     onPressed: _onTapSetUpInvoid,
          //                   ).expanded(),
          //                 ],
          //               ).padding(8.padingBottom),
          //             ),
          //             Visibility(
          //               visible: bloc.userSerials?.isNotEmpty == true,
          //               child: Row(
          //                 children: [
          //                   const Text(
          //                     'Mẫu hóa đơn ',
          //                     style: s14w500,
          //                   ),
          //                   const Spacer(),
          //                   GestureDetector(
          //                     onTap: _onTapSetUpInvoid,
          //                     child: BaseContainer(
          //                       borderRadius: 999,
          //                       child: Row(
          //                         children: [
          //                           const Icon(
          //                             Icons.add,
          //                             color: AppColors.black,
          //                           ),
          //                           4.width,
          //                           Text(
          //                             'Thêm mới',
          //                             style: s14w400.copyWith(height: 1),
          //                           ),
          //                         ],
          //                       ).padding(8.padingHor),
          //                     ),
          //                   ),
          //                 ],
          //               ).padding(8.padingBottom),
          //             ),
          //             Visibility(
          //               visible: bloc.userSerials?.isNotEmpty == true,
          //               child: BaseContainer(
          //                 child: Column(
          //                   children: [
          //                     Row(
          //                       children: [
          //                         const Text('Tên', style: s14w400)
          //                             .expanded(flex: 3),
          //                         const Text('Mẫu hóa đơn', style: s14w400)
          //                             .expanded(flex: 2),
          //                         const Text('Mã serial', style: s14w400)
          //                             .expanded(flex: 2),
          //                       ],
          //                     ).padding(8.pading),
          //                     const Divider(
          //                       color: AppColors.black,
          //                       height: 1,
          //                     ),
          //                     ListView.separated(
          //                       padding: EdgeInsetsDirectional.zero,
          //                       shrinkWrap: true,
          //                       physics:
          //                           const NeverScrollableScrollPhysics(),
          //                       itemBuilder: (context, index) {
          //                         final invoice = bloc.userSerials?[index];
          //                         return _invoiceSerialItem(invoice);
          //                       },
          //                       separatorBuilder: (context, index) =>
          //                           const Divider(
          //                         color: AppColors.black,
          //                         height: 1,
          //                       ),
          //                       itemCount: bloc.userSerials?.length ?? 0,
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ],
          //         ),
          //       ),
          //       if (state.status == BlocStatus.loading) const BaseLoading(),
          //     ],
          //   ),
          // ),
          // 16.height,
          BlocBuilder<EInvoiceCubit, EInvoiceState>(
            builder: (context, state) {
              return BaseContainer(
                padding: 8.pading,
                child: Column(
                  children: [
                    Row(
                      children: [
                        if (state.username != null)
                          SvgPicture.asset(
                            Assets.notiIconNotiSuccess,
                            width: 18,
                            height: 18,
                          )
                        else
                          FaIcon(iconCode: 'e1ce', size: 18),
                        4.width,
                        const Text(
                          'VIETTEL',
                          style: s18w500,
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () async {
                            final result = await context.router.push(
                              SetupViettelInvoiceRoute(
                                workspaceId: widget.workspaceId,
                              ),
                            );
                            if (result == true) {
                              _eInvoiceCubit.getViettelAccountHandle(
                                workspaceId: widget.workspaceId,
                              );
                            }
                          },
                          child: BaseContainer(
                            borderRadius: 999,
                            padding: 4.pading,
                            child: Row(
                              children: [
                                FaIcon(
                                  iconCode: 'f013',
                                  type: FaIconType.light,
                                  size: 14,
                                  color: AppColors.black,
                                ),
                                8.width,
                                Text(
                                  'Thiết lập',
                                  style: s14w400.copyWith(height: 1),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Visibility(
                      visible: state.username != null,
                      child: Column(
                        children: [
                          sp12.height,
                          RowItem(
                            title: 'Tài khoản',
                            content: state.username ?? '',
                          ),
                          sp4.height,
                          RowItem(
                            title: 'Mật khẩu',
                            content: state.password ?? '',
                          ),
                          sp16.height,
                          BlocConsumer<EInvoiceCubit, EInvoiceState>(
                            listener: (context, state) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  margin: const EdgeInsets.all(sp16),
                                  backgroundColor: AppColors.green50,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(sp12),
                                  ),
                                  content: Text(
                                    'Danh sách mẫu hoá đơn được cập nhật',
                                    style: s14w500.copyWith(
                                      color: AppColors.text_white,
                                    ),
                                  ),
                                ),
                              );
                            },
                            listenWhen: (previous, current) {
                              return previous.invoiceAttributes !=
                                  current.invoiceAttributes;
                            },
                            builder: (context, state) {
                              return Table(
                                children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: AppColors.border_secondary,
                                      ),
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(sp12),
                                      ),
                                    ),
                                    children: [
                                      const Text(
                                        'Tên',
                                      ).padding(const EdgeInsets.all(sp8)),
                                      const Text(
                                        'Mẫu hoá đơn',
                                      ).padding(const EdgeInsets.all(sp8)),
                                      const Text(
                                        'Mã Serial',
                                      ).padding(const EdgeInsets.all(sp8)),
                                    ],
                                  ),
                                  ...state.invoiceAttributes
                                      .asMap()
                                      .map((i, e) {
                                    return MapEntry(
                                      key,
                                      TableRow(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.border_secondary,
                                          ),
                                          color: i % 2 == 1
                                              ? AppColors.bg_secondary
                                              : AppColors.bg_white,
                                        ),
                                        children: [
                                          Text(
                                            e.name ?? '',
                                          ).padding(const EdgeInsets.all(sp8)),
                                          Text(
                                            e.pattern ?? '',
                                          ).padding(const EdgeInsets.all(sp8)),
                                          Text(
                                            e.serial ?? '',
                                          ).padding(const EdgeInsets.all(sp8)),
                                        ],
                                      ),
                                    );
                                  }).values,
                                ],
                              );
                            },
                          ),
                          sp12.height,
                          ChipDashBorder(
                            onTap: () {
                              InvoiceAttributesSetupBts.show(
                                context,
                                workspace: widget.workspaceId,
                                callBack: (
                                  name,
                                  pattern,
                                  serial,
                                  defaultFlag,
                                ) {
                                  _setupInvoiceAttributesHandle(
                                    name: name,
                                    pattern: pattern,
                                    serial: serial,
                                    workspace: widget.workspaceId,
                                    defaultFlag: defaultFlag,
                                  );
                                },
                              );
                            },
                            color: mainColor,
                            title: 'Thiết lập mẫu hoá đơn',
                            titleStyle: s14w500,
                            suffixIcon: FaIcon(
                              iconCode: '2b',
                              color: mainColor,
                            ).padding(
                              const EdgeInsets.only(
                                left: sp8,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: sp4,
                              horizontal: sp12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    ).padding(const EdgeInsets.all(sp16));
  }

  GestureDetector _invoiceSerialItem(UserSerialModel? invoice) {
    final isSelect = invoice?.defaultFlag == true;
    return GestureDetector(
      onTap: () => _onTapSetUpInvoid(invoice: invoice),
      child: ColoredBox(
        color: isSelect ? AppColors.text_disable : AppColors.white,
        child: Row(
          children: [
            Icon(
              Icons.circle,
              size: 8,
              color: invoice?.defaultFlag == true
                  ? AppColors.brand
                  : AppColors.white,
            ),
            4.width,
            Text(
              invoice?.name ?? '',
              style: s14w400,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ).expanded(flex: 3),
            Text(
              invoice?.pattern ?? '',
              style: s14w400,
              textAlign: TextAlign.center,
            ).expanded(flex: 2),
            Row(
              children: [
                Text(
                  invoice?.serial ?? '',
                  style: s14w400,
                ),
                4.width,
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              ],
            ).expanded(flex: 2),
          ],
        ).padding(8.pading),
      ),
    );
  }

  void _onTapSetUpInvoid({UserSerialModel? invoice}) {
    final showBottomBar = invoice == null;
    showModalBottomSheetCustom(
      context: context,
      body: SetupInvoiceWidget(
        formKey: key,
        invoice: invoice,
        bloc: bloc,
        canInput: showBottomBar,
      ),
      title: '${showBottomBar ? 'Thiết lập' : "Thông tin"} mẫu hóa đơn',
      onConfirm: () {
        final isValid = key.currentState!.validate();
        if (!isValid) {
          return;
        }
        context.pop();
        bloc.createSerial();
      },
      height: heightDevice(context) * 3 / 2,
      showBottomBar: showBottomBar,
    );
  }

  void _setupInvoiceAttributesHandle({
    required String name,
    required String pattern,
    required String serial,
    required int workspace,
    required bool defaultFlag,
  }) async {
    DialogUtils.showLoadingDialog(
      context,
      'Đang thiết lập mẫu hoá đơn',
    );
    _eInvoiceCubit
        .setupInvoiceAttributesHandle(
      name: name,
      pattern: pattern,
      serial: serial,
      workspace: workspace,
      defaultFlag: defaultFlag,
    )
        .then((_) {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    });
  }
}

Widget rowText({
  required String title,
  String? content,
}) =>
    TextRow2(
      title: title,
      content: content,
      crossAxisAlignment: CrossAxisAlignment.start,
      titleStyle: AppStyle.bodyBsRegular.copyWith(
        color: AppColors.text_secondary,
      ),
      contentStyle: content.isEmptyOrNull
          ? AppStyle.bodyBsRegular.copyWith(
              color: AppColors.text_disable,
            )
          : AppStyle.bodyBsMedium,
    );
