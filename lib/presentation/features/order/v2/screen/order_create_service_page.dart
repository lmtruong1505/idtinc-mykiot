import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/order/v2/cubit/service_choosen_bloc.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/widgets/bloc_to_page.dart';
import '../../../../../shared/style_app/init_style.dart';
import '../../../../../shared/utils/delay_callback.dart';
import '../../../../base/dialog.dart';
import '../../../../base/text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/size_device.dart';
import '../../../../constants/spacing.dart';
import '../../../../constants/typography.dart';
import '../../../../di/di.dart';
import '../../../../features_v2/blocs/customer/customer_manager_bloc.dart';
import '../../../../features_v2/blocs/state/init_state.dart';
import '../../../../router/router.gr.dart';
import '../../../../shared/utils/event.dart';
import '../../../customer/cubit/customer_cubit.dart';
import '../../../customer/data/mapper/customer_entity_mapper.dart';
import '../../../customer/domain/entities/customer_entity.dart';
import '../../cubit/order_create_cubit/order_create_state.dart';
import '../cubit/order_create_v2_cubit.dart';
import '../cubit/order_create_v2_state.dart';
import '../widget/customer_fast_create_view.dart';
import '../widget/customer_view.dart';
import '../widget/service_ord/choose_service_for_order.dart';
import 'overlay_customer_item.dart';
import 'overlay_service_item.dart';

@RoutePage()
class OrderCreateServicePage extends StatefulWidget {
  const OrderCreateServicePage({
    super.key,
    this.mbUuid,
    this.idBranch,
    required this.typeCreate,
  });

  final String? mbUuid;
  final OrderType typeCreate;
  final int? idBranch;

  @override
  State<OrderCreateServicePage> createState() => _OrderCreateServicePageState();
}

