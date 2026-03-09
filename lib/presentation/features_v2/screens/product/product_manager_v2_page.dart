import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/config/role/check_role_per.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_filter_prod.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/product_list_item.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../../../../shared/components/button/action_btn.dart';
import '../../../../shared/components/button/label_button.dart';
import '../../../../shared/components/widgets/divider_custom.dart';
import '../../../../shared/components/widgets/empty_view.dart';
import '../../../../shared/components/widgets/search_filter.dart';
import '../../../base/loading.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../../config/role/permission/index.dart';
import '../../blocs/enum/bloc_status.dart';
import '../../blocs/product/product_manager_bloc.dart';
import '../../blocs/state/cubit_state.dart';
import 'package:barcode/barcode.dart' as bc;

@RoutePage()
class ProductManagerV2Page extends StatefulWidget {
  const ProductManagerV2Page({
    super.key,
    this.isClonePrd,
  });
  final bool? isClonePrd;

  @override
  State<ProductManagerV2Page> createState() => _ProductManagerV2PageState();
}

class _ProductManagerV2PageState extends State<ProductManagerV2Page> {
  final bloc = ProductManagerBloc();
  late ScrollController scroll;
  late TextEditingController search;

  bool canAdd = isAdmin && checkPermission(PerProductEnum.CREATE.code);

  @override
  void initState() {
    scroll = ScrollController();
    search = TextEditingController();
    scroll.onMore(() => bloc.getList(isMore: true));
    bloc.getList();
    super.initState();
  }

