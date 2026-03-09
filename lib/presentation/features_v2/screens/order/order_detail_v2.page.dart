import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/presentation/base/bottom_sheet_custom.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/config/role/permission/index.dart';
import 'package:pharmago/presentation/config/role/role_enum.dart';
import 'package:pharmago/presentation/constants/asset_path.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/features/company/cubit/create_company_cubit/create_company_state.dart';
import 'package:pharmago/presentation/features/company/data/models/user_serial_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/order/exprort_invoice_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/models/order/order_detail_v2_model.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/app_switch.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../gen/assets.dart';
import '../../../../shared/components/button/icon_btn.dart';
import '../../../../shared/components/dialog/dialog_confirm.dart';
import '../../../../shared/components/dialog/dialog_message.dart';
import '../../../../shared/components/toast/toast_custom.dart';
import '../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../../shared/components/widgets/fa_icon.dart';
import '../../../../shared/constants/pref_key.dart';
import '../../../base/button.dart';
import '../../../base/svg.dart';
import '../../../base/v2/text_row.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../config/role/check_role_per.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../di/di.dart';
import '../../../features/company/cubit/company_choose_bloc.dart';
import '../../../features/company/screen_v2/components/menu_action_dialog.dart';
import '../../../features/company/screen_v2/components/menu_popup.dart';
import '../../../features/home/cubit/nav_home_bloc.dart';
import '../../blocs/order/order_detail_v2_bloc.dart';
import '../../blocs/order_v2/order_manager_bloc.dart';
import 'components/bts/bts_create_payment.dart';
import 'components/bts/bts_order_prescription.dart';
import 'components/dialog_confirm_deliver.dart';
import 'components/order_preview_card.dart';
import 'components/popup_order_info.dart';

@RoutePage()
class OrderDetailProdV2Page extends StatefulWidget {
  const OrderDetailProdV2Page({
    super.key,
    required this.id,
    required this.isProd,
  });

  final int id;
  final bool isProd;

  @override
  State<OrderDetailProdV2Page> createState() => _OrderDetailProdV2PageState();
}

class _OrderDetailProdV2PageState extends State<OrderDetailProdV2Page> {
  final bloc = OrderDetailV2Bloc();
  final exportInvoiceBloc = getIt<ExprortInvoiceBloc>();

  late ExpandableController _expandableEarnPointCtl;
  late ExpandableController _expandableUsedPointCtl;

  @override
  void initState() {
    super.initState();
    final bool prodRole = checkRole(RoleBaseEnum.PHARMACIST);
    final bool serviceRole =
        checkRole(RoleBaseEnum.DOCTOR) || checkRole(RoleBaseEnum.NURSE);
    final bool baseRole =
        isOwnerWsCsMn || checkRole(RoleBaseEnum.ACCOUNTANT_CASHIER);
    final bool additionalRoles = (widget.isProd ? prodRole : serviceRole);

    canEdit = baseRole || additionalRoles;

    canDelete = (baseRole || additionalRoles) &&
        checkPermission(PerOrderEnum.DELETE.code);

    canSendZalo = (baseRole || additionalRoles);

    canConfirmTransport = (baseRole || (widget.isProd ? prodRole : false)) &&
        checkPermission(PerOrderEnum.CONFIRM_TRANSPORT.code);

    canPayment = (baseRole || (widget.isProd ? prodRole : false)) &&
        checkPermission(PerOrderEnum.CONFIRM_CHECKOUT.code);

    exportInvoiceBloc.getListSerial();

    _expandableEarnPointCtl = ExpandableController(initialExpanded: false)
      ..addListener(() {
        setState(() {});
      });

    _expandableUsedPointCtl = ExpandableController(initialExpanded: false)
      ..addListener(() {
        setState(() {});
      });
  }

  late bool canEdit;
  late bool canDelete;
  late bool canConfirmTransport;

  late bool canSendZalo;

