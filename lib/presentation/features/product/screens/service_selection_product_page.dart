import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/features/product/cubit/product_manager_cubit/product_manager_cubit.dart';
import 'package:pharmago/presentation/features/product/cubit/product_manager_cubit/product_manager_state.dart';
import 'package:pharmago/presentation/features/product/cubit/service_create_cubit/service_create_cubit.dart';
import 'package:pharmago/presentation/features/product/cubit/service_selection_product_cubit/service_selection_product_state.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../base/app_bar.dart';
import '../../../base/button.dart';
import '../../../base/cache_image.dart';
import '../../../base/check_box.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../cubit/service_selection_product_cubit/service_selection_product_cubit.dart';

@RoutePage()
class ServiceSelectionProductPage extends StatefulWidget {
  const ServiceSelectionProductPage(
      {required this.serviceCreateCubit, super.key});

  final ServiceCreateCubit serviceCreateCubit;

  @override
  State<ServiceSelectionProductPage> createState() =>
      _ServiceSelectionProductPageState();
}

class _ServiceSelectionProductPageState
    extends State<ServiceSelectionProductPage> {
  final myBloc = getIt.get<ProductManagerCubit>();
  final serviceSelectionProductCubit =
      getIt.get<ServiceSelectionProductCubit>();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => myBloc,
        ),
        BlocProvider(
          create: (context) => widget.serviceCreateCubit,
        ),
        BlocProvider(
          create: (context) => serviceSelectionProductCubit,
        ),
      ],
      child: BlocBuilder<ProductManagerCubit, ProductManagerState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: bg_5,
            appBar: const BaseAppBar(
              title: 'Chọn sản phẩm',
            ),
            body: Container(
              padding: const EdgeInsets.all(sp16).copyWith(top: sp0),
              decoration: BoxDecoration(
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(sp12)),
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.1),
                    offset: const Offset(1, 1),
                    blurRadius: 1,
                  ),
                ],
              ),
              child: RefreshIndicator(
                onRefresh: () async {
                  myBloc.productLibraryILC.onRefresh();
                },
                child: ListView(
                  controller: myBloc.scrollController,
                  children: [
                    gapHeight(sp16),
                    AppInputSupport(
                      hintText: 'Tìm kiếm sản phẩm',
                      prefixIcon: const Icon(Icons.search_rounded),
                      backgroundColor: whiteColor,
                      onConfirm: myBloc.searchChange,
                    ),
                    gapHeight(sp16),
                    InfiniteList(
                      shrinkWrap: true,
                      getData: (page) async {
                        return myBloc.getVariant(page);
                      },
                      itemBuilder: (context, item, index) {
                        return Container(
                          padding: const EdgeInsets.all(sp16),
                          decoration: BoxDecoration(
                            color: whiteColor,
                            borderRadius: BorderRadius.circular(sp12),
                            boxShadow: [
                              BoxShadow(
                                color: blackColor.withOpacity(0.1),
                                offset: const Offset(1, 1),
                                blurRadius: 1,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  BlocBuilder<ServiceSelectionProductCubit,
                                      ServiceSelectionProductState>(
                                    builder: (context, state) {
                                      return BaseCheckbox(
                                        value: state.variants.contains(item),
                                        onChanged: (value) {
                                          if (value != null) {
                                            if (value) {
                                              serviceSelectionProductCubit
                                                  .addVariant(
                                                item,
                                              );
                                            } else {
                                              serviceSelectionProductCubit
                                                  .removeVariant(
                                                item,
                                              );
                                            }
                                          }
                                        },
                                      );
                                    },
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      leading: SizedBox(
                                        height: sp48,
                                        width: sp48,
                                        child: BaseCacheImage(
                                          url: (item.media?.isNotEmpty ?? false)
                                              ? (item.media ??
                                                  PrefKeys.imgProductDefault)
                                              : PrefKeys.imgProductDefault,
                                        ),
                                      ),
                                      title: Text(
                                        item.name ?? '',
                                        style: p5.copyWith(
                                          color: blackColor,
                                        ),
                                      ),
                                      subtitle: Text(
                                        item.code ?? '',
                                        style: p6.copyWith(
                                          color: greyColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              gapHeight(sp16),
                              const RowItem(title: 'Gia nhap', content: 'Fix'),
                              gapHeight(sp12),
                              const RowItem(title: 'So luong', content: 'Fix'),
                              gapHeight(sp12),
                              const RowItem(title: 'Tong tien', content: 'Fix'),
                            ],
                          ),
                        );
                      },
                      scrollController: myBloc.scrollController,
                      infiniteListController: myBloc.productLibraryILC,
                      circularProgressIndicator: const BaseLoading(),
                      noItemFoundWidget: const EmptyContainer(),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                boxShadow: [
                  BoxShadow(
                    color: blackColor.withOpacity(0.1),
                    offset: const Offset(0, -1),
                    blurRadius: sp4,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(sp16),
              width: double.infinity,
              child: Row(
                children: [
                   Expanded(
                    child: ExtraButton(
                      title: 'Huỷ bỏ',
                      event: () {
                        context.router.maybePop(false);
                      },
                    ),
                  ),
                  gapWidth(sp16),
                   Expanded(
                    child: MainButton(
                      title: 'Xác nhận',
                      event: (){

                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
