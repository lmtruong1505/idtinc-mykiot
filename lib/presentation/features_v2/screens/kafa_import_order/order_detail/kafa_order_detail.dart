import 'package:auto_route/auto_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/kafa/cancel_order.dart';
import 'package:pharmago/presentation/features_v2/blocs/kafa/kafa_order_detail.bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../blocs/kafa/list_order_kafa.dart';
import '../../../models/kafa/kafa_order_detail.dart';

@RoutePage()
class KafaOrderDetailPage extends StatefulWidget {
  final int id;
  const KafaOrderDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<KafaOrderDetailPage> createState() => _KafaOrderDetailPageState();
}

class _KafaOrderDetailPageState extends State<KafaOrderDetailPage> {
  final bloc = KafaOrderDetailBloc();
  final cancelBloc = CancelOrderKafaBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getData(widget.id);
  }

  _cancelOrder() {
    DialogUtils.showErrorDialog(
      context,
      content: 'Bạn có muốn "Huỷ" đơn hàng này không?',
      titleClose: 'Đóng',
      titleConfirm: 'Xác nhận',
      close: () => context.pop(),
      accept: () {
        cancelBloc.cancel(widget.id);
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CancelOrderKafaBloc, CubitState>(
      bloc: cancelBloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          success: () {
            context.pop();
            bloc.getData(widget.id);
            getIt<ListOrderKafaBloc>().getList();
          },
        );
      },
      child: Scaffold(
        backgroundColor: ColorApp.greyF5,
        appBar: const BaseAppBar(title: 'Chi tiết đơn nhập hàng'),
        body: BlocBuilder<KafaOrderDetailBloc, CubitState>(
          bloc: bloc,
          builder: (context, state) {
            return LoadPage(
              state: state,
              height: null,
              child: _buildBody(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildBtnBar() {
    final status = bloc.state.data?.statusOrderData?.code.toStatusOrder ??
        StatusOrderKafa.pending;
    final total = bloc.state.data?.total ?? 0;
    final discount = bloc.state.data?.discount ?? 0;
    final pay = total - discount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextRow2(
          title: 'Tổng tiền',
          content: pay.formatPrice(type: 'đ'),
          titleStyle: StyleApp.normal(color: ColorApp.grey79),
          contentStyle: StyleApp.semibold(),
        ),
        if (status == StatusOrderKafa.pending) ...[
          16.height,
          MainButtonV2(
            onTap: _cancelOrder,
            title: 'Huỷ',
            backgroundColor: ColorApp.red,
            radius: 6,
          ).size(height: 45),
        ],
        if (status != StatusOrderKafa.pending) context.padding.bottom.height,
      ],
    ).container();
  }

  Widget _buildBody() {
    final model = bloc.state.data;
    if (model == null) {
      return const SingleChildScrollView(
        child: EmptyContainer(
          msg: 'Không tìm thấy thông tin đơn hàng',
        ),
      );
    }
    final status =
        model.statusOrderData?.code.toStatusOrder ?? StatusOrderKafa.pending;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SingleChildScrollView(
          padding: 16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        model.code ?? '',
                        style: StyleApp.medium(),
                      ),
                      4.height,
                      Text(
                        model.createdAt?.toDate
                                .fomatCustom(fomat: 'HH:mm dd/MM/yyyy') ??
                            '',
                        style: StyleApp.medium(color: ColorApp.grey79),
                      ),
                    ],
                  ).expanded(),
                  Row(
                    children: [
                      Icon(
                        status.icon,
                        size: 15,
                        color: status.color,
                      ),
                      4.width,
                      Text(
                        status.title,
                        style: StyleApp.medium(
                          color: status.color,
                        ),
                      ),
                    ],
                  ),
                ],
              ).container(),
              // 16.height,
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              //   children: [
              //     TextRow2(
              //       title: 'Người tạo',
              //       content: model.accountData?.fullName ?? 'Chưa có dữ liệu',
              //       contentStyle: StyleApp.semibold(),
              //     ),
              //     16.height,
              //     TextRow2(
              //       title: 'Vai trò',
              //       content: model.accountData?.roleName ?? 'Chưa có thông tin',
              //       contentStyle: StyleApp.semibold(),
              //     ),
              //   ],
              // ).container(),
              16.height,
              _buildDelivery(),
              16.height,
              TextRow2(
                title: 'Hóa đơn đỏ',
                content: model.orderRed == true ? 'Có' : 'Không',
                titleStyle: StyleApp.semibold(),
                contentStyle: StyleApp.semibold(),
              ).container(),
              16.height,
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Ghi chú đơn hàng',
                    style: StyleApp.normal(
                      color: ColorApp.grey79,
                    ),
                  ),
                  8.height,
                  Text(
                    model.note ?? 'Chưa có thông tin',
                    style: StyleApp.semibold(),
                  ),
                ],
              ).container(),
              24.height,
              _buildPrd(),
              16.height,
              _buildPromotion(),
              16.height,
              context.padding.bottom.height,
            ],
          ),
        ).expanded(),
        _buildBtnBar(),
      ],
    );
  }

  Widget _buildPromotion() {
    final promotions = bloc.state.data?.discountOrder ?? [];
    if (promotions.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Giảm giá đơn hàng',
          style: StyleApp.normal(color: ColorApp.grey79),
        ),
        8.height,
        ...List.generate(
          promotions.length,
          (index) => TextRow3(
            title:
                'Giá trị tối thiểu ${promotions[index].valueMin.formatPrice(type: 'đ')}',
            content: (promotions[index].discountValue.validator *
                    promotions[index].timesApplyPromotion.validator)
                .formatPrice(
              type: promotions[index].typeDiscount == 'Phần trăm' ? '%' : 'đ',
            ),
          ).padding(8.padingTop),
        ),
      ],
    ).container();
  }

  Widget _buildPrd() {
    final orderItems = bloc.state.data?.orderitems ?? [];
    final sell = orderItems
        .where(
          (element) => element.typeData == TypeOderItemKafa.sell.code,
        )
        .toList();
    final bonus = orderItems
        .where(
          (element) => element.typeData == TypeOderItemKafa.bonus.code,
        )
        .toList();

    final customer = orderItems
        .where(
          (element) => element.typeData == TypeOderItemKafa.customer.code,
        )
        .toList();

    for (int i = 0; i < sell.length; i++) {
      sell[i].children = bonus
          .where(
            (e) => e.variantPromotion == sell[i].variant,
          )
          .toList();
    }
    final bonusOrder = bonus
        .where(
          (e) => e.variantPromotion == null,
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Danh sách sản phẩm (${sell.length})',
          style: StyleApp.semibold(fontSize: 16),
        ),
        16.height,
        _buildItem(
          name: 'Sản phẩm',
          price: 'Thành tiền',
          quantity: 'Số lượng',
          style: StyleApp.normal(color: ColorApp.grey79),
        ),
        const Divider(
          height: 32,
        ),
        ListView.separated(
          padding: 0.pading,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildItem(
                name: sell[index].variantData?.title ?? '',
                price: sell[index].total.formatPrice(type: 'đ'),
                quantity: sell[index].quantity.formatPrice(),
                style: StyleApp.medium(),
              ),
              ...(sell[index].children ?? []).map(
                (e) => _buildItem(
                  name: e.variantData?.title ?? '',
                  price: '0đ',
                  quantity: e.quantity.formatPrice(),
                  style: StyleApp.medium(
                    color: ColorApp.grey79,
                  ),
                ).padding(8.padingTop),
              ),
            ],
          ),
          separatorBuilder: (context, index) => 16.height,
          itemCount: sell.length,
        ),
        if (bonusOrder.isNotEmpty) ...[
          const Divider(
            height: 32,
          ),
          Text(
            'Sản phẩm tặng kèm',
            style: StyleApp.normal(color: ColorApp.grey79),
          ),
          16.height,
          ListView.separated(
            padding: 0.pading,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return _buildItem(
                name: bonusOrder[index].variantData?.title ?? '',
                price: '0đ',
                quantity: bonusOrder[index].quantity.formatPrice(),
              );
            },
            separatorBuilder: (context, index) => 16.height,
            itemCount: bonusOrder.length,
          ),
        ],
        if (customer.isNotEmpty) ...[
          const Divider(
            height: 32,
          ),
          Text(
            'Sản phẩm tặng cho người tiêu dùng',
            style: StyleApp.normal(color: ColorApp.grey79),
          ),
          16.height,
          ListView.separated(
            padding: 0.pading,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => _buildItem(
              name: customer[index].variantData?.title ?? '',
              price: '0đ',
              quantity: customer[index].quantity.formatPrice(),
            ),
            separatorBuilder: (context, index) => 16.height,
            itemCount: customer.length,
          ),
        ],
      ],
    );
  }

  Widget _buildItem({
    required String name,
    required String price,
    required String quantity,
    TextStyle? style,
  }) {
    return Row(
      children: [
        Text(
          name,
          style: style ?? StyleApp.medium(),
        ).expanded(flex: 2),
        10.width,
        Text(
          quantity,
          style: style ?? StyleApp.medium(),
        ).expanded(flex: 1),
        10.width,
        Text(
          price,
          textAlign: TextAlign.right,
          style: style ?? StyleApp.medium(),
        ).expanded(flex: 1),
      ],
    );
  }

  Widget _buildDelivery() {
    final model = bloc.state.data;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Thông tin nhận hàng',
          style: StyleApp.semibold(
            color: ColorApp.grey79,
          ),
        ),
        4.height,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              model?.accountData?.companyName ?? 'Chưa có thông tin',
              style: StyleApp.semibold(),
            ),
            const Divider(
              height: 32,
              color: ColorApp.greyE2,
            ),
            Row(
              children: [
                const Icon(
                  CupertinoIcons.phone_fill,
                  color: ColorApp.greenE6,
                  size: 18,
                ),
                8.height,
                Text(
                  model?.accountData?.phone ?? 'Chưa có thông tin',
                  style: StyleApp.normal(),
                ).expanded(),
              ],
            ),
            8.height,
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: ColorApp.greenE6,
                  size: 18,
                ),
                8.height,
                Text(
                  model?.accountData?.addressData?.title ?? '',
                  style: StyleApp.normal(),
                ).expanded(),
              ],
            ),
          ],
        ).container(
          border: Border.all(
            color: ColorApp.greyE2,
          ),
        ),
      ],
    ).container();
  }
}
