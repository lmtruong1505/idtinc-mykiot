import 'package:flutter/material.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/screens/product/components/bts_chose_extra.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../blocs/product/params/prod_create_param.dart';

class ExtraTab extends StatefulWidget {
  const ExtraTab({super.key, required this.param});

  final ProdCreateParam param;

  @override
  State<ExtraTab> createState() => _ExtraTabState();
}

class _ExtraTabState extends State<ExtraTab>
    with AutomaticKeepAliveClientMixin {
  final brand = TextEditingController();
  final category = TextEditingController();
  final type = TextEditingController();
  final congTySx = TextEditingController();
  final congTyDk = TextEditingController();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: 24.padingTop + 16.padingHor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _reconizeExtraInfo(),
          24.height,
          _legalInfo(),
          24.height,
          _pharmacyInfo(),
        ],
      ),
    );
  }

  _reconizeExtraInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin nhận diện bổ sung',
          style: AppStyle.headingLg,
        ),
        16.height,
        InputColumn(
          label: 'Thương hiệu',
          suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
          padding: 0.pading,
          controller: brand,
          onTap: () {
            context.bottomSheet(
              BtsChoseExtra(
                type: ExtraType.brands,
                onChose: (value) {
                  widget.param.product?.brand = value;
                  brand.text = value.name ?? '';
                },
                id: widget.param.product?.brand?.id ?? -1,
              ),
            );
          },
          readOnly: true,
        ),
        16.height,
        InputColumn(
          label: 'Công ty sản xuất',
          suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
          padding: 0.pading,
          readOnly: true,
          controller: congTySx,
          onTap: () {
            context.bottomSheet(
              BtsChoseExtra(
                type: ExtraType.pharma,
                onChose: (value) {
                  widget.param.product?.congTySx = value;
                  congTySx.text = value.name ?? '';
                },
                id: widget.param.product?.congTySx?.id ?? -1,
              ),
            );
          },
        ),
      ],
    );
  }

  _legalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Thông tin pháp lý', style: AppStyle.headingLg),
        16.height,
        InputColumn(
          label: 'Công ty đăng ký',
          suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
          padding: 0.pading,
          controller: congTyDk,
          onTap: () {
            context.bottomSheet(
              BtsChoseExtra(
                type: ExtraType.pharma,
                onChose: (value) {
                  widget.param.product?.congTyDk = value;
                  congTyDk.text = value.name ?? '';
                },
                id: widget.param.product?.congTyDk?.id ?? -1,
              ),
            );
          },
        ),
        16.height,
        InputColumn(
          label: 'Số đăng ký',
          initialValue: widget.param.product?.registerNumber,
          padding: 0.pading,
          onChanged: (val) {
            widget.param.product?.registerNumber = val;
          },
        ),
        16.height,
        InputColumn(
          label: 'Số quyết định',
          padding: 0.pading,
          initialValue: widget.param.product?.decisionNumber,
          onChanged: (val) {
            widget.param.product?.decisionNumber = val;
          },
        ),
        16.height,
        InputColumn(
          label: 'Tuổi thọ',
          hintText: 'VD: 6 Tháng',
          padding: 0.pading,
        ),
        16.height,
        InputColumn(
          label: 'Hình thức bán',
          hintText: 'VD: Bán thuốc theo đơn',
          padding: 0.pading,
        ),
      ],
    );
  }

  _pharmacyInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Thông tin dược lý', style: AppStyle.headingLg),
        16.height,
        InputColumn(
          label: 'Loại sản phẩm',
          suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
          padding: 0.pading,
          controller: type,
          onTap: () {
            context.bottomSheet(
              BtsChoseExtra(
                type: ExtraType.types,
                onChose: (value) {
                  widget.param.product?.type = value;
                  type.text = value.name ?? '';
                },
                id: widget.param.product?.type?.id ?? -1,
              ),
            );
          },
          readOnly: true,
        ),
        // 16.height,
        // InputColumn(
        //   label: 'Danh mục sản phẩm',
        //   padding: 0.pading,
        //   suffixIcon: const Icon(Icons.arrow_drop_down_outlined),
        //   controller: category,
        //   onTap: () {
        //     context.bottomSheet(
        //       BtsChoseExtra(
        //         type: ExtraType.categories,
        //         onChose: (value) {
        //           widget.param.product?.category = value;
        //           category.text = value.name ?? '';
        //         },
        //         id: widget.param.product?.category?.id ?? -1,
        //       ),
        //     );
        //   },
        //   readOnly: true,
        // ),
        16.height,
        InputColumn(
          label: 'Hình thức đóng gói',
          hintText: 'VD: Hộp 10 viên',
          padding: 0.pading,
          initialValue: widget.param.product?.dongGoi,
          onChanged: (val) {
            widget.param.product?.dongGoi = val;
          },
        ),
        16.height,
        InputColumn(
          label: 'Chỉ định',
          hintText: 'VD: Đau dạ dày',
          padding: 0.pading,
          minLines: 3,
          initialValue: widget.param.product?.chiDinh,
          onChanged: (val) {
            widget.param.product?.chiDinh = val;
          },
        ),
        16.height,
        InputColumn(
          label: 'Chống chỉ định',
          hintText: 'VD: Viêm gan...',
          padding: 0.pading,
          minLines: 3,
          initialValue: widget.param.product?.chongChiDinh,
          onChanged: (val) {
            widget.param.product?.chongChiDinh = val;
          },
        ),
        16.height,
        InputColumn(
          label: 'Dạng bào chế',
          hintText: 'VD: Thuốc cốm, thuốc nước...',
          padding: 0.pading,
          onChanged: (val) {
            // widget.param.product?.baoChe = val;
          },
        ),
        16.height,
        InputColumn(
          label: 'Tiêu chuẩn sản xuất',
          hintText: 'VD: TCCS 2017',
          padding: 0.pading,
        ),
        16.height,
        InputColumn(
          label: 'Liều dùng và cách dùng',
          hintText: 'VD: Uống 1 hoặc 2 viên/ngày',
          padding: 0.pading,
          initialValue: widget.param.product?.lieuDung,
          minLines: 3,
          onChanged: (val) {
            widget.param.product?.lieuDung = val;
          },
        ),
        16.height,
        InputColumn(
          label: 'Đối tượng',
          padding: 0.pading,
          minLines: 3,
        ),
        16.height,
        InputColumn(
          label: 'Công dụng',
          padding: 0.pading,
          minLines: 3,
          initialValue: widget.param.product?.congDung,
          onChanged: (val) {
            widget.param.product?.congDung = val;
          },
        ),
        16.height,
        InputColumn(
          label: 'Tác dụng phụ',
          padding: 0.pading,
          minLines: 3,
          initialValue: widget.param.product?.tacDungPhu,
          onChanged: (val) {
            widget.param.product?.tacDungPhu = val;
          },
        ),
        16.height,
        InputColumn(
          label: 'Lưu ý thận trọng',
          padding: 0.pading,
          minLines: 3,
          initialValue: widget.param.product?.thanTrong,
          onChanged: (val) {
            widget.param.product?.thanTrong = val;
          },
        ),
        16.height,
        InputColumn(
          label: 'Bảo quản',
          hintText: 'VD: Viêm gan...',
          padding: 0.pading,
          minLines: 3,
          initialValue: widget.param.product?.baoQuan,
          onChanged: (val) {
            widget.param.product?.baoQuan = val;
          },
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
