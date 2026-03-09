import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/screens/phieu_kham_v2/components/tab/don_thuoc_tab.dart';
import 'package:pharmago/presentation/features_v2/screens/phieu_kham_v2/components/tab/ket_luan_tab.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/dialog/dialog_message.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../gen/assets.dart';
import '../../../../shared/components/bg/bg_btn_nav_bar.dart';
import '../../../../shared/components/button/label_button.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../blocs/order_v2/product_selection_bloc.dart';
import '../../blocs/phieu_kham_v2/create_phieu_kham_bloc.dart';
import '../../blocs/phieu_kham_v2/param/create_phieu_kham_param.dart';
import '../../models/order/order_detail_v2_model.dart';

@RoutePage()
class PhieuKhamV2Page extends StatefulWidget {
  const PhieuKhamV2Page({
    super.key,
    required this.model,
    required this.appointmentService,
  });

  final OrderDetailV2Model model;
  final int appointmentService;

  @override
  State<PhieuKhamV2Page> createState() => _PhieuKhamV2PageState();
}

class _PhieuKhamV2PageState extends State<PhieuKhamV2Page>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final scrollTab = ScrollController();
  final param = CreatePhieuKhamParam();
  final bloc = CreatePhieuKhamBloc();
  final blocDonThuoc = ProductSelectionBloc();

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: tabTitle.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBarTitleCenter(title: 'Kết luận phiếu khám'),
        body: _buildBody(),
        bottomNavigationBar: BgBtnNavBar(
          child: Row(
            children: [
              LabelButton(
                backgroundColor: AppColors.button_neutral_alpha_backgroundDefault
                    .withOpacity(0.05),
                labelStyle: AppStyle.bodySmMedium.copyWith(
                  color: AppColors.button_neutral_alpha_textDefault,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                label: 'Hủy bỏ',
              ).expanded(),
              12.width,
              LabelButton(
                label: 'Xác nhận',
                onPressed: () {
                  param.appointmentService = widget.appointmentService;
                  param.prescriptions = blocDonThuoc.list
                      .map(
                        (e) => CreateDonThuocParam(
                          product: e.id,
                          unit: e.unitSell?.id,
                          quantity: e.quantity,
                          lieuDung: e.ghiChu,
                        ),
                      )
                      .toList();
                  bloc.createPhieu(param).then((value) {
                    if (value.code == 200) {
                      ToastCustom.show(
                        context,
                        title: 'Thành công',
                        msg: 'Tạo phiếu khám thành công',
                        svgIcon: Assets.svgSuccess,
                        color: AppColors.ultility_positive_60,
                        route: value.data is int
                            ? DetailPkV2Route(
                                id: value.data ?? -1,
                              )
                            : null,
                      );
                      context.pop(result: true);
                    } else {
                      context.dialog(
                        DialogMessage(
                          title: 'Thất bại',
                          content: value.message ?? '',
                          isError: true,
                        ),
                      );
                    }
                  });
                },
              ).expanded(),
            ],
          ),
        ),
      ),
    );
  }

  final List<String> tabTitle = [
    'Kết luận',
    'Đơn thuốc',
  ];

  Column _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        12.height,
        _buildTab(),
        TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            KetLuanTab(
              model: widget.model,
              param: param,
              bloc: bloc,
            ),
            DonThuocTab(
              bloc: blocDonThuoc,
            ),
          ],
        ).expanded(),
      ],
    );
  }

  Widget _buildTab() {
    return TabBar(
      controller: _tabController,
      labelColor: AppColors.text_primary,
      labelStyle: AppStyle.bodyBsMedium,
      unselectedLabelColor: AppColors.text_tertiary,
      unselectedLabelStyle: AppStyle.bodyBsRegular,
      indicatorColor: AppColors.border_primary,
      indicatorSize: TabBarIndicatorSize.label,
      tabs: List.generate(
        tabTitle.length,
        (index) => Tab(
          height: 37,
          text: tabTitle[index],
        ),
      ),
    ).container(
      padding: 0.pading,
      border: const Border(
        bottom: BorderSide(color: AppColors.border_tertiary),
      ),
    );
  }
}
