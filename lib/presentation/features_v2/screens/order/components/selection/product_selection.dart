import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/order/widgets/scan_view.dart';
import 'package:pharmago/presentation/features_v2/blocs/order_v2/product_selection_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/bts/bts_edit_price_prod.dart';
import 'package:pharmago/presentation/features_v2/screens/order/scan_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../../shared/components/input/overlay_input.dart';
import '../../../../../../shared/components/widgets/empty_view.dart';
import '../../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../models/product/product_v2_model.dart';
import '../../../product/components/product_list_item.dart';
import '../product_order_item.dart';

class ProductSelection extends StatefulWidget {
  const ProductSelection({
    super.key,
    required this.bloc,
    this.ghiChu = false,
    this.isPrescription = false,
  });

  final ProductSelectionBloc bloc;
  final bool ghiChu;
  final bool isPrescription;

  @override
  State<ProductSelection> createState() => _ProductSelectionState();
}

class _ProductSelectionState extends State<ProductSelection> {
  final textCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductSelectionBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sản phẩm',
              style: AppStyle.headingLg,
            ),
            12.height,
            _buildSearch(),
            if (widget.bloc.list.isNotEmpty) ...[
              12.height,
              _buildHuongDan(),
              12.height,
              _buildList(),
            ],
            if (widget.bloc.list.isEmpty)
              EmptyComfirm(
                text: 'Chưa có sản phẩm \n Vui lòng tìm và lựa chọn sản phẩm',
                svgAsset: 'assets/icons/ic_cube.svg',
                suffixIcon: const Icon(
                  Icons.add,
                  color: AppColors.button_brand_solid_iconDefault,
                  size: 20,
                ),
                onPressed: null,
              ),
          ],
        );
      },
    );
  }

  OverlayInput<ProductV2Model> _buildSearch() {
    return OverlayInput<ProductV2Model>(
      itemBuilder: (BuildContext context, item, int index) {
        return ProductListItem(
          model: item,
          showHead: false,
        );
      },
      onChanged: (item) {
        if (item.availableStock == 0 && !widget.isPrescription) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sản phẩm đã hết hàng'),
              backgroundColor: AppColors.ultility_negative_60,
            ),
          );
          return;
        }
        if (!(item.active ?? false) && !widget.isPrescription) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Sản phẩm đã ẩn'),
              backgroundColor: AppColors.ultility_negative_60,
            ),
          );
          return;
        }
        item.quantity = 1;
        widget.bloc.addProduct(item);
      },
      hintText: 'Tìm tên, mã sản phẩm',
      itemHeight: 105,
      lazyLoad: (isMore) {
        if (widget.isPrescription == true) {
          return widget.bloc.getListKafa(textCtrl.text, isMore: isMore);
        } else {
          return widget.bloc.getList(textCtrl.text, isMore: isMore);
        }
      },
      controller: textCtrl,
      borderRadius: 999,
      header: Text(
        'Chọn sản phẩm',
        style: AppStyle.headingMd.copyWith(
          color: AppColors.text_quaternary,
        ),
      ).padding(16.pading.copyWith(top: 12, bottom: 6)),
      elevation: 1,
      prefix: InkWell(
        // onTap: () => handleQrCode(
        //   context: context,
        //   onCode: (value) async {
        //     // textCtrl.text = value;
        //     // widget.bloc.getList(value);
        //     final res = await widget.bloc.checkIsExist(value);
        //     if (res != null) {
        //       widget.bloc.addProduct(res);
        //     } else {
        //       ScaffoldMessenger.of(context).showSnackBar(
        //         const SnackBar(
        //           content: Text('Sản phẩm không tồn tại'),
        //           backgroundColor: AppColors.ultility_positive_60,
        //         ),
        //       );
        //     }
        //   },
        // ),
        onTap: () {
          context.push(
            ScanPage(
              onScan: (type, value) async {
                _callScan(type, value);
                return;
                if (type == TypeScanView.barcode) {
                  final res = await widget.bloc.checkProd(value);
                  if (res != null) {
                    widget.bloc.addProduct(res);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Sản phẩm không tồn tại'),
                        backgroundColor: AppColors.ultility_positive_60,
                        duration: 2.seconds,
                      ),
                    );
                  }
                } else {
                  final res = await widget.bloc.getDonThuoc(value);
                  if (res.code == 200 &&
                      res.data != null &&
                      res.data!.isNotEmpty) {
                    for (final item in res.data!) {
                      widget.bloc.addProduct(item);
                    }
                  } else {
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Đơn thuốc không tồn tại hoặc không có trong workspace',
                        ),
                        backgroundColor: AppColors.ultility_positive_60,
                        duration: 2.seconds,
                      ),
                    );
                  }
                }
              },
            ),
          );
        },
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
    );
  }

  ListView _buildList() {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: widget.bloc.list.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Slidable(
          key: Key(widget.bloc.list[index].id.toString()),
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                flex: 1,
                onPressed: (context) {
                  context
                      .bottomSheet(
                    BtsEditPriceProd(model: widget.bloc.list[index]),
                  )
                      .then((value) {
                    if (value != null && value is ProductV2Model) {
                      widget.bloc.addProduct(value);
                    }
                  });
                },
                backgroundColor: AppColors.ultility_blue,
                foregroundColor: Colors.white,
                icon: Icons.edit,
                label: 'Sửa giá',
              ),
              SlidableAction(
                flex: 1,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                onPressed: (context) => widget.bloc.removeProduct(index),
                backgroundColor: AppColors.ultility_negative_60,
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: 'Xóa',
              ),
            ],
          ),
          child: ProductOrderItem(
            bloc: widget.bloc,
            model: widget.bloc.list[index],
            onUpdate: (model) => widget.bloc.addProduct(model),
            onDelete: () => widget.bloc.removeProduct(index),
            ghiChu: widget.ghiChu,
            isCheckStock: !widget
                .isPrescription, //nếu là phiếu khám thì lấy data trong kafa (0 check tồn)
          ),
        );
      },
      separatorBuilder: (context, index) => 8.height,
    );
  }

  Container _buildHuongDan() {
    return Container(
      padding: 8.padingVer + 12.padingHor,
      decoration: BoxDecoration(
        color: AppColors.bg_secondary,
        borderRadius: 8.radius,
      ),
      child: Row(
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Trượt sang trái để xem thêm',
                  style: AppStyle.bodySmRegular.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
                TextSpan(
                  text: '  Tùy chọn',
                  style: AppStyle.bodyBsMedium.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                ),
              ],
            ),
          ).expanded(),
          FaIcon(iconCode: 'f323', type: FaIconType.solid),
        ],
      ),
    );
  }

  void _callScan(TypeScanView type, String value) async {
    if (type == TypeScanView.barcode) {
      final res = await widget.bloc.checkProd(value);
      if (res != null) {
        widget.bloc.addProduct(res);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Sản phẩm không tồn tại'),
            backgroundColor: AppColors.ultility_positive_60,
            duration: 2.seconds,
          ),
        );
      }
    } else if (type == TypeScanView.barcodeShipment) {
      widget.bloc.scanShipmentDetail(value);
    } else {
      final res = await widget.bloc.getDonThuoc(value);
      if (res.code == 200 && res.data != null && res.data!.isNotEmpty) {
        for (final item in res.data!) {
          widget.bloc.addProduct(item);
        }
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Đơn thuốc không tồn tại hoặc không có trong workspace',
            ),
            backgroundColor: AppColors.ultility_positive_60,
            duration: 2.seconds,
          ),
        );
      }
    }
  }
}
