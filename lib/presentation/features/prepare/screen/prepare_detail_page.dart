import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/base/row_item.dart';
import 'package:pharmago/presentation/base/text_field.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/constants/typography.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product/domain/entities/product_entity.dart';
import 'package:pharmago/presentation/features/prepare/cubit/prepare_cubit.dart';
import 'package:pharmago/presentation/features/prepare/cubit/prepare_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/constants/pref_key.dart';

@RoutePage()
class PrepareDetailPage extends StatefulWidget {
  final int id;
  const PrepareDetailPage({super.key, required this.id});

  @override
  State<PrepareDetailPage> createState() => _PrepareDetailPageState();
}

class _PrepareDetailPageState extends State<PrepareDetailPage> {
  final myBloc = getIt.get<PrepareCubit>();
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: BaseAppBar(title: 'Chi tiết dạng bào chế', actions: [
          InkWell(
              onTap: () async {
                await context.router.push(PrepareUpdateRoute(id: widget.id));
                await myBloc.getDetail(context, widget.id);
                myBloc.entityILC.onRefresh();
              },
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Icon(Icons.edit_outlined, size: 25, color: bg_1))),
          InkWell(
              onTap: () => myBloc.delete(context, widget.id, true),
              child: Container(
                  margin: EdgeInsets.fromLTRB(10, 5, 10, 10),
                  decoration: BoxDecoration(color: Colors.white),
                  child: Icon(Icons.delete_outline, size: 25, color: bg_1)))
        ]),
        body: Container(
            margin: const EdgeInsets.all(sp16),
            child: BlocProvider<PrepareCubit>(
                create: (context) => myBloc..getDetail(context, widget.id),
                child: BlocBuilder<PrepareCubit, PrepareState>(
                    builder: (context, state) {
                  return SingleChildScrollView(
                    controller: myBloc.scrollController,
                    child: Column(children: [
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: sp24, horizontal: sp16),
                          width: widthDevice(context),
                          decoration:
                              BoxDecoration(color: whiteColor, boxShadow: [
                            BoxShadow(
                                color: blackColor.withOpacity(0.1),
                                offset: const Offset(1, 1),
                                blurRadius: 1)
                          ]),
                          child: Column(children: [
                            Container(
                                alignment: Alignment.centerLeft,
                                child:
                                    Text('Thông tin dạng bào chế', style: p3)),
                            Divider(height: 15, color: borderColor_2),
                            gapHeight(sp12),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text('Dạng thuốc tiêm', style: p3)),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(state.item.name, style: p6)),
                            gapHeight(sp12),
                            Container(
                                alignment: Alignment.centerLeft,
                                child: Text(state.item.description,
                                    style: p6.copyWith(color: borderColor_4))),
                            gapHeight(sp12),
                            RowItem(
                                title: 'Người tạo',
                                content: state.item.userCreatedName),
                            gapHeight(sp12),
                            RowItem(
                                title: 'Thời gian tạo',
                                content: state.item.createdAt),
                            gapHeight(sp12),
                            RowItem(
                                title: 'Người cập nhật',
                                content: state.item.userCreatedName),
                            gapHeight(sp12),
                            RowItem(
                                title: 'Thời gian cập nhật',
                                content: state.item.createdAt),
                            gapHeight(sp12),
                          ])),
                      gapHeight(sp28),
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text('Danh sách sản phẩm', style: p3)),
                      gapHeight(sp16),
                      BlocBuilder<PrepareCubit, PrepareState>(
                          builder: (context, state) {
                        return SingleChildScrollView(
                            controller: myBloc.scrollController,
                            child: Column(children: [
                              AppInputSupport(
                                  hintText: 'Tìm kiếm sản phẩm',
                                  backgroundColor: whiteColor,
                                  onConfirm: myBloc.changeSearch,
                                  prefixIcon: const Icon(Icons.search_rounded)),
                              gapHeight(sp16),
                              RowItem(title: 'Tổng số sản phẩm', content: '0'),
                              InfiniteList(
                                shrinkWrap: true,
                                getData: (page) => myBloc.getProducts(page),
                                itemBuilder: (context, item, index) =>
                                    _oneItem(item),
                                scrollController: myBloc.scrollController,
                                infiniteListController: myBloc.productsILC,
                                circularProgressIndicator: const BaseLoading(),
                              ),
                            ]));
                      })
                    ]),
                  );
                }))),
      );

  Widget _oneItem(ProductEntity item) => Container(
      padding: const EdgeInsets.all(sp16),
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(sp12),
        boxShadow: [
          BoxShadow(
            color: blackColor.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(children: [
        Row(children: [
          Stack(children: [
            Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              height: sp48,
              width: sp48,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: BaseCacheImage(
                      url: item.image?[0] ?? PrefKeys.imgProductDefault)),
            ),
            Positioned(
                bottom: 7,
                left: sp48 + 4,
                child: Icon(Icons.circle, size: 10, color: green_1))
          ]),
          gapWidth(sp12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Mã lô: ${item.code}', style: p5.copyWith(color: blackColor)),
            Text('${item.name}', style: p6.copyWith(color: accentColor_7)),
          ])
        ]),
        gapHeight(sp8),
        Row(children: [
          Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
              decoration: BoxDecoration(
                  color: green_2,
                  borderRadius: BorderRadius.all(Radius.circular(4))),
              child: Text("Đang bán", style: p3.copyWith(color: green_1))),
        ]),
        gapHeight(sp8),
        RowItem(
          title: 'Số mẫu mã',
          content: '16',
        ),
        gapHeight(sp12),
      ]));
}