class _OrderCreateServicePageState extends State<OrderCreateServicePage>
    with TickerProviderStateMixin {
  final orderCreateCubit = getIt<OrderCreateV2Bloc>();
  final customerCubit = getIt<CustomerCubit>();
  final CustomerEntityMapper _customerEntityMapper =
      getIt<CustomerEntityMapper>();

  final DelayCallBack delay = DelayCallBack(delay: 500.milliseconds);
  final customerBloc = CustomerManagerCubit();
  final scroll = ScrollController();
  final textCusController = TextEditingController();
  final _scrollController = ScrollController();
  final serviceBloc = ServiceChoosenBloc();
  OverlayEntry? _entry;
  OverlayEntry? _serEntry;
  final GlobalKey _key = GlobalKey();
  final GlobalKey _serKey = GlobalKey();
  final layerLink = LayerLink();
  final serLayerLink = LayerLink();
  final focusNode = FocusNode();
  final serFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    customerBloc.getList();
    serviceBloc.getList();
    _scrollController.onMore(() {
      serviceBloc.getList(isMore: true);
    });
    scroll.onMore(
      () => customerBloc.getList(isMore: true),
    );
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showOverlayCustomer();
      }
    });
    serFocusNode.addListener(() {
      if (serFocusNode.hasFocus) {
        showOverlaySer();
      }
    });
  }

  @override
  void dispose() {
    _entry?.remove();
    focusNode.dispose();
    scroll.dispose();
    textCusController.dispose();
    super.dispose();
  }

  void showOverlayCustomer() {
    customerBloc.getList();
    // Overlay Customer
    final overlay = Overlay.of(context);
    final renderBox = _key.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    _entry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        height: 300,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height + 8),
          child: buildOverlayCustomer(),
        ),
      ),
    );
    overlay.insert(_entry!);
  }

  void showOverlaySer() {
    serviceBloc.getList();
    final overlay2 = Overlay.of(context);
    final renderBox2 = _serKey.currentContext!.findRenderObject() as RenderBox;
    final size2 = renderBox2.size;
    _serEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size2.width,
        height: 300,
        child: CompositedTransformFollower(
          link: serLayerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size2.height + 8),
          child: buildOverlaySer(),
        ),
      ),
    );
    overlay2.insert(_serEntry!);
  }

  void hideOverlay() {
    _entry?.remove();
    _entry = null;
    _serEntry?.remove();
    _serEntry = null;
  }

  Widget buildOverlayCustomer() {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: ColorApp.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: ColorApp.grey79,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: BlocBuilder<CustomerManagerCubit, CubitState>(
        bloc: customerBloc,
        builder: (context, state) {
          return SingleChildScrollView(
            controller: scroll,
            child: LoadListPage(
              state: state,
              height: 200,
              listEmpty: customerBloc.list.isEmpty,
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: 0.pading,
                itemCount: customerBloc.list.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 0,
                ),
                itemBuilder: (context, index) {
                  return customerViewItem(
                    context,
                    customerBloc.list[index],
                    false,
                    onTap: () {
                      final entity = _customerEntityMapper.mapToEntity(
                        customerBloc.list[index],
                      );
                      orderCreateCubit.selectCustomer(entity);
                      hideOverlay();
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildOverlaySer() {
    return Container(
      height: 300,
      decoration: const BoxDecoration(
        color: ColorApp.white,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: ColorApp.grey79,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: _scrollController,
        child: BlocBuilder<ServiceChoosenBloc, CubitState>(
          bloc: serviceBloc,
          builder: (context, state) {
            return LoadListPage(
              state: state,
              height: 200,
              listEmpty: serviceBloc.list.isEmpty,
              child: ListView.separated(
                padding: 0.pading,
                itemBuilder: (context, index) {
                  return OverlayServiceItem(
                    item: serviceBloc.list[index],
                    onTap: (item) {
                      orderCreateCubit.addService(
                        item.copyWith(
                          amount: 1,
                        ),
                      );
                      hideOverlay();
                    },
                  );
                },
                separatorBuilder: (context, index) => const Divider(
                  height: 0,
                ),
                itemCount: serviceBloc.list.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderCreateV2Bloc>(
          create: (context) => orderCreateCubit
            ..init(
              widget.typeCreate,
              mbUuid: widget.mbUuid,
              idBranch: widget.idBranch,
            ),
        ),
        BlocProvider<CustomerCubit>(
          create: (context) => customerCubit,
        ),
      ],
      child: Scaffold(
        backgroundColor: bg_4,
        body: InkWell(
          onTap: () {
            hideOverlay();
            focusNode.unfocus();
            serFocusNode.unfocus();
          },
          child: Container(
            height: heightDevice(context),
            width: widthDevice(context),
            //child: _appBar,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: whiteColor,
                leading: InkWell(
                  onTap: () => context.router.pop(),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: blackColor,
                  ),
                ),
                centerTitle: true,
                title: const Text(
                  'Tạo mới đơn hàng',
                  style: TextStyle(color: blackColor),
                ),
                elevation: 0.1,
              ),
              body: Container(
                padding: 16.padingHor + 8.padingTop,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _headerCustomer(),
                      8.height,
                      _searchCus(),
                      _customerView(),
                      16.height,
                      Text(
                        'Dịch vụ',
                        style: StyleApp.bold(
                          fontSize: 16,
                        ),
                      ),
                      8.height,
                      _searchService(),
                      8.height,
                      ChooseServiceForOrder(
                        orderBloc: orderCreateCubit,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        bottomNavigationBar: _bottomBar,
      ),
    );
  }

  Widget _headerCustomer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Khách hàng',
          style: StyleApp.bold(
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _searchCus() {
    return BlocBuilder<OrderCreateV2Bloc, OrderCreateV2State>(
      builder: (context, state) {
        if (state.customerSelected != null) {
          return const SizedBox();
        }
        return CompositedTransformTarget(
          link: layerLink,
          child: AppInputSupport(
            hintText: 'Tìm tên, SĐT khách hàng',
            controller: textCusController,
            fn: focusNode,
            prefixIcon: const Icon(
              Icons.search_outlined,
            ),
            backgroundColor: ColorApp.white,
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: () async {
                    hideOverlay();
                    focusNode.unfocus();
                    _showBtsCreateCustomer(null);
                  },
                  child: SizedBox(
                    height: 30,
                    child: Center(
                      child: Text(
                        'Tạo mới',
                        style: StyleApp.semibold(
                          fontSize: 16,
                          color: ColorApp.main,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    textCusController.clear();
                    customerBloc.search = '';
                  },
                  child: const Icon(
                    Icons.close,
                  ),
                ),
                14.width,
              ],
            ),
            onChanged: (value) {
              customerBloc.search = value;
            },
            key: _key,
          ),
        );
      },
    );
  }

  Widget _searchService() {
    return CompositedTransformTarget(
      link: serLayerLink,
      child: AppInputSupport(
        hintText: 'Tìm tên, mã dịch vụ',
        prefixIcon: const Icon(
          Icons.search_outlined,
        ),
        fn: serFocusNode,
        key: _serKey,
        backgroundColor: ColorApp.white,
        onChanged: (value) {
          serviceBloc.changeSearch(value);
        },
      ),
    );
  }

  Widget _customerView() {
    return BlocBuilder<OrderCreateV2Bloc, OrderCreateV2State>(
      builder: (context, state) {
        if (state.customerSelected == null) {
          return Padding(
            padding: 24.padingHor + 36.padingVer,
            child: Center(
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Chưa chọn khách hàng\n',
                  style: StyleApp.bold(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Vui lòng tìm và thêm thông tin khách hàng',
                      style: StyleApp.normal(
                        fontSize: 14,
                        color: ColorApp.grey79,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return CustomerView(
          item: state.customerSelected!,
          isSelected: true,
          onUpdated: (customer) {
            _showBtsCreateCustomer(customer);
          },
          onHide: () {
            print('Hide');
            hideOverlay();
          },
        ).padding(8.padingTop);
      },
    );
  }

  Future<void> _showBtsCreateCustomer(CustomerEntity? customer) async {
    context.bottomSheet(
      CustomerFastCreateView(
        customer: customer,
        onConfirm: handleFastCreate,
        onUpdate: handleFastUpdate,
        phone: textCusController.text,
        onCancel: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void handleFastCreate(String phone, String name) {
    Navigator.pop(context);
    DialogUtils.showLoadingDialog(
      context,
      'Đang tạo khách hàng vui lòng đợi',
    );
    customerCubit.fastCreate(phone, name).then((value) async {
      Navigator.of(context).pop();
      if (value.code == 200) {
        await DialogUtils.showSuccessDialog(
          context,
          barrierDismissible: true,
          content: 'Tạo khách hàng thành công',
        );
        orderCreateCubit.selectCustomer(value.data);
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
          content: 'Tạo khách hàng thất bại ${value.message}',
        );
      }
    });
  }

  void handleFastUpdate(CustomerEntity? customer) {
    if (customer == null) return;
    Navigator.pop(context);
    DialogUtils.showLoadingDialog(
      context,
      'Đang cập nhật khách hàng vui lòng đợi',
    );
    customerCubit.fastUpdate(customer).then((value) async {
      Navigator.of(context).pop();
      if (value.code == 200) {
        await DialogUtils.showSuccessDialog(
          context,
          content: 'Cập nhật khách hàng thành công',
          barrierDismissible: true,
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
          content: 'Cập nhật khách hàng thất bại ${value.message}',
        );
      }
    });
  }

  Widget get _bottomBar {
    return BlocBuilder<OrderCreateV2Bloc, OrderCreateV2State>(
      builder: (context, state) {
        final canOrder = state.customerSelected != null &&
            (state.variantSelected.isNotEmpty ||
                state.serviceSelected.isNotEmpty);
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: whiteColor,
              padding: const EdgeInsets.symmetric(
                vertical: sp12,
                horizontal: sp16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tổng tiền',
                        style: p6.copyWith(color: greyColor),
                      ),
                      Text(
                        '${FormatCurrency(state.total)}đ',
                        style: p5.copyWith(color: mainColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: sp12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(sp12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(sp12),
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(sp12),
                              ),
                              border: Border.all(
                                color: greyColor,
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                context.router.maybePop();
                              },
                              child: const Center(
                                child: Text(
                                  'Huỷ bỏ',
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: sp12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(sp12),
                            decoration: BoxDecoration(
                              color: !canOrder ? greyColor : mainColor,
                              borderRadius: const BorderRadius.all(
                                Radius.circular(sp12),
                              ),
                            ),
                            child: InkWell(
                              onTap: () {
                                if (!canOrder) {
                                  return;
                                }
                                _createOrder();
                              },
                              child: const Center(
                                child: Text(
                                  'Xác nhận đơn',
                                  style: TextStyle(color: whiteColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  void _createOrder() {
    context.router.push(OrderConfirmRoute(myBloc: orderCreateCubit));
  }
}