  late bool canPayment;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderDetailV2Bloc>(
          create: (context) => bloc..getDetail(widget.id),
        ),
        BlocProvider<ExprortInvoiceBloc>(
          create: (context) => exportInvoiceBloc,
        ),
      ],
      child: BlocListener<CompanyChooseBloc, CubitState>(
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
              'processing' => yellow_2,
              'success' => green_2,
              'failed' => red_2,
              Object() => throw UnimplementedError(),
              null => throw UnimplementedError(),
            };
            final colorTitle = switch (data['status']) {
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: s14w500.copyWith(
                        color: colorTitle,
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
                        style: s12w500.copyWith(
                          color: AppColors.blue50,
                          decoration: TextDecoration.underline,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            if (data['order_id'] == widget.id) {
              bloc.getDetail(widget.id);
            }
          } catch (e) {}
        },
        listenWhen: (previous, current) => previous.msg != current.msg,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBarCustom(
            subTitle: 'Chi tiết đơn hàng',
            title: 'Quản lý đơn hàng',
            actions: [_buildMenu()],
          ),
          body: Container(
            padding: const EdgeInsets.all(sp16),
            height: heightDevice(context),
            width: widthDevice(context),
            child: BlocConsumer<OrderDetailV2Bloc, CubitState>(
              builder: (context, state) {
                print('=======OrderDetailV2Bloc build lager');
                if (state.status == BlocStatus.loading) {
                  return const BaseLoading();
                }
                return Container(
                  width: widthDevice(context),
                  padding: const EdgeInsets.all(sp16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(sp16),
                    border: Border.all(color: borderColor_2),
                  ),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _info,
                        _confirmDeliver,
                        gapHeight(sp12),
                        _sendZalo,
                        gapHeight(12),
                        _dataSynchronization(),
                        gapHeight(sp24),
                        DividerCustom(),
                        _servicesView,
                        _productsView,
                        _productsExchangePoints,
                        gapHeight(sp24),
                        _paymentView,
                        gapHeight(sp24),
                        DividerCustom(),
                        gapHeight(sp24),
                        _noteView,
                        _prescription,
                      ],
                    ),
                  ),
                );
              },
              listener: (context, state) {
                if (state.status == BlocStatus.submit) {
                  print('=====BlocStatus.submit');
                  context.pop();
                }
                // _orderDetailListener(state);
              },
            ),
          ),
          bottomNavigationBar: BlocBuilder<OrderDetailV2Bloc, CubitState>(
            builder: (context, state) {
              return _bottomView;
            },
          ),
        ),
      ),
    );
  }

  Widget _dataSynchronization() {
    final order = bloc.order;
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            final status = order?.redInvoiceStatus;
            if (status == 'not_created' ||
                status == 'failed' ||
                status.isEmptyOrNull == true) {
              showModalBottomSheetCustom(
                context: context,
                body: ExportInvoiceBottomSheet(
                  bloc: exportInvoiceBloc,
                  onChanged: bloc.selectInvoice,
                ),
                confirmTitle: 'Phát hành',
                title: 'Phát hành HĐĐT',
                onConfirm: bloc.createRedInvoice,
              );
            } else if (status == 'success') {
              DialogUtils.showLoadingDialog(
                context,
                'Đang phát hành hoá đơn',
              );
              bloc.pdfRedInvoiceHandle().then((code) {
                Navigator.of(context).pop();
                if (code == 200) {
                  DialogUtils.showSuccessDialog(
                    context,
                    content: 'Hoá đơn đã được tải về máy',
                    barrierDismissible: true,
                  );
                } else {
                  DialogUtils.showErrorDialog(
                    context,
                    content: 'Hệ thống quá tải, vui lòng thử lại',
                  );
                }
              });
            }
          },
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: 12.radius),
            child: Row(
              children: [
                Text(
                  statusRedInvoice(order?.redInvoiceStatus),
                  style: s12w500,
                ),
                const Spacer(),
                _statusIcon(order?.redInvoiceStatus),
              ],
            ).padding(12.pading),
          ),
        ).expanded(),
        8.width,
        GestureDetector(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: 12.radius),
            child: Row(
              children: [
                const Text(
                  'Đồng bộ CSDL',
                  style: s12w500,
                ),
                const Spacer(),
                _statusIcon(order?.redInvoiceStatus),
              ],
            ).padding(12.pading),
          ),
        ).expanded(),
      ],
    );
  }

  String statusRedInvoice(String? status) {
    switch (status) {
      case 'not_created':
        return 'Phát hành HĐ';
      case 'waiting':
        return 'Chờ xử lý HĐ';
      case 'processing':
        return 'Đang phát hành HĐ';
      case 'success':
        return 'In hóa đơn';
      case 'failed':
        return 'Phát hành lại HĐ';
      default:
        return 'Phát hành HĐ';
    }
  }

  Color bgRedInvoice(String? status) {
    switch (status) {
      case 'not_created':
        return AppColors.ultility_carrot_20;
      case 'waiting':
        return AppColors.blue20;
      case 'processing':
        return AppColors.blue20;
      case 'success':
        return AppColors.green20;
      case 'failed':
        return AppColors.red20;
      default:
        return AppColors.ultility_carrot_20;
    }
  }

  Widget iconInvoice(String? status) {
    switch (status) {
      case 'not_created':
        return FaIcon(
          iconCode: 'e09a',
          size: 14,
          color: AppColors.ultility_carrot_60,
        );
      case 'waiting':
        return const BaseLoadingV2(
          height: 20,
          color: AppColors.blue60,
        );
      case 'processing':
        return const BaseLoadingV2(
          height: 20,
          color: AppColors.blue60,
        );
      case 'success':
        return FaIcon(
          iconCode: 'f02f',
          size: 14,
          color: AppColors.brand,
        );
      case 'failed':
        return FaIcon(
          iconCode: 'f366',
          color: AppColors.red60,
          size: 14,
        );
      default:
        return FaIcon(
          iconCode: 'e09a',
          size: 14,
          color: AppColors.ultility_carrot_60,
        );
    }
  }

  CircleAvatar _statusIcon(String? status) {
    final icon = iconInvoice(status);
    return CircleAvatar(
      backgroundColor: bgRedInvoice(status),
      radius: 15,
      child: icon,
    );
  }

  Widget get _info {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(sp4),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor_5, width: sp2),
              borderRadius: BorderRadius.circular(sp8),
            ),
            child: Column(
              children: [
                Text(
                  'Quét mã để thanh toán',
                  style: p7.copyWith(color: greyTextColor),
                ),
                bloc.order?.qr != null
                    ? BaseCacheImage(
                        url: bloc.order?.qr ?? '',
                        height: 160,
                      )
                    : SizedBox(
                        height: 160,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.support_agent_rounded,
                              color: greyTextColor,
                            ),
                            gapHeight(sp4),
                            Text(
                              'Chưa hỗ trợ tạo mã, vui lòng liên hệ Quản trị viên',
                              textAlign: TextAlign.center,
                              style: p9.copyWith(color: greyTextColor),
                            ),
                          ],
                        ),
                      ),
                InkWell(
                  onTap: () {
                    context.router.push(
                      //OrderBillRoute(order: bloc.order!),
                      PrintInvoiceV2Route(order: bloc.order!),
                      // PrintOrderWifiRoute(order: bloc.order!),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'In đơn',
                        style: p5.copyWith(color: blackColor),
                      ),
                      gapWidth(sp4),
                      const Icon(
                        Icons.print_outlined,
                        color: greyTextColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        gapWidth(sp16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('hh:mm ∙ dd/M/y')
                    .format(bloc.order?.createdAt ?? DateTime.now()),
                style: p6.copyWith(color: greyColor),
              ),
              gapHeight(sp4),
              typeWidget(bloc.order?.type ?? 'product'),
              gapHeight(sp4),
              Text(
                '#${bloc.order?.code}',
                style: p3.copyWith(color: greyTextColor),
              ),
              gapHeight(sp4),
              Text(
                'Khách hàng',
                style: p9.copyWith(color: greyTextColor),
              ),
              gapHeight(sp2),
              Text(
                bloc.order?.customer?.prefixName ?? 'Chưa có thông tin',
                style: p5.copyWith(color: greyTextColor),
              ),
              gapHeight(sp2),
              Text(
                bloc.order?.customer?.phone ?? 'Chưa có thông tin',
                style: p6.copyWith(color: greyTextColor),
              ),
              gapHeight(sp4),
              Text(
                'Thu ngân',
                style: p9.copyWith(color: greyTextColor),
              ),
              gapHeight(sp2),
              Text(
                bloc.order?.userCreated?.fullName ?? 'Chưa có thông tin',
                style: p5.copyWith(color: greyTextColor),
              ),
              gapHeight(sp2),
              Text(
                bloc.order?.userCreated?.phoneNumber ?? 'Chưa có thông tin',
                style: p6.copyWith(color: greyTextColor),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget get _confirmDeliver {
    if (bloc.order?.type == 'service') return 0.height;
    if (bloc.order?.isDelivered ?? false) {
      return Container(
        margin: const EdgeInsets.only(top: sp16),
        padding: const EdgeInsets.all(sp12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(sp12),
          color: greyFF4,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: sp12,
              backgroundColor: mainColor.withOpacity(0.1),
              child: const Icon(
                Icons.description_rounded,
                color: mainColor,
                size: sp16,
              ),
            ),
            gapWidth(sp8),
            Text(
              'Đã giao hàng',
              style: p7.copyWith(color: mainColor),
            ),
            const Spacer(),
            const Icon(
              Icons.check_circle_rounded,
              color: mainColor,
              size: sp16,
            ),
          ],
        ),
      );
    }
    return InkWell(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(top: sp16),
        padding: const EdgeInsets.symmetric(horizontal: sp12),
        decoration: BoxDecoration(
          border: Border.all(color: mainColor),
          borderRadius: BorderRadius.circular(sp12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: sp12,
              backgroundColor: mainColor.withOpacity(0.1),
              child: const Icon(
                Icons.description_rounded,
                color: mainColor,
                size: sp16,
              ),
            ),
            gapWidth(sp8),
            Text(
              'Xác nhận đã giao hàng',
              style: p7.copyWith(color: mainColor),
            ),
            const Spacer(),
            MainButton(
              radius: sp24,
              title: 'Xác nhận',
              largeButton: false,
              event: canConfirmTransport
                  ? () {
                      showDialog(
                        context: context,
                        builder: (context) => DialogConfirmDeliver(
                          onConfirm: _updateStatusDeliver,
                        ),
                      );
                    }
                  : context.permissionDenied(),
            ),
          ],
        ),
      ),
    );
  }

  Widget get _sendZalo {
    final sendZalooa = bloc.order?.sendZalooa == true;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: sp12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor_2),
        borderRadius: BorderRadius.circular(sp12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: sp12,
            backgroundColor: mainColor.withOpacity(0.1),
            child: SvgPicture.asset(
              '${AssetsPath.icon}/ic_zalo.svg',
              colorFilter: sendZalooa
                  ? null
                  : const ColorFilter.mode(
                      AppColors.grey50,
                      BlendMode.modulate,
                    ),
            ),
          ),
          gapWidth(sp8),
          Text(
            'Gửi hóa đơn bán lẻ qua Zalo',
            style: p7.copyWith(color: greyTextColor),
          ),
          Visibility(
            visible: sendZalooa,
            child: Container(
              margin: const EdgeInsets.only(left: sp12),
              child: const Icon(
                Icons.check_circle,
                color: mainColor,
                size: sp16,
              ),
            ),
          ),
          const Spacer(),
          if (sendZalooa)
            BlocBuilder<OrderDetailV2Bloc, CubitState>(
              bloc: bloc,
              builder: (context, state) => state.status == BlocStatus.reload
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: BaseLoading(),
                    )
                  : SupportButton(
                      title: 'Gửi lại',
                      largeButton: false,
                      event: canSendZalo
                          ? bloc.sendZaloOa
                          : context.permissionDenied(),
                      icon: null,
                      backgroundColor: bg_5,
                      radius: sp24,
                    ),
            )
          else
            42.height,
        ],
      ),
    );
  }

  Widget get _servicesView {
    if (bloc.order?.type != 'service') {
      return 0.height;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gapHeight(sp24),
        const Text(
          'Danh sách dịch vụ',
          style: p1,
        ),
        gapHeight(sp16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = bloc.order?.services[index];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}. ',
                  style: p5.copyWith(color: greyTextColor),
                ),
                gapWidth(sp8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(sp4),
                  child: BaseCacheImage(
                    url: item?.service?.images?.firstOrNull ?? '',
                    width: sp48,
                    height: sp48,
                  ),
                ),
                gapWidth(sp16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item?.service?.title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: p9.copyWith(color: greyTextColor),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'SL: ',
                          style: p6.copyWith(color: greyTextColor),
                          children: [
                            TextSpan(
                              text: '${item?.quantity} ',
                              style: p5.copyWith(color: blackColor),
                            ),
                            TextSpan(
                              text: item?.service?.price?.priceNameSub ?? '',
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            '${FormatCurrency(item?.price)} đ',
                            style: p5.copyWith(color: blackColor),
                          ),
                          gapWidth(sp8),
                          Visibility(
                            visible: item?.discountPrice != 0,
                            child: Text(
                              ' - ${FormatCurrency(item?.discountPrice)} đ',
                              style: p9.copyWith(color: greyTextColor),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${FormatCurrency(((item?.price ?? 0) - (item?.discountPrice ?? 0)) * (item?.quantity ?? 0))} đ',
                            style: p3.copyWith(color: mainColor),
                          ),
                        ],
                      ),
                      Visibility(
                        visible: (companyType != TypeCompany.spa.code),
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: LabelButton(
                            label: item?.medicalBill != null
                                ? 'Xem kết luận'
                                : 'Thêm kết luận ',
                            suffixIcon: item?.medicalBill != null
                                ? FaIcon(iconCode: 'f06e')
                                : FaIcon(iconCode: '2b'),
                            backgroundColor: item?.medicalBill != null
                                ? AppColors
                                    .button_neutral_alpha_backgroundDefault
                                    .withOpacity(0.05)
                                : AppColors.bg_primary,
                            labelStyle: AppStyle.bodyBsMedium,
                            border: item?.medicalBill != null
                                ? null
                                : const BorderSide(
                                    color: AppColors
                                        .button_neutral_outlined_borderDefault,
                                  ),
                            onPressed: () {
                              if (item?.medicalBill != null) {
                                context.pushRoute(
                                  DetailPkV2Route(id: item!.medicalBill!),
                                );
                              } else {
                                context
                                    .pushRoute(
                                  PhieuKhamV2Route(
                                    model: bloc.order!,
                                    appointmentService: item?.id ?? -1,
                                  ),
                                )
                                    .then((value) {
                                  if (value == true) {
                                    bloc.getDetail(widget.id);
                                  }
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => const Divider(
            height: sp32,
            color: borderColor_2,
          ),
          itemCount: bloc.order?.services.length ?? 0,
        ),
      ],
    );
  }

  Widget get _productsView {
    if ((bloc.order?.items.length ?? 0) == 0) {
      return 0.height;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        gapHeight(sp24),
        const Text(
          'Danh sách sản phẩm',
          style: p1,
        ),
        gapHeight(sp16),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = bloc.order?.items[index];
            return Column(
              children: [
                Row(
                  children: [
                    Text(
                      '${index + 1}. ',
                      style: p5.copyWith(color: greyTextColor),
                    ),
                    gapWidth(sp8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(sp4),
                      child: Image.network(
                        item?.productData?.images?.firstOrNull?.url ??
                            PrefKeys.imgProductDefault,
                        width: sp48,
                        height: sp48,
                        fit: BoxFit.cover,
                      ),
                    ),
                    gapWidth(sp16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item?.productData?.name ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: p9.copyWith(color: greyTextColor),
                          ),
                          RichText(
                            text: TextSpan(
                              text: 'SL: ',
                              style: p6.copyWith(color: greyTextColor),
                              children: [
                                TextSpan(
                                  text: '${item?.quantity} ',
                                  style: p5.copyWith(color: blackColor),
                                ),
                                TextSpan(text: item?.unitData?.name ?? ''),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text(
                                '${FormatCurrency(item?.price)} đ',
                                style: p5.copyWith(color: blackColor),
                              ),
                              gapWidth(sp8),
                              Visibility(
                                visible: item?.discountPrice != 0,
                                child: Text(
                                  ' - ${FormatCurrency(item?.discountPrice)} đ',
                                  style: p9.copyWith(color: greyTextColor),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${FormatCurrency(bloc.priceItem(item!))} đ',
                                style: p3.copyWith(color: mainColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: item.inforShipment?.shipment != null,
                  child: Container(
                    margin: const EdgeInsets.only(top: sp12),
                    width: double.infinity,
                    padding: const EdgeInsets.all(sp12),
                    decoration: BoxDecoration(
                      color: AppColors.brand5,
                      borderRadius: BorderRadius.circular(sp12),
                    ),
                    child: Wrap(
                      runSpacing: sp12,
                      spacing: sp12,
                      children: (item.inforShipment?.shipment ?? []).map((e) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: sp2,
                            horizontal: sp8,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(sp4),
                            color: AppColors.bg_black.withOpacity(0.05),
                          ),
                          child: Text(
                            'Lô ${e.code} - SL: ${e.quantity}',
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => const Divider(
            height: sp32,
            color: borderColor_2,
          ),
          itemCount: bloc.order?.items.length ?? 0,
        ),
      ],
    );
  }

  Widget get _productsExchangePoints {
    if ((bloc.order?.productExchangePoints.length ?? 0) == 0) {
      return 0.height;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(height: sp32),
        const Text(
          'Quà tặng từ đổi điểm',
          style: p1,
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = bloc.order?.productExchangePoints[index];
            final beforeItem = index == 0
                ? null
                : bloc.order?.productExchangePoints[index - 1];
            final isFirstGroup = item?.package != null &&
                beforeItem?.package?.id != item?.package?.id;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isFirstGroup) ...[
                  const Divider(height: sp12),
                  Row(
                    children: [
                      Text(
                        'Từ gói: ${item?.package?.name}',
                        style:
                            s14w500.copyWith(color: AppColors.text_secondary),
                      ),
                      const Spacer(),
                      Text(
                        '-${(item?.package?.point ?? 0).formatCurrency}',
                        style: s12w500.copyWith(color: AppColors.text_tertiary),
                      ),
                      sp8.width,
                      SvgPicture.asset('assets/svg/point.svg'),
                    ],
                  ),
                ],
                ListTile(
                  contentPadding: const EdgeInsets.all(sp0),
                  leading: BaseCacheImage(
                    loadPharmagoLogo: true,
                    url: item?.productData?.images?.firstOrNull?.url ?? '',
                    width: 50,
                    height: 50,
                    borderRadius: 4.radius,
                    fit: BoxFit.cover,
                  ),
                  title: Text(
                    item?.productData?.name ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppStyle.bodyBsMedium.copyWith(
                      height: 1.5,
                      color: AppColors.text_primary,
                    ),
                  ),
                  subtitle: item?.package == null
                      ? Row(
                          children: [
                            Text(
                              (item?.point ?? 0).formatCurrency,
                              style: s12w500.copyWith(
                                  color: AppColors.text_tertiary),
                            ),
                            sp8.width,
                            SvgPicture.asset('assets/svg/point.svg'),
                          ],
                        )
                      : Text(
                          'Số lượng: ${(item?.quantity ?? 0).formatCurrency} ${item?.productData?.unit.isNotEmpty ?? false ? item?.productData?.unit.last.name : '-'}',
                          style:
                              s14w400.copyWith(color: AppColors.text_tertiary),
                        ),
                ),
              ],
            );
          },
          itemCount: bloc.order?.productExchangePoints.length ?? 0,
        ),
      ],
    );
  }

  Widget get _paymentView {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thanh toán',
          style: p1.copyWith(color: blackColor),
        ),
        gapHeight(sp16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tổng tiền hàng',
              style: p6.copyWith(color: greyTextColor),
            ),
            gapHeight(sp16),
            Text(
              '${FormatCurrency(bloc.totalPriceItem)} đ',
            ),
          ],
        ),
        gapHeight(sp8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Chiết khấu',
              style: p6.copyWith(color: greyTextColor),
            ),
            gapHeight(sp16),
            Text(
              '${FormatCurrency(bloc.totalDiscount)} đ',
            ),
          ],
        ),
        gapHeight(sp8),
        _earnPointView,
        gapHeight(sp8),
        _usedPointView,
        8.height,
        gapHeight(sp16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: sp12, vertical: sp8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sp12),
            border: Border.all(color: borderColor_2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gửi tin ZNS cho khách hàng',
                style: p5.copyWith(color: blackColor),
              ),
              AppSwitch(
                value: bloc.order?.redInvoice ?? false,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        gapHeight(sp16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: sp12, vertical: sp8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sp12),
            border: Border.all(color: borderColor_2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hóa đơn đỏ',
                style: p5.copyWith(color: blackColor),
              ),
              AppSwitch(
                value: bloc.order?.redInvoice ?? false,
                onChanged: (value) {},
              ),
            ],
          ),
        ),
        // Column(
        //   children: (bloc.order?.items ?? []).map((e) {
        //     if ((e.productData?.vat ?? 0) == 0) {
        //       return gapHeight(sp0);
        //     }
        //     return Padding(
        //       padding: const EdgeInsets.only(top: sp12),
        //       child: RowItem(
        //         title:
        //             'VAT ${e.productData?.vat ?? 0}% của (${FormatCurrency(bloc.priceItem(e))} đ)',
        //         content: '${FormatCurrency(bloc.vatProd(e))} đ',
        //         titleStyle: p6.copyWith(color: greyTextColor),
        //         contetnStyle: p6.copyWith(color: greyTextColor),
        //       ),
        //     );
        //   }).toList(),
        // ),
        Visibility(
          visible: bloc.order?.redInvoice ?? false,
          child: Column(
            children: [
              const Divider(
                thickness: 1,
                color: AppColors.border_tertiary,
              ),
              4.height,
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = bloc.order?.items[index];
                  final prod = item?.productData;
                  if (prod?.vat == 0) 0.height;
                  return TextRow2(
                    title:
                        'VAT ${prod?.vat.formatCurrency}% của (${item?.price.formatCurrency} đ)',
                    content:
                        '${((item?.quantity ?? 0) * (item?.price.validator ?? 0) * prod!.vat.validator / 100).formatCurrency} đ',
                    contentStyle: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    bloc.order?.items[index].productData?.vat == 0
                        ? 0.height
                        : 8.height,
                itemCount: bloc.order?.items.length ?? 0,
              ),
              12.height,
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = bloc.order?.services[index];
                  final service = item?.service;
                  if (service?.vat == 0) 0.height;
                  return TextRow2(
                    title:
                        'VAT ${service?.vat.formatCurrency}% của (${item?.totalPrice.formatCurrency} đ)',
                    content: '${item?.vat.formatCurrency} đ',
                    contentStyle: AppStyle.bodyBsRegular.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  );
                },
                separatorBuilder: (context, index) =>
                    bloc.order?.services[index].service?.vat == 0
                        ? 0.height
                        : 8.height,
                itemCount: bloc.order?.services.length ?? 0,
              ),
            ],
          ),
        ),
        const Divider(height: sp24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tổng thanh toán',
              style: p6,
            ),
            gapHeight(sp16),
            Text(
              '${FormatCurrency(bloc.order?.totalPrice)} đ',
              style: p1.copyWith(color: blackColor),
            ),
          ],
        ),
        Visibility(
          visible: bloc.order?.payments.isNotEmpty ?? false,
          child: Container(
            margin: const EdgeInsets.only(top: sp16),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor_2),
              borderRadius: BorderRadius.circular(sp12),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: sp8,
                    horizontal: sp12,
                  ),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(sp12),
                    ),
                    color: greyFF3,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Đã thanh toán',
                        style: p5.copyWith(color: greyTextColor),
                      ),
                      Text(
                        '${FormatCurrency(bloc.hadPaid)} đ',
                        style: p5.copyWith(color: greyTextColor),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: (bloc.order?.payments ?? []).map((e) {
                    return Padding(
                      padding: const EdgeInsets.all(sp12),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(sp4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(sp12),
                              border: Border.all(color: borderColor_2),
                              color: greyFF3,
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.qr_code_rounded,
                                  size: sp8,
                                ),
                                gapWidth(sp4),
                                Text(
                                  e.method == 'cash'
                                      ? 'Tiền mặt'
                                      : 'Chuyển khoản',
                                  style: p7.copyWith(color: greyTextColor),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Column(
                            children: [
                              Text(
                                '${FormatCurrency(e.amount)} đ',
                                style: p5.copyWith(
                                  color: greyTextColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget get _earnPointView {
    if (bloc.order?.statusOrder != 'PAID') {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Tích điểm',
            style: p6.copyWith(color: greyTextColor),
          ),
          const Spacer(),
          Text(
            'Hiển thị sau khi đơn hàng được thanh toán',
            style: p9.copyWith(
              color: greyTextColor,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      );
    }
    return ExpandableNotifier(
      controller: _expandableEarnPointCtl,
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
          hasIcon: false,
        ),
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tích điểm',
              style: p6.copyWith(color: greyTextColor),
            ),
            const Spacer(),
            Text(
              '${FormatCurrency(bloc.order?.totalPointLog)} điểm',
            ),
            AnimatedRotation(
              turns: _expandableEarnPointCtl.expanded ? 0 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.text_tertiary,
              ),
            ),
          ],
        ),
        collapsed: Container(),
        expanded: Column(
          children: [
            gapHeight(sp8),
            Row(
              spacing: sp8,
              children: [
                sp32.width,
                Text(
                  'Tích điểm theo sản phẩm',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${bloc.order?.pointProductPlusExchange.formatCurrency} điểm',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
              ],
            ),
            gapHeight(sp8),
            Row(
              spacing: sp8,
              children: [
                sp32.width,
                Text(
                  'Tích điểm theo đơn hàng',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${bloc.order?.pointRevenueExchange.formatCurrency} điểm',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _usedPointView {
    return ExpandableNotifier(
      controller: _expandableUsedPointCtl,
      child: ExpandablePanel(
        theme: const ExpandableThemeData(
          hasIcon: false,
        ),
        header: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Điểm đã sử dụng',
              style: p6.copyWith(color: greyTextColor),
            ),
            const Spacer(),
            Text(
              '${FormatCurrency(bloc.order?.totalPointLogUsed)} điểm',
            ),
            AnimatedRotation(
              turns: _expandableUsedPointCtl.expanded ? 0 : 0.5,
              duration: const Duration(milliseconds: 300),
              child: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.text_tertiary,
              ),
            ),
          ],
        ),
        collapsed: Container(),
        expanded: Column(
          children: [
            8.height,
            Row(
              spacing: sp8,
              children: [
                sp32.width,
                Text(
                  'Quy đổi điểm theo giá trị đơn hàng',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${bloc.order?.pointMoneyExchange.formatCurrency} điểm',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '-${bloc.order?.moneyExchange.formatCurrency}đ',
                  style: s14w700.copyWith(
                    color: AppColors.text_primary,
                  ),
                ),
              ],
            ),
            8.height,
            Row(
              spacing: sp8,
              children: [
                sp32.width,
                Text(
                  'Quy đổi điểm theo sản phẩm',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${bloc.order?.pointProductExchange.formatCurrency} điểm',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
              ],
            ),
            8.height,
            Row(
              spacing: sp8,
              children: [
                sp32.width,
                Text(
                  'Quy đổi điểm theo gói sản phẩm',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_secondary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${bloc.order?.pointPackageExchange.formatCurrency} điểm',
                  style: AppStyle.bodyBsRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget get _noteView {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ghi chú đơn hàng',
          style: p6.copyWith(),
        ),
        gapHeight(sp8),
        Text(
          bloc.order?.description ?? 'Chưa có thông tin',
          style: p5.copyWith(color: blackColor),
        ),
      ],
    );
  }

  Widget get _prescription {
    final hasPrescriptionCode =
        (bloc.order?.prescriptionCode ?? '').trim().isNotEmpty;
    final hasPrescriptionImages =
        (bloc.order?.prescriptionImages ?? []).isNotEmpty;
    final prescriptionImages = List<PrescriptionImageV2Model>.from(
        bloc.order?.prescriptionImages ?? []);
    if (!hasPrescriptionCode && !hasPrescriptionImages) {
      return Column(
        children: [
          24.height,
          Row(
            children: [
              Text(
                'Đơn thuốc',
                style: AppStyle.headingLg,
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  BtsOrderPrescription.show(
                    context,
                    orderId: bloc.order!.id!,
                    prescriptionCode: bloc.order?.prescriptionCode,
                    prescriptionImages: bloc.order?.prescriptionImages,
                    bloc: bloc,
                    callBack: () {
                      bloc.getDetail(widget.id, isLoading: false);
                    },
                  );
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.bg_secondary,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Icon(
                    Icons.add_rounded,
                    size: 20,
                    color: AppColors.icon_iconSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Thông tin đơn thuốc',
          style: p1.copyWith(color: greyTextColor),
        ),
        gapHeight(sp20),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'Mã đơn thuốc: ',
                style: p5.copyWith(color: greyTextColor),
              ),
              TextSpan(
                text: '${bloc.order?.prescriptionCode}',
                style: p5.copyWith(color: mainColor),
              ),
            ],
          ),
        ),
        gapHeight(sp8),
        Text(
          'Ảnh liên quan',
          style: p5.copyWith(color: greyTextColor),
        ),
        gapHeight(sp8),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(sp12),
            border: Border.all(color: borderColor_2),
          ),
          padding: const EdgeInsets.all(sp12),
          child: Column(
            children: [
              if ((bloc.order?.prescriptionImages?.length ?? 0) > 0) ...[
                SizedBox(
                  height: sp56,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(sp8),
                        child: Image.network(
                          prescriptionImages[index].url ?? '',
                          width: sp56,
                          height: sp56,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Container(
                              width: sp56,
                              height: sp56,
                              color: AppColors.bg_disable,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColors.icon_iconSecondary,
                                size: sp16,
                              ),
                            );
                          },
                        ),
                      );
                    },
                    separatorBuilder: (_, __) => gapWidth(sp8),
                    itemCount: prescriptionImages.length,
                  ),
                ),
                gapHeight(sp8),
              ] else ...[
                SvgPicture.asset(Assets.svgFileIcon),
                gapHeight(sp4),
              ],
            ],
          ),
        ),
        MainButtonV2(
          title: 'Chỉnh sửa đơn thuốc',
          backgroundColor: AppColors.black,
          radius: sp48,
          onTap: () {
            BtsOrderPrescription.show(
              context,
              orderId: bloc.order!.id!,
              prescriptionCode: bloc.order?.prescriptionCode,
              prescriptionImages: bloc.order?.prescriptionImages,
              bloc: bloc,
              callBack: () {
                bloc.getDetail(widget.id, isLoading: false);
              },
            );
          },
        ),
      ],
    );
  }

  Widget get _bottomView {
    if (bloc.hadPaid == bloc.order?.totalPrice) {
      return gapHeight(sp0);
    }
    return Container(
      padding: const EdgeInsets.all(sp16),
      decoration: const BoxDecoration(
        color: whiteColor,
        boxShadow: [
          BoxShadow(
            color: black5o,
            offset: Offset(0, -1),
            blurRadius: sp2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Còn lại phải thu',
                style: p6.copyWith(color: blackColor),
              ),
              Text(
                '${FormatCurrency((bloc.order?.totalPrice ?? 0) - bloc.hadPaid)} đ',
                style: h2,
              ),
            ],
          ),
          gapHeight(sp12),
          Row(
            children: [
              Expanded(
                child: CustomBtn(
                  backgroundColor: black5o,
                  title: 'Trở lại',
                  radius: sp24,
                  onPressed: () => context.router.maybePop(),
                ).size(height: 45),
              ),
              gapWidth(sp16),
              Expanded(
                child: CustomBtn(
                  title: 'Thu tiền',
                  radius: sp24,
                  textStyle:
                      AppStyle.bodyBsBold.copyWith(color: AppColors.white),
                  onPressed: createPayment,
                ).size(height: 45),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenu() {
    return MenuPopupWorkSpace(
      onTap: (value) {
        if (value == StatusMenuWorkspace.edit) {
          if (!canEdit) {
            context.permissionDenied()();
            return;
          }
          context.router
              .push(UnderDevelopmentRoute(title: 'Chỉnh sửa đơn hàng'));
          return;
        }
        if (!canDelete) {
          context.permissionDenied()();
          return;
        }
        if (!(bloc.order?.isDelivered ?? false) &&
            bloc.order?.statusOrder != 'INCOMPLETE') {
          menuActionDialog(
            context,
            value: value,
            title: 'Đơn hàng ${bloc.order?.code ?? ''}',
            typeName: 'Đơn hàng',
            contentText: 'Bạn có chắc chắn muốn ${value.title.toLowerCase()} ',
            confirm: () {
              context.pop();
              bloc.delete(widget.id).then((res) {
                if (res.code == 200) {
                  getIt<OrderManagerBloc>().getList();
                  context.router.popUntil(
                    (route) =>
                        route.settings.name == OrderManagerV2Route.name ||
                        route.settings.name == HomeRoute.name,
                  );
                  context.read<NavHomeBloc>().onChanged(TabCodeNav.order);
                  ToastCustom.show(
                    context,
                    title: 'Thành công',
                    msg: res.message ?? 'Xoá đơn thành công',
                    svgIcon: Assets.iconsSuccess,
                    color: AppColors.ultility_brand_60,
                    timeClose: 2.seconds,
                  );
                } else {
                  context.dialog(
                    DialogMessage(
                      title: 'Thông báo',
                      content: res.message ?? 'Tạo đơn hàng không thành công',
                      isError: true,
                    ),
                  );
                }
              });
            },
          );
        }
      },
      isDetail: true,
      isStatus: false,
      isDelete: !((bloc.order?.isDelivered ?? false) ||
          bloc.order?.statusOrder == 'INCOMPLETE'),
      child: IconBtn(
        backgroundColor: AppColors.bg_primary,
        icon: const Icon(
          Icons.more_vert,
          size: 15,
        ),
      ),
    );
  }

  Future<void> createPayment() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(sp12),
        ),
      ),
      builder: (context) => Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: BtsCreatePayment(
          totalMoney: (bloc.order?.totalPrice ?? 0) - bloc.hadPaid,
          onConfirm: (value, type) {
            if (value == 0) {
              DialogUtils.showErrorDialog(
                context,
                content: 'Số tiền thanh toán không hợp lệ',
              );
              return;
            }
            bloc.createPayment(value, type).then((res) {
              if (res.code != 200) {
                DialogUtils.showErrorDialog(
                  context,
                  content: res.message ?? '',
                );
              } else {
                getIt<OrderManagerBloc>().getList();
                //context.pop(result: true);
              }
            });
          },
        ),
      ),
    ).then((value) {
      if (value == true) {
        print('Thanh toán thành công');
        ToastCustom.show(
          context,
          title: 'Thành công',
          msg: 'Thanh toán thành công',
          svgIcon: Assets.iconsSuccess,
          color: AppColors.ultility_brand_60,
          timeClose: 2.seconds,
        );
      }
    });
  }

  Container _buildPopup() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bg_primaryAlpha.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      padding: 8.pading,
      margin: 16.padingRight,
      child: PopupOrderInfo(
        child: const Icon(
          Icons.more_vert,
          color: AppColors.black,
        ),
        onTap: (value) {
          switch (value) {
            case OrderEvent.delete:
              _buildDialog(context, OrderEvent.delete);
              break;
            case OrderEvent.edit:
              context.router
                  .push(UnderDevelopmentRoute(title: 'Chỉnh sửa đơn hàng'));
              break;
          }
        },
      ),
    );
  }

  void _buildDialog(
    BuildContext context,
    OrderEvent status,
  ) {
    context.dialog(
      DialogConfirm(
        title: 'Xoá sản phẩm',
        content: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'Bạn có chắc chắn muốn xóa đơn hàng sản phẩm của khách hàng ',
            style: AppStyle.bodyBsRegular.copyWith(
              color: AppColors.text_tertiary,
            ),
            children: [
              TextSpan(
                text: '${bloc.order?.customer?.prefixName}  ',
                style: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
              TextSpan(
                text: 'không?',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_tertiary,
                ),
              ),
            ],
          ),
        ),
        actionConfirmBorder: true,
        colorConfirmBtn: AppColors.button_negative_outlined_textDefault,
        icon: IconDiaLog(
          color: AppColors.fg_negative.withOpacity(0.1),
          icon: FaIcon(
            type: FaIconType.solid,
            iconCode: 'f1f8',
            color: AppColors.fg_negative,
            size: 32,
          ),
        ),
        confirm: () {
          context.pop();
          DialogUtils.showLoadingDialog(
            context,
            'Đang tải...',
          );
          bloc.delete(bloc.order?.id ?? -1).then((value) {
            context.pop();
            if (value.code == 200) {
              getIt<OrderManagerBloc>().getList();
              ToastCustom.show(
                context,
                title: 'Thành công',
                msg: 'Xoá đơn hàng thành công',
                svgIcon: Assets.iconsSuccess,
                color: AppColors.ultility_brand_60,
                timeClose: 2.seconds,
              );
              context.router.maybePop();
            } else {
              context.dialog(
                DialogMessage(
                  title: 'Thông báo',
                  content: value.message,
                  isError: true,
                ),
              );
            }
          });
        },
      ),
    );
  }

  void _updateStatusDeliver() {
    bloc.updateDeliver().then((res) {
      if (res.code != 200) {
        DialogUtils.showErrorDialog(
          context,
          content: res.message ?? '',
        );
      }
    });
  }

  void _orderDetailListener(CubitState state) {
    if (state.status == BlocStatus.submit) {
      print('=====BlocStatus.submit');
      context.pop();
    } else if (state.status == BlocStatus.submitSuccess) {
      print('=====BlocStatus.submitSuccess');
      bloc.getDetail(widget.id, isLoading: false);
      ToastCustom.show(
        context,
        title: 'Thành công',
        msg: 'Phát hành hoá đơn điện tử thành công',
        svgIcon: Assets.iconsSuccess,
        color: AppColors.ultility_brand_60,
        timeClose: 2.seconds,
      );
    } else if (state.status == BlocStatus.submitFailure) {
      print('=====BlocStatus.submitFailure');
      ToastCustom.show(
        context,
        title: 'Thất bại',
        msg: 'Phát hành hoá đơn điện tử thất bại, ${state.msg.toString()}',
        svgIcon: Assets.iconsNotiIconNotiErr,
        color: AppColors.ultility_carrot_60,
        timeClose: 2.seconds,
      );
    }
  }
}

class ExportInvoiceBottomSheet extends StatelessWidget {
  const ExportInvoiceBottomSheet({
    super.key,
    required this.bloc,
    required this.onChanged,
  });

  final ExprortInvoiceBloc bloc;
  final dynamic Function(UserSerialModel?) onChanged;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        16.height,
        CommonDropdown(
          maxHeight: heightDevice(context) / 3,
          showIconRemove: false,
          value: bloc.serialSelected,
          required: true,
          label: 'Mẫu phát hành hóa đơn điện tử',
          items: bloc.userSerials
              ?.map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e.name ?? '???', style: p6),
                ),
              )
              .toList(),
          hintText: 'Chọn mẫu hoá đơn',
          onChanged: onChanged,
        ),
      ],
    );
  }
}