  @override
  void dispose() {
    bloc.close();
    scroll.dispose();
    search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTitleCenter(
        title: 'Quản lý sản phẩm',
        actions: [_buildMenu(), 16.width],
      ),
      body: Container(
        padding: 16.padingHor + 16.padingTop,
        child: RefreshIndicator(
          onRefresh: () async {
            bloc.getList();
          },
          child: BlocBuilder<ProductManagerBloc, CubitState>(
            bloc: bloc,
            builder: (context, state) {
              print('====BlocBuilder====ProductManagerBloc');
              return Column(
                children: [
                  _buildSearchAndFilter(),
                  12.height,
                  _buidHeaderList(),
                  8.height,
                  BlocBuilder<ProductManagerBloc, CubitState>(
                    bloc: bloc,
                    builder: (context, state) {
                      if (state.status == BlocStatus.loading &&
                          bloc.count == 0) {
                        return const BaseLoading();
                      }
                      return _buildList();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
      bottomNavigationBar: BlocBuilder<ProductManagerBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          return Visibility(
            visible: bloc.canSelectPrd == true,
            child: Container(
              padding: 16.pading,
              child: Row(
                children: [
                  ExtraButton(
                    borderColor: AppColors.border_disabled,
                    borderRadius: 999,
                    title: 'Huỷ bỏ',
                    event: () {
                      bloc.onTogglePrinterBarCode(false);
                    },
                  ).expanded(),
                  16.width,
                  MainButtonV2(
                    radius: 999,
                    title: 'In tem mã (${bloc.list.length})',
                    icon: const Icon(Icons.print),
                    onTap: () {
                      context.router
                          .push(PrintBarcodeRoute(prds: bloc.listSelect!));
                    },
                  ).expanded(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton(
      offset: const Offset(0, 30),
      itemBuilder: (context) {
        return [
          const PopupMenuItem<String>(
            value: '0',
            child: Text('In mã tem'),
          ),
        ];
      },
      onSelected: (value) {
        switch (value) {
          case '0':
            bloc.onTogglePrinterBarCode(true);
          default:
        }
      },
      child: const Icon(Icons.more_vert),
    );
  }

  Column _buidSelectList() {
    return Column(
      children: [
        if (bloc.listSelect?.isEmpty == true)
          EmptyComfirm(text: 'Chưa có sản phẩm được chọn')
        else ...[
          ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final prd = bloc.listSelect![index];

              return ProductListItem(
                onUpdate: (p0) => bloc.onUpdatePrd(p0),
                showUpdateStock: true,
                model: prd,
              );
            },
            separatorBuilder: (context, index) => DividerCustom(),
            itemCount: bloc.isShow ? (bloc.listSelect?.length ?? 0) : 1,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          ),
          Row(
            children: [
              DividerCustom().padding(8.padingRight).expanded(),
              InkWell(
                onTap: () => bloc.showHide(),
                child: Row(
                  children: [
                    Icon(
                      bloc.isShow
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down_outlined,
                    ),
                    const Text(
                      'Chọn thêm sản phẩm',
                      style: s12w400,
                    ),
                    Visibility(
                      visible: bloc.listSelect?.isNotEmpty == true,
                      child: Text(
                        ' (${bloc.listSelect?.length})',
                        style: s12w400,
                      ),
                    ),
                  ],
                ),
              ),
              DividerCustom().padding(8.padingLeft).expanded(),
            ],
          ).padding(12.padingVer),
        ],
      ],
    );
  }

  Widget _buildSearchAndFilter() {
    return SearchFilterCustom(
      hintText: 'Tìm tên, mã vạch sản phẩm',
      value: bloc.search,
      onChange: (value) {
        bloc.search = value;
      },
      controller: search,
      prefix: InkWell(
        onTap: _handleQr,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: 1.pading.copyWith(right: 0),
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.bg_secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(999),
                    bottomLeft: Radius.circular(999),
                  ),
                ),
                height: 48,
                width: 48,
                alignment: Alignment.center,
                child: FaIcon(iconCode: 'f465', type: FaIconType.solid),
              ),
            ),
            const VerticalDivider(
              color: AppColors.input_borderDefault,
              thickness: 1,
              width: 0,
            ).size(height: 48),
            8.width,
            const Icon(
              Icons.search,
              color: AppColors.input_iconDefault,
            ),
            4.width,
          ],
        ),
      ),
      isActive: bloc.isSort,
      onTap: () {
        context.bottomSheet(
          BtsFilterProd(
            active: bloc.active,
            category: bloc.category,
            brand: bloc.brand,
            type: bloc.type,
            price: bloc.price,
            company: null,
            onChange: (active, category, brand, type, price, company) {
              bloc.changeFilter(
                active: active,
                category: category,
                brand: brand,
                type: type,
                price: price,
              );
            },
          ),
        );
      },
    );
  }

  Column _buidHeaderList() {
    return Column(
      children: [
        Row(
          children: [
            if (bloc.canSelectPrd == true) ...[
              BaseCheckbox(
                value: bloc.isSelectAll ?? false,
                onChanged: (value) {
                  bloc.onToggleAllPrd(value ?? false);
                },
              ),
              8.width,
            ],
            Text(
              'Tất cả',
              style: AppStyle.bodyBsMedium
                  .copyWith(color: AppColors.text_tertiary),
            ).expanded(),
            12.width,
            if (canAdd && widget.isClonePrd != true)
              LabelButton(
                onPressed: canAdd
                    ? () {
                        context.router
                            .push(ProductCreateV2Route())
                            .then((value) {
                          if (value == true) {
                            bloc.getList();
                          }
                        });
                      }
                    : context.permissionDenied(),
                label: 'Thêm sản phẩm',
                backgroundColor:
                    AppColors.button_neutral_alpha_backgroundDefault,
                labelStyle: AppStyle.bodyBsMedium.copyWith(
                  color: AppColors.button_neutral_alpha_textDefault,
                ),
                spaceIcon: 4,
                suffixIcon: const Icon(
                  Icons.add,
                  color: AppColors.button_neutral_alpha_textDefault,
                  size: 20,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildList() {
    if (bloc.state.status == BlocStatus.loading && bloc.page == 1) {
      return const BaseLoading();
    }
    if (bloc.list.isEmpty) {
      return EmptyComfirm(
        labelBtn: 'Thêm sản phẩm',
        text: 'Chưa có sản phẩm',
        onPressed: (canAdd && widget.isClonePrd != true)
            ? () {
                context.router.push(ProductCreateV2Route()).then((value) {
                  if (value == true) {
                    bloc.getList();
                  }
                });
              }
            : null,
        svgAsset: 'assets/icons/ic_cube.svg',
        suffixIcon: const Icon(
          Icons.add,
          color: AppColors.button_brand_solid_iconDefault,
          size: 20,
        ),
      );
    }

    return SingleChildScrollView(
      controller: scroll,
      child: Column(
        children: [
          Visibility(
            visible: bloc.canSelectPrd == true,
            child: _buidSelectList(),
          ),
          DividerCustom(),
          ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final prd = bloc.list[index];

              return InkWell(
                onTap: () async {
                  if (bloc.canSelectPrd != true) {
                    final result = await context.router.push(
                      ProductDetailV2Route(
                        id: prd.id ?? -1,
                        onRefresh: () => bloc.getList(),
                      ),
                    );
                    if (result == true) {
                      bloc.getList();
                    }
                  } else {
                    bloc.onToggleProduct(prd);
                  }
                },
                child: Row(
                  children: [
                    if (bloc.canSelectPrd == true)
                      BaseCheckbox(
                        value: prd.isSelected,
                        onChanged: (value) => bloc.onToggleProduct(prd),
                      ).padding(8.padingRight),
                    ProductListItem(
                      onChanged: (p0) => bloc.onToggleProduct(prd),
                      showUpdateStock: false,
                      model: prd,
                      onUpdate: (p0) => bloc.onUpdatePrd(p0),
                    ).expanded(),
                    // BarcodeWidget(
                    //   bloc.list[index].barcode ?? '',
                    //   const Size(300, 100),
                    // )
                    // buildBarcode(
                    //   bc.Barcode.code39(),
                    //   'CODE 39',
                    // )
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => DividerCustom(),
            itemCount: bloc.list.length,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
          ),
          SizedBox(
            height: 50,
            child: bloc.state.status == BlocStatus.loading
                ? const BaseLoading(
                    height: 50,
                  )
                : null,
          ),
        ],
      ),
    ).expanded();
  }

  void buildBarcode(
    bc.Barcode bc,
    String data, {
    String? filename,
    double? width,
    double? height,
    double? fontHeight,
  }) {
    /// Create the Barcode
    final svg = bc.toSvg(
      data,
      width: width ?? 200,
      height: height ?? 80,
      fontHeight: fontHeight,
    );

    // Save the image
    filename ??= bc.name.replaceAll(RegExp(r'\s'), '-').toLowerCase();
    File('$filename.svg').writeAsStringSync(svg);
  }

  void _handleQr() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SimpleBarcodeScannerPage(),
      ),
    ).then((value) async {
      if (value != null && value is String) {
        final res = await bloc.checkIsExist(value);
        await showCupertinoModalPopup(
          context: context,
          builder: (context) {
            return CupertinoTheme(
              data: const CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  primaryColor: AppColors.bg_primary,
                ),
                barBackgroundColor: AppColors.bg_primary,
              ),
              child: CupertinoActionSheet(
                cancelButton: ActionBtn(
                  color: null,
                  onTap: () => context.pop(),
                  title: 'Huỷ bỏ',
                ),
                actions: [
                  ActionBtn(
                    title: res == null ? 'Sản phẩm mới' : 'Thao tác',
                    onTap: () {},
                    style: AppStyle.bodyBsSemiBold.copyWith(
                      color: AppColors.text_quaternary,
                    ),
                  ),
                  if (res == null && canAdd)
                    ActionBtn(
                      title: 'Thêm mới',
                      onTap: canAdd
                          ? () async {
                              context.router
                                  .push(ProductCreateV2Route(barcode: value))
                                  .then((value) {
                                if (value == true) {
                                  bloc.getList();
                                }
                              });
                            }
                          : () => context.permissionDenied(),
                    ),
                  if (res != null) ...[
                    ActionBtn(
                      title: 'Xem chi tiết',
                      onTap: () async {
                        context.router.push(
                          ProductDetailV2Route(
                            id: res.id ?? -1,
                            onRefresh: () {
                              bloc.getList();
                            },
                          ),
                        );
                      },
                    ),
                    ActionBtn(
                      title: 'Nhập kho',
                      onTap: () async {
                        context.router.push(
                          WarehouseImportRoute(model: res),
                        );
                      },
                    ),
                  ],
                ],
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Không tìm thấy mã vạch'),
          ),
        );
      }
    });
  }
}
