import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/base/svg.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product/cubit/price_list_cubit/price_list_cubit.dart';
import 'package:pharmago/presentation/features/product/cubit/price_list_cubit/price_list_state.dart';
import 'package:pharmago/presentation/features/product/domain/entities/price_entity.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/constants/pref_key.dart';

@RoutePage()
class PriceListPage extends StatefulWidget {
  @override
  State<PriceListPage> createState() => _PriceListPageState();
}

class _PriceListPageState extends State<PriceListPage> {
  final myBloc = getIt.get<PriceListCubit>();

  @override
  Widget build(BuildContext context) => BlocProvider<PriceListCubit>(
      create: (context) => myBloc,
      child: BlocBuilder<PriceListCubit, PriceListState>(
          builder: (context, state) => Scaffold(
                backgroundColor: bg_5,
                appBar: const BaseAppBar(
                  title: 'Bảng giá sản phẩm',
                ),
                body: Container(
                  height: heightDevice(context),
                  width: widthDevice(context),
                  padding: const EdgeInsets.symmetric(
                    vertical: sp24,
                    horizontal: sp24,
                  ),
                  child: SingleChildScrollView(
                      controller: myBloc.scrollController,
                      child: Column(children: [
                        Row(children: [
                          Expanded(
                              child: AppInputSupport(
                                  hintText: 'Tìm kiếm theo tên/mã sản phẩm',
                                  // validate: (String? value) {},
                                  backgroundColor: whiteColor,
                                  onConfirm: myBloc.searchChange,
                                  prefixIcon:
                                      const Icon(Icons.search_rounded))),
                          const SizedBox(width: sp16),
                          InkWell(
                              onTap: () async =>
                                  await DialogUtils.showBottomDialogText(
                                      context, SearchPopup()),
                              child: Container(
                                  padding: const EdgeInsets.all(sp16 + 1),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(sp8),
                                    border: Border.all(
                                      color: borderColor_2,
                                    ),
                                    color: whiteColor,
                                  ),
                                  child: IcSvg.img(IcSvg.iconFilter,
                                      color: greyColor)))
                        ]),
                        gapHeight(sp16),
                        InfiniteList(
                            shrinkWrap: true,
                            getData: (page) => myBloc.getPriceList(page),
                            itemBuilder: (context, item, index) =>
                                _oneItem(item),
                            scrollController: myBloc.scrollController,
                            infiniteListController: myBloc.priceILC,
                            circularProgressIndicator: const BaseLoading())
                      ])),
                ),
              )));

  Widget _oneItem(PriceEntity item) => Container(
        padding: const EdgeInsets.all(sp16),
        decoration: BoxDecoration(
            color: whiteColor,
            borderRadius: BorderRadius.circular(sp12),
            boxShadow: [
              BoxShadow(
                  color: blackColor.withOpacity(0.1),
                  blurRadius: 2,
                  offset: const Offset(0, 0))
            ]),
        child: Column(children: [
          Stack(children: [
            ListTile(
                leading: SizedBox(
                    height: sp48,
                    width: sp48,
                    child: BaseCacheImage(
                        url: item.image ?? PrefKeys.imgProductDefault)),
                title: Text(item.name ?? '',
                    style: p5.copyWith(color: blackColor)),
                subtitle: Text(item.code ?? '',
                    style: p6.copyWith(color: greyColor))),
            Positioned(
                top: 0,
                left: sp48 - 5,
                child: InkWell(
                    onTap: () async {
                      final result = await context.router
                          .push(PriceUpdateRoute(priceEntity: item));
                      if (result != null) {
                        // final price = result as PriceEntity;
                        // item = price;
                        // print(price);
                        myBloc.priceILC.onRefresh();
                        // emit(
                        //   state.copyWith(cardData: card),
                        // );
                      }
                    },
                    child: Container(
                        margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(3)),
                            color: Colors.white,
                            border: Border.all(
                                color: Color.fromARGB(255, 171, 168, 168))),
                        child: Icon(Icons.create_outlined, size: 17))))
          ]),
          gapHeight(sp16),
          RowItem(title: 'Đơn vị tính', content: 'Viên'),
          gapHeight(sp12),
          RowItem(title: 'Giá nhập', content: "${item.priceImport ?? 0} VNĐ"),
          gapHeight(sp12),
          RowItem(title: 'Giá bán', content: "${item.priceSell ?? 0} VNĐ"),
        ]),
      );
}

class SearchPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 16, 16, 16),
                    color: Colors.transparent,
                    child: Text("Đặt lại", style: p3.copyWith(color: blue_1)),
                  )),
              Text("Bộ lọc", style: p3),
              InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 5, 16),
                    color: Colors.transparent,
                    child: Text("Áp dụng", style: p3.copyWith(color: blue_1)),
                  ))
            ]),
            SizedBox(height: 20),
            CommonDropdown(
                label: 'Giá nhập',
                items: [
                  DropdownMenuItem(
                      value: 1, child: Text('Khoảng giá 1', style: p6)),
                  DropdownMenuItem(
                      value: 2, child: Text('Khoảng giá 2', style: p6)),
                  DropdownMenuItem(
                      value: 3, child: Text('Khoảng giá 3', style: p6)),
                  DropdownMenuItem(
                      value: 4, child: Text('Khoảng giá 4', style: p6)),
                ],
                hintText: 'Chọn khoảng giá',
                onChanged: (value) => {}),
            CommonDropdown(
                label: 'Giá bán',
                items: [
                  DropdownMenuItem(
                      value: 1, child: Text('Khoảng giá 1', style: p6)),
                  DropdownMenuItem(
                      value: 2, child: Text('Khoảng giá 2', style: p6)),
                  DropdownMenuItem(
                      value: 3, child: Text('Khoảng giá 3', style: p6)),
                  DropdownMenuItem(
                      value: 4, child: Text('Khoảng giá 4', style: p6)),
                ],
                hintText: 'Chọn khoảng giá',
                onChanged: (value) => {}),
            SizedBox(height: 200),
          ]));
}
