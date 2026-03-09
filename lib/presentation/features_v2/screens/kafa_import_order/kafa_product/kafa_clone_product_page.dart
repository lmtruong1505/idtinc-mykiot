import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_text.dart';
import 'package:pharmago/presentation/base/base_buttom_bar.dart';
import 'package:pharmago/presentation/base/base_container.dart';
import 'package:pharmago/presentation/base/check_box.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/config/role/check_role_per.dart';
import 'package:pharmago/presentation/config/role/permission/index.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/bloc_status.dart';
import 'package:pharmago/presentation/features_v2/blocs/kafa/kafa_clone_prd_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/product/product_manager_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_filter_prod.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/product_list_item.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/button/action_btn.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/dialog/dialog_confirm.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/components/widgets/search_filter.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

@RoutePage()
class KafaCloneProductPage extends StatefulWidget {
  const KafaCloneProductPage({
    super.key,
    this.isClonePrd,
  });
  final bool? isClonePrd;

  @override
  State<KafaCloneProductPage> createState() => _KafaCloneProductPageState();
}

class _KafaCloneProductPageState extends State<KafaCloneProductPage> {
  final bloc = getIt<KafaCloneProductBloc>();
  late ScrollController scroll;
  late TextEditingController search;

  bool canAdd = isAdmin && checkPermission(PerProductEnum.CREATE.code);

  @override
  void initState() {
    scroll = ScrollController();
    search = TextEditingController();
    bloc.init(widget.isClonePrd);
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

  void _srollToTop() {
    if (scroll.offset > 0) {
      scroll.animateTo(
        0,
        duration: 500.milliseconds,
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarTitleCenter(
          title: 'Chọn sản phẩm',
          back: () => context.pop(result: true),
        ),
        body: Container(
          padding: 16.padingHor + 16.padingTop,
          child: RefreshIndicator(
            onRefresh: () async {
              bloc.getList();
            },
            child: BlocBuilder<KafaCloneProductBloc, CubitState>(
              bloc: bloc,
              builder: (context, state) {
                return Column(
                  children: [
                    _buildSearchAndFilter(),
                    12.height,
                    BlocBuilder<KafaCloneProductBloc, CubitState>(
                      bloc: bloc,
                      builder: (context, state) {
                        if (state.status == BlocStatus.loading &&
                            bloc.count == 0) {
                          return const BaseLoading();
                        }
                        return SingleChildScrollView(
                          controller: scroll,
                          child: Column(
                            children: [
                              _buidHeaderList(),
                              8.height,
                              _buildList(),
                            ],
                          ),
                        );
                      },
                    ).expanded()
                  ],
                );
              },
            ),
          ),
        ),
        floatingActionButton: InkWell(
          onTap: _srollToTop,
          child: BaseContainer(
            color: AppColors.black.withOpacity(0.35),
            width: 48,
            height: 48,
            borderRadius: 999,
            child: const Icon(
              Icons.arrow_upward,
              color: AppColors.white,
            ),
          ),
        ),
        bottomNavigationBar: BlocConsumer<KafaCloneProductBloc, CubitState>(
          bloc: bloc,
          builder: (context, state) {
            return BaseBottomBar(
              child: Padding(
                padding: 16.padingHor,
                child: MainButtonV2(
                  radius: 999,
                  onTap: bloc.validSelect ? () => bloc.clonePrds() : null,
                  title:
                      'Tạo danh sách sản phẩm ${bloc.validSelect ? '(${bloc.quantityPrdSelect})' : ''}',
                ),
              ),
            );
          },
          listener: (context, state) {
            if (state.status == BlocStatus.submit) {
              DialogUtils.showLoadingDialog(
                context,
                'Đang tạo sản phẩm vui lòng lòng đợi',
              );
            } else if (state.status == BlocStatus.submitSuccess) {
              Navigator.of(context).pop();
              DialogUtils.showSuccessDialog(
                context,
                content: 'Tạo sản phẩm thành công',
                barrierDismissible: true,
                close: () => Navigator.of(context).pop(),
                accept: () => Navigator.of(context).pop(),
              );
            } else if (state.status == BlocStatus.submitFailure) {
              Navigator.of(context).pop();
              DialogUtils.showErrorDialog(
                context,
                content: 'Tạo sản phẩm không thành công. ${state.msg}',
                close: () => Navigator.of(context).pop(),
                accept: () => Navigator.of(context).pop(),
              );
            }
          },
        ));
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
        if (bloc.listSelect.isEmpty)
          EmptyComfirm(text: 'Chưa có sản phẩm được chọn')
        else
          ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final prd = bloc.listSelect[index];

              return ProductListItem(
                // onChanged: (p0) => bloc.onToggleProduct(prd),
                onUpdate: (p0) => bloc.onUpdatePrd(p0),
                showUpdateStock: true,
                model: prd,
              );
            },
            separatorBuilder: (context, index) => DividerCustom(),
            itemCount: bloc.isShow ? bloc.listSelect.length : 1,
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
                    visible: bloc.listSelect.isNotEmpty,
                    child: Text(
                      ' (${bloc.listSelect.length})',
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
        onPressed: null,
        svgAsset: 'assets/icons/ic_cube.svg',
        suffixIcon: const Icon(
          Icons.add,
          color: AppColors.button_brand_solid_iconDefault,
          size: 20,
        ),
      );
    }
    return Column(
      children: [
        ListView.separated(
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            // final prd = bloc.list[index];

            return ProductListItem(
              onUpdate: (p0) {
                bloc.hideSelectPrds();

                bloc.onUpdatePrd(p0);
              },
              showUpdateStock: true,
              model: bloc.list[index],
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
    );
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
