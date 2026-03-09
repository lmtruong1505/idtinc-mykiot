import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/features/order/widgets/card_variant.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';
import 'package:pharmago/presentation/features/product/domain/entities/variant_entity.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/event.dart';

import '../../../base/app_bar.dart';
import '../../../base/text_field.dart';
import '../../../base/two_button_box.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../customer/domain/entities/customer_entity.dart';
import '../cubit/order_create_cubit/order_create_cubit.dart';
import '../cubit/order_create_cubit/order_create_state.dart';
import '../widgets/card_service.dart';
import '../widgets/overlay_sugget_service.dart';
import '../widgets/overlay_sugget_variant.dart';
import '../widgets/overlay_sugget_customer.dart';

@RoutePage()
class OrderCreatePage extends StatefulWidget {
  const OrderCreatePage({
    super.key,
    this.onSuccess,
  });

  final Function? onSuccess;

  @override
  State<OrderCreatePage> createState() => _OrderCreatePageState();
}

class _OrderCreatePageState extends State<OrderCreatePage>
    with TickerProviderStateMixin {
  final myBloc = getIt.get<OrderCreateCubit>();

  // final _paymentKey = GlobalKey<FormState>();
  final _keyForm = GlobalKey<FormState>();
  final _btsKeyForm = GlobalKey<FormState>();

  late ExpandableController expandableInfoController;
  late ExpandableController expandableVariantController;
  late ExpandableController expandablePaymentController;
  late ExpandableController expandableServiceController;
  late FocusNode _fnCustomer;
  late FocusNode _fnVariant;
  late FocusNode _fnService;
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLinkCustomer = LayerLink();
  final LayerLink _layerLinkVariant = LayerLink();
  final LayerLink _layerLinkService = LayerLink();
  late AnimationController _controllerDropdownAnimation;
  late Animation<double> _animationDropDown;

  final _scrollController = ScrollController();

  final _phone = TextEditingController();
  final _name = TextEditingController();
  // final _service = TextEditingController();

  @override
  void initState() {
    super.initState();

    expandableInfoController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });

    expandableVariantController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });

    expandablePaymentController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });

    expandableServiceController = ExpandableController(initialExpanded: true)
      ..addListener(() {
        setState(() {});
      });

    _controllerDropdownAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _animationDropDown = Tween<double>(
      begin: 0,
      end: 300,
    ).animate(_controllerDropdownAnimation);

    _fnCustomer = FocusNode()
      ..addListener(() async {
        if (_overlayEntry?.mounted ?? false) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
        if (_fnCustomer.hasFocus) {
          _overlayEntry = overlaySuggetCustomer(
            layerLink: _layerLinkCustomer,
            controllerDropdownAnimation: _controllerDropdownAnimation,
            animationDropDown: _animationDropDown,
            myBloc: myBloc,
            onSelected: _selectCustomer,
          );
          // ignore: use_build_context_synchronously
          Overlay.of(context).insert(_overlayEntry!);
          _controllerDropdownAnimation.forward();
        } else {
          _fnUnfocus();
        }
        setState(() {});
      });

    _fnVariant = FocusNode()
      ..addListener(() async {
        if (_overlayEntry?.mounted ?? false) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
        if (_fnVariant.hasFocus) {
          _overlayEntry = overlaySuggetVariant(
            layerLink: _layerLinkVariant,
            controllerDropdownAnimation: _controllerDropdownAnimation,
            animationDropDown: _animationDropDown,
            myBloc: myBloc,
            onSelected: _selectVariant,
          );
          // ignore: use_build_context_synchronously
          Overlay.of(context).insert(_overlayEntry!);
          _controllerDropdownAnimation.forward();
          final currentPosition = _scrollController.position.pixels;
          _scrollController.animateTo(
            currentPosition + 100,
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
          );
        } else {
          _fnUnfocus();
        }
        setState(() {});
      });

    _fnService = FocusNode()
      ..addListener(() async {
        if (_overlayEntry?.mounted ?? false) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
        if (_fnService.hasFocus) {
          _overlayEntry = overlaySuggetService(
            layerLink: _layerLinkService,
            controllerDropdownAnimation: _controllerDropdownAnimation,
            animationDropDown: _animationDropDown,
            myBloc: myBloc,
            onSelected: _selectService,
          );
          // ignore: use_build_context_synchronously
          Overlay.of(context).insert(_overlayEntry!);
          _controllerDropdownAnimation.forward();
          final currentPosition = _scrollController.position.pixels;
          _scrollController.animateTo(
            currentPosition + 100,
            duration: const Duration(milliseconds: 200),
            curve: Curves.ease,
          );
        } else {
          _fnUnfocus();
        }
        setState(() {});
      });
  }

  Future<void> _fnUnfocus() async {
    _controllerDropdownAnimation.reverse();
    Timer(const Duration(milliseconds: 150), () {
      _overlayEntry?.remove();
    });
  }

  @override
  void dispose() {
    super.dispose();

    _fnCustomer.dispose();
    _fnVariant.dispose();
    _fnService.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderCreateCubit>(
      create: (context) => myBloc
        ..checkCustomer('')
        ..checkVariant('')
        ..checkCustomer('')
        ..checkService(''),
      child: BlocBuilder<OrderCreateCubit, OrderCreateState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: bg_5,
              appBar: BaseAppBar(
                title: 'Tạo đơn bán hàng',
                actions: [
                  InkWell(
                    onTap: () {},
                    child: Text(
                      'Lưu đơn nháp',
                      style: p5.copyWith(color: blue_1, fontWeight: BOLD),
                    ),
                  ),
                  gapWidth(sp16),
                ],
              ),
              body: Form(key: _keyForm, child: _buildView(state.pageIndex, state)),
              bottomNavigationBar: TwoButtonBox(
                mainTitle: '${FormatCurrency(state.orderInfo.mustPaid)}đ',
                extraTitle: 'Huỷ bỏ',
                mainOnTap: () {
                  final validate = _keyForm.currentState!.validate();
                  if (!validate) return;
                  _createOrder();
                },
                extraOnTap: () {
                  context.router.maybePop();
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildView(int pageIndex, OrderCreateState state) {
    return Container(
      width: widthDevice(context),
      height: heightDevice(context),
      padding: const EdgeInsets.all(sp16),
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            //  Info Order
            //   ExpandablePanel(
            //     controller: expandableInfoController,
            //     theme: const ExpandableThemeData(
            //       hasIcon: false,
            //     ),
            //     header: Container(
            //       padding: const EdgeInsets.all(sp16),
            //       decoration: BoxDecoration(
            //         color: whiteColor,
            //         borderRadius: BorderRadius.vertical(
            //           top: const Radius.circular(sp8),
            //           bottom: Radius.circular(
            //             expandableInfoController.expanded ? sp0 : sp8,
            //           ),
            //         ),
            //       ),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           Text(
            //             'Thông tin đơn hàng',
            //             style: h6.copyWith(color: greyColor),
            //           ),
            //           AnimatedRotation(
            //             turns: !expandableInfoController.expanded ? 0 : 0.5,
            //             duration: const Duration(milliseconds: 300),
            //             child: IcSvg.asset('/ic_arrow_down.svg'),
            //           ),
            //         ],
            //       ),
            //     ),
            //     collapsed: const SizedBox(),
            //     expanded: Container(
            //       padding: const EdgeInsets.all(sp16).copyWith(top: 0),
            //       decoration: BoxDecoration(
            //         borderRadius: const BorderRadius.vertical(
            //           bottom: Radius.circular(sp12),
            //         ),
            //         color: whiteColor,
            //         boxShadow: [
            //           BoxShadow(
            //             color: blackColor.withOpacity(0.1),
            //             offset: const Offset(1, 1),
            //             blurRadius: 1,
            //           ),
            //         ],
            //       ),
            //       child: Column(
            //         children: [
            //           const Divider(height: sp24),
            //           gapHeight(sp12),
            //           CompositedTransformTarget(
            //             link: _layerLinkCustomer,
            //             child: AppInput(
            //               controller: _phone,
            //               label: 'Số điện thoại',
            //               required: true,
            //               hintText: 'Nhập số điện thoại',
            //               backgroundColor: bg_5,
            //               borderColor: bg_5,
            //               fn: _fnCustomer,
            //               textInputType: TextInputType.phone,
            //               prefixIcon: const Icon(Icons.phone_outlined),
            //               onChanged: (value) {
            //                 myBloc.checkCustomer(value);
            //               },
            //               onConfirm: (value) {
            //                 if (value.length == 10 &&
            //                     state.suggestCustomer.isNotEmpty) {
            //                   _selectCustomer(state.suggestCustomer.first);
            //                 }
            //               },
            //               validate: (value) {
            //                 if (value?.isEmpty ?? true) {
            //                   return 'Vui lòng nhập số điện thoại';
            //                 }
            //               },
            //             ),
            //           ),
            //           gapHeight(sp12),
            //           AppInput(
            //             controller: _name,
            //             label: 'Tên khách hàng',
            //             hintText: 'Nhập tên khách hàng',
            //             backgroundColor: bg_5,
            //             borderColor: bg_5,
            //             textInputType: TextInputType.text,
            //             onChanged: (value) => myBloc.orderInfoChange(
            //               name: value,
            //             ),
            //             readOnly: state.customerSelected != null,
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),

            // ====================== Info customer ======================
            Container(
              decoration: BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.circular(sp12),
              ),
              child: ListTile(
                title: Text(state.orderInfo.customerName ?? 'Khách hàng'),
                subtitle:
                    Text(state.orderInfo.customerPhone ?? 'Số điện thoại'),
                leading: const VerticalDivider(
                  color: Colors.orange,
                  thickness: 3,
                ),
                trailing: InkWell(
                  child: const Icon(Icons.edit),
                  onTap: () {
                    _name.text = state.orderInfo.customerName ?? '';
                    showBts(context, state);
                  },
                ),
              ),
            ),
            gapHeight(sp12),
            SizedBox(
              width: double.infinity,
              child: CupertinoSlidingSegmentedControl(
                backgroundColor: borderColor_2.withOpacity(0.5),
                groupValue: state.tabSelected,
                children: <int, Widget>{
                  0: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: sp16,
                      vertical: sp8,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Sản phẩm(${state.variantSelected.length})',
                          style: state.tabSelected == 0
                              ? h6.copyWith(color: blackColor)
                              : p5.copyWith(color: greyColor),
                        ),
                        gapHeight(sp4),
                        Text(
                          '${FormatCurrency(myBloc.getTotalPriceVariant)}đ',
                          style: p5.copyWith(color: green_1),
                        ),
                      ],
                    ),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: sp16,
                      vertical: sp8,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Dịch vụ(${state.serviceSelected.length})',
                          style: state.tabSelected == 1
                              ? h6.copyWith(color: blackColor)
                              : p5.copyWith(color: greyColor),
                        ),
                        gapHeight(sp4),
                        Text(
                          '${FormatCurrency(myBloc.getTotalPriceService)}đ',
                          style: p5.copyWith(color: green_1),
                        ),
                      ],
                    ),
                  ),
                },
                onValueChanged: (value) {
                  myBloc.tabChange(value);
                  _fnUnfocus();
                },
              ),
            ),

            (state.tabSelected == 0)
                ?
                //     ===================Variant=========================
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // RichText(
                      //   text: TextSpan(
                      //     children: [
                      //       TextSpan(
                      //         text:
                      //         '${FormatCurrency(myBloc.getTotalPriceVariant)}đ',
                      //         style: p5.copyWith(color: mainColor),
                      //       ),
                      //       TextSpan(
                      //         text: '/${state.variantSelected.length} sản phẩm',
                      //         style: p5.copyWith(color: greyColor),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      gapHeight(sp12),
                      CompositedTransformTarget(
                        link: _layerLinkVariant,
                        child: AppInputSupport(
                          hintText: 'Chọn sản phẩm',
                          backgroundColor: whiteColor,
                          borderColor: whiteColor,
                          radius: sp12,
                          fn: _fnVariant,
                          textInputType: TextInputType.text,
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: InkWell(
                            onTap: () => context.router.push(
                              OrderScanRoute(
                                dataInit: state.variantSelected,
                                onDispose: myBloc.updateVariantSelected,
                              ),
                            ),
                            child: const Icon(Icons.qr_code_scanner_rounded),
                          ),
                          onChanged: myBloc.checkVariant,
                        ),
                      ),
                      gapHeight(sp16),
                      state.variantSelected.isEmpty
                          ? const EmptyContainer()
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final variant = state.variantSelected[index];
                                return CardVariantCreateOrder(
                                  variant: variant,
                                  myBloc: myBloc,
                                  index: index,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  gapHeight(sp16),
                              itemCount: state.variantSelected.length,
                            ),
                    ],
                  )
                :
                //     ===================Service=========================
                Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // RichText(
                      //   text: TextSpan(
                      //     children: [
                      //       TextSpan(
                      //         text:
                      //         '${FormatCurrency(myBloc.getTotalPriceService)}đ',
                      //         style: p5.copyWith(color: mainColor),
                      //       ),
                      //       TextSpan(
                      //         text: '/${state.serviceSelected.length} dịch vụ',
                      //         style: p5.copyWith(color: greyColor),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      gapHeight(sp12),
                      CompositedTransformTarget(
                        link: _layerLinkService,
                        child: AppInputSupport(
                          hintText: 'Chọn dịch vụ',
                          backgroundColor: whiteColor,
                          borderColor: whiteColor,
                          radius: sp12,
                          fn: _fnService,
                          textInputType: TextInputType.text,
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: InkWell(
                            onTap: () => context.router.push(
                              OrderScanRoute(
                                dataInit: state.variantSelected,
                                onDispose: myBloc.updateVariantSelected,
                              ),
                            ),
                            child: const Icon(Icons.qr_code_scanner_rounded),
                          ),
                          onChanged: myBloc.checkService,
                        ),
                      ),
                      gapHeight(sp16),
                      state.serviceSelected.isEmpty
                          ? const EmptyContainer()
                          : ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final service = state.serviceSelected[index];
                                return CardServiceCreateOrder(
                                  service: service,
                                  myBloc: myBloc,
                                  index: index,
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  gapHeight(sp16),
                              itemCount: state.serviceSelected.length,
                            ),
                    ],
                  ),
            gapHeight(sp16),

            // Info Payment
            // ExpandablePanel(
            //   controller: expandablePaymentController,
            //   theme: const ExpandableThemeData(
            //     hasIcon: false,
            //   ),
            //   header: Container(
            //     padding: const EdgeInsets.all(sp16),
            //     decoration: BoxDecoration(
            //       color: whiteColor,
            //       borderRadius: BorderRadius.vertical(
            //         top: const Radius.circular(sp8),
            //         bottom: Radius.circular(
            //           expandablePaymentController.expanded ? sp0 : sp8,
            //         ),
            //       ),
            //     ),
            //     child: Row(
            //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //       children: [
            //         Text(
            //           'Bổ sung thanh toán',
            //           style: h6.copyWith(color: greyColor),
            //         ),
            //         AnimatedRotation(
            //           turns: !expandablePaymentController.expanded ? 0 : 0.5,
            //           duration: const Duration(milliseconds: 300),
            //           child: IcSvg.asset('/ic_arrow_down.svg'),
            //         ),
            //       ],
            //     ),
            //   ),
            //   collapsed: Container(
            //     padding: const EdgeInsets.all(sp16).copyWith(top: 0),
            //     decoration: BoxDecoration(
            //       borderRadius: const BorderRadius.vertical(
            //         bottom: Radius.circular(sp12),
            //       ),
            //       color: whiteColor,
            //       boxShadow: [
            //         BoxShadow(
            //           color: blackColor.withOpacity(0.1),
            //           offset: const Offset(1, 1),
            //           blurRadius: 1,
            //         ),
            //       ],
            //     ),
            //     child: Column(
            //       children: [
            //         const Divider(height: sp24),
            //         gapHeight(sp12),
            //         RowItem(
            //           title: 'Chiết khấu tổng đơn',
            //           content: state.orderInfo.discount ?? '',
            //         ),
            //         gapHeight(sp12),
            //         RowItem(
            //           title: 'Phí dịch vụ',
            //           content:
            //               '${FormatCurrency(state.orderInfo.servicePrice)}đ',
            //         ),
            //       ],
            //     ),
            //   ),
            //   expanded: Container(
            //     padding: const EdgeInsets.all(sp16).copyWith(top: 0),
            //     decoration: BoxDecoration(
            //       borderRadius: const BorderRadius.vertical(
            //         bottom: Radius.circular(sp12),
            //       ),
            //       color: whiteColor,
            //       boxShadow: [
            //         BoxShadow(
            //           color: blackColor.withOpacity(0.1),
            //           offset: const Offset(1, 1),
            //           blurRadius: 1,
            //         ),
            //       ],
            //     ),
            //     child: Column(
            //       children: [
            //         const Divider(height: sp24),
            //         gapHeight(sp12),
            //         Form(
            //           key: _paymentKey,
            //           child: AppInput(
            //             initialValue: state.orderInfo.discount ?? '',
            //             label: 'Chiết khấu',
            //             hintText: 'Nhập chiết khấu (VD: 12%, 100.000)',
            //             backgroundColor: bg_5,
            //             borderColor: bg_5,
            //             textInputType: TextInputType.text,
            //             onChanged: (value) {
            //               final validate = _paymentKey.currentState?.validate();
            //               if (validate ?? true) {
            //                 myBloc.orderInfoChange(
            //                   discount: value,
            //                 );
            //               } else {
            //                 return;
            //               }
            //             },
            //             validate: (value) {
            //               if (value?.isNotEmpty ?? false) {
            //                 if (!_isValidInput(value)) {
            //                   return 'Giá trị không hợp lệ';
            //                 }
            //               }
            //             },
            //           ),
            //         ),
            //         gapHeight(sp12),
            //         InputCurrency(
            //           controller: _service,
            //           label: 'Phí dịch vụ',
            //           hintText: 'Nhập phí dịch vụ',
            //           backgroundColor: bg_5,
            //           borderColor: bg_5,
            //           onChanged: (value) {
            //             myBloc.orderInfoChange(
            //               servicePrice: double.tryParse(value) ?? 0,
            //             );
            //           },
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _createOrder() {
    DialogUtils.showLoadingDialog(
      context,
      'Đang tạo đơn vui lòng đợi',
    );
    myBloc.createOrder().then((value) {
      Navigator.of(context).pop();
      if (value.code == 200) {
        widget.onSuccess?.call();
        // context.router.push(OrderCreateSuccessRoute());
        DialogUtils.showSuccessDialog(
          context,
          content: 'Tạo đơn hàng thành công',
          titleClose: 'Danh sách',
          titleConfirm: 'Chi tiết',
          close: () {
            context.router
              .popUntil((route) => route.settings.name == 'OrderListRoute' || route.settings.name == 'HomeRoute');
            context.router.push(const OrderListRoute());
          },
          accept: () {
            context.router
                .popUntil((route) => route.settings.name == 'OrderListRoute' || route.settings.name == 'HomeRoute');
            context.router.push(OrderDetailV2Route(id: value.data));
          },
        );
      } else if (value.code == 400) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: yellow_1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(sp12),
            ),
            behavior: SnackBarBehavior.floating,
            content: Text(
              value.message ?? '',
              style: p5.copyWith(color: whiteColor),
            ),
          ),
        );
      } else {
        DialogUtils.showErrorDialog(
          context,
          content: 'Tạo đơn hàng thất bại ${value.message}',
        );
      }
    });
  }

  void _selectCustomer(CustomerEntity? item) {
    setState(() {
      myBloc.selectCustomer(item);
      _name.text = item?.name ?? '';
      _phone.text = item?.phone ?? '';
      _fnCustomer.unfocus();
    });
  }

  void _selectVariant(VariantEntity? item) {
    setState(() {
      myBloc.updateVariantSelected([item]);
      _fnVariant.unfocus();
    });
  }

  void _selectService(ServiceEntity? item) {
    setState(() {
      myBloc.updateServiceSelected([item]);
      _fnService.unfocus();
    });
  }

  void showBts(BuildContext context, OrderCreateState state) {
    showModalBottomSheet<dynamic>(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Form(
          key: _btsKeyForm,
          child: Container(
            decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(sp12),
              ),
            ),
            padding: const EdgeInsets.all(sp16).copyWith(top: 0),
            child: ListView(
              shrinkWrap: true,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Huỷ bỏ',
                        style: h6.copyWith(
                          color: blue_1,
                          fontWeight: BOLD,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Thông tin khách hàng',
                      style: h6.copyWith(
                        color: blackColor,
                        fontWeight: BOLD,
                        fontSize: sp16,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        final validate = _btsKeyForm.currentState!.validate();
                        if (!validate) {
                          return;
                        }
                        myBloc.orderInfoChange(
                          name: _name.text,
                          phone: _phone.text,
                        );
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Xác nhận',
                        style: h6.copyWith(
                          color: blue_1,
                          fontWeight: BOLD,
                        ),
                      ),
                    ),
                  ],
                ),
                gapHeight(sp16),
                Column(
                  children: [
                    AppInput(
                      controller: _phone,
                      label: 'Số điện thoại',
                      required: true,
                      hintText: 'Nhập số điện thoại',
                      backgroundColor: bg_5,
                      borderColor: bg_5,
                      //fn: _fnCustomer,
                      textInputType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_outlined),
                      onChanged: (value) async {
                        myBloc.checkCustomer(value);
                        _name.text = state.customerSelected?.name ?? '';
                        // _name.text = state.customerSelected?.name ?? '';
                        // myBloc.changePhone(value.trim());
                      },
                      onConfirm: (value) {
                        if (value.length == 10 &&
                            state.suggestCustomer.isNotEmpty) {
                          _selectCustomer(
                            state.suggestCustomer.first,
                          );
                        }
                      },
                      validate: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Vui lòng nhập số điện thoại';
                        }
                        return null;
                      },
                    ),
                    gapHeight(sp16),
                    BlocBuilder<OrderCreateCubit, OrderCreateState>(
                      bloc: myBloc,
                      builder: (context, state) {
                        return AppInput(
                          controller: _name
                            ..text = state.orderInfo.customerName ?? '',
                          label: 'Tên khách hàng',
                          hintText: 'Nhập tên khách hàng',
                          backgroundColor: bg_5,
                          borderColor: bg_5,
                          textInputType: TextInputType.text,
                          // onChanged: (value) =>
                          //     myBloc.changeName(value.trim()),
                          readOnly: state.customerSelected != null,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool _isValidInput(String? input) {
    // Biểu thức chính quy để kiểm tra chuỗi chỉ chứa số hoặc số với dấu %
    final RegExp regex = RegExp(r'^(\d+|\d+\s?%)$');

    // Sử dụng hàm test để kiểm tra xem chuỗi có khớp với biểu thức chính quy không
    return regex.hasMatch(input ?? '');
  }
}
