import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/base/v2/expanded_section.dart';
import 'package:pharmago/presentation/base/v2/grid_view_custom.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/blocs/wholesale_drug_maket/wholesale_drug_market_bloc.dart';
import 'package:pharmago/presentation/features_v2/screens/kafa_import_order/components/variant_kafa_card.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../../base/svg.dart';
import '../../../../di/di.dart';
import '../components/shopping_cart_btn.dart';

@RoutePage()
class WholesaleDrugMarketPage extends StatefulWidget {
  const WholesaleDrugMarketPage({super.key});

  @override
  State<WholesaleDrugMarketPage> createState() =>
      _WholesaleDrugMarketPageState();
}

class _WholesaleDrugMarketPageState extends State<WholesaleDrugMarketPage> {
  final myBloc = getIt.get<WholesaleDrugMarketBloc>();

  final scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    scroll.onMore(
      () => myBloc.getList(isMore: true),
    );
    myBloc.getList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc,
      child: Scaffold(
        backgroundColor: ColorApp.greyF5,
        appBar: BaseAppBar(
          title: 'Chợ thuốc sỉ',
          actions: [
            InkWell(
              onTap: () {
                myBloc.setShowSearch(!myBloc.showSearch);
                if (myBloc.showSearch) {
                  scroll.animateTo(
                    0,
                    duration: 500.milliseconds,
                    curve: Curves.linear,
                  );
                }
                //context.pushRoute(const FilterPrdRoute());
              },
              child: IcSvg.asset('/ic_search.svg'),
            ),
            12.width,
            ShoppingCartBtn(),
            16.width,
            
          ],
        ),
        body: BlocBuilder<WholesaleDrugMarketBloc, CubitState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: 16.pading,
              controller: scroll,
              child: Column(
                children: [
                  _buildSearch(),
                  _buildType(),
                  _buildProd(),
                  context.padding.bottom.height,
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildType() {
    return ListView.separated(
      itemCount: TypePrdKafa.values.length,
      padding: 16.padingBottom,
      scrollDirection: Axis.horizontal,
      separatorBuilder: (context, index) => 16.width,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          myBloc.setType(TypePrdKafa.values[index]);
        },
        child: Container(
          width: 90,
          height: 110,
          decoration: BoxDecoration(
            color: myBloc.type == TypePrdKafa.values[index]
                ? ColorApp.main
                : Colors.transparent,
            borderRadius: 16.radius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: myBloc.type == TypePrdKafa.values[index]
                      ? ColorApp.white.withOpacity(0.1)
                      : ColorApp.grey79.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: IcSvg.asset(
                    TypePrdKafa.values[index].icon,
                    color: myBloc.type == TypePrdKafa.values[index]
                        ? ColorApp.white
                        : ColorApp.grey79,
                  ),
                ),
              ),
              16.height,
              Text(
                TypePrdKafa.values[index].title,
                style: StyleApp.bold(
                  fontSize: 12,
                  color: myBloc.type == TypePrdKafa.values[index]
                      ? ColorApp.white
                      : ColorApp.black,
                ),
              ),
            ],
          ),
        ),
      ),
    ).size(height: 126);
  }

  Widget _buildSearch() {
    return ExpandedSection(
      isSelected: myBloc.showSearch,
      child: AppInputSupport(
        hintText: 'Tìm theo tên sản phẩm',
        backgroundColor: ColorApp.white,
        padding: EdgeInsets.zero,
        onChanged: myBloc.changeSearch,
        prefixIcon: const Icon(
          Icons.search_outlined,
          color: ColorApp.black,
        ),
        radius: 8,
      ).padding(16.padingBottom),
    );
  }

  Widget _buildProd() {
    return LoadListPage(
      state: myBloc.state,
      listEmpty: myBloc.list.isEmpty,
      height: 200,
      child: GridViewCustom(
        crossAxisCount: 2,
        shrinkWrap: true,
        showFull: true,
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: myBloc.list.length,
        mainAxisExtent: 300,
        itemBuilder: (context, index) {
          final item = myBloc.list[index];
          return InkWell(
            onTap: () {
              context.router.push(VariantKafaDetailRoute(id: item.id!));
            },
            child: VariantKafaCard(item: item),
          );
        },
      ),
    );
  }
}
