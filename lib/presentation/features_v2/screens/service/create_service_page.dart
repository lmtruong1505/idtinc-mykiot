import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/features_v2/blocs/service/bloc_index.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/features_v2/screens/service/components/create/tab_base.dart';
import 'package:pharmago/presentation/features_v2/screens/service/components/create/tab_extra.dart';
import 'package:pharmago/presentation/features_v2/screens/service/components/create/tab_price.dart';
import 'package:pharmago/presentation/features_v2/screens/service/components/create/tab_product.dart';
import 'package:pharmago/shared/components/button/double_button.dart';
import 'package:pharmago/shared/components/button/label_button.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/components/widgets/app_bar_custom.dart';
import '../../../../shared/components/bg/bg_btn_nav_bar.dart';
import '../../../../shared/components/widgets/header_create.dart';
import '../../../config/app_style/init_app_style.dart';
import '../../models/service/service.dart';
import 'components/create/tab_images.dart';

@RoutePage()
class CreateServiceV2Page extends StatefulWidget {
  final DetailServiceV2Model? service;
  const CreateServiceV2Page({
    super.key,
    required this.service,
  });

  @override
  State<CreateServiceV2Page> createState() => _CreateServiceV2PageState();
}

class _CreateServiceV2PageState extends State<CreateServiceV2Page>
    with SingleTickerProviderStateMixin {
  late TabController _tabControlle;
  final bloc = CreateServiceV2Bloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabControlle = TabController(vsync: this, length: tabTitle.length);
    if (widget.service != null) {
      bloc.setData(widget.service!, context.read<ServiceTypeBloc>().list);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.close();
  }

  confirm() {
    final key = bloc.baseKey.currentState?.validate() ?? false;
    final priceKey = bloc.priceKey.currentState?.validate() ?? false;
    if (bloc.isActive && key && priceKey) {
      if (widget.service?.id != null) {
        bloc.update(context, widget.service!.id!);
      } else {
        bloc.create(context);
      }
    } else {
      ToastCustom.show(
        context,
        title: 'Cảnh báo',
        msg: 'Vui lòng nhập tên dịch vụ và chọn giá cơ sở cho dịch vụ',
        svgIcon: Assets.svgWarningOutline,
        color: AppColors.ultility_negative_60,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarTitleCenter(
        title: '',
        leadingText: 'Trở về',
      ),
      bottomNavigationBar: BlocBuilder<CreateServiceV2Bloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          return BgBtnNavBar(
            child: widget.service?.id != null
                ? DoubleButton(
                    confirmText: 'Lưu lại',
                    onCancel: () => context.pop(),
                    onConfirm: confirm,
                  )
                : LabelButton(
                    onPressed: confirm,
                    label: 'Tạo dịch vụ',
                    fixedSize: const Size(double.infinity, 40),
                  ),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          16.height,
          HeaderCreate(
            iconCode: 'f4be',
            isEdit: widget.service?.id != null,
            title: widget.service?.id != null
                ? 'Cập nhật dịch vụ'
                : 'Tạo mới dịch vụ',
          ),
          24.height,
          _buildTab(),
          TabBarView(
            controller: _tabControlle,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              TabBaseCreateService(
                bloc: bloc,
              ),
              TabPriceCreateService(
                bloc: bloc,
              ),
              TabImagesCreateService(
                bloc: bloc,
              ),
              TabProductCreateService(
                bloc: bloc,
              ),
              TabExtraCreateService(
                bloc: bloc,
              ),
            ],
          ).expanded(),
        ],
      ),
    );
  }

  final scrollTab = ScrollController();

  Widget _buildTab() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: 16.padingHor,
      controller: scrollTab,
      child: TabBar(
        controller: _tabControlle,
        isScrollable: true,
        labelColor: AppColors.text_primary,
        labelStyle: AppStyle.bodyBsMedium,
        unselectedLabelColor: AppColors.text_tertiary,
        unselectedLabelStyle: AppStyle.bodyBsRegular,
        indicator: BoxDecoration(
          borderRadius: 50.radius,
          color: AppColors.bg_primary,
          boxShadow: AppShadows.elevator0,
        ),
        onTap: (value) {
          final maxPixel = scrollTab.position.maxScrollExtent;
          final pixel = maxPixel / tabTitle.length;
          if (value == tabTitle.length - 1) {
            scrollTab.animateTo(
              maxPixel,
              duration: 300.milliseconds,
              curve: Curves.linear,
            );
          } else {
            scrollTab.animateTo(
              pixel * value,
              duration: 300.milliseconds,
              curve: Curves.linear,
            );
          }
        },
        tabs: List.generate(
          tabTitle.length,
          (index) => Tab(
            height: 37,
            child: Row(
              children: [
                Text(tabTitle[index]),
                if (index < 2)
                  Text(
                    '*',
                    style: AppStyle.bodyBsMedium.copyWith(
                      color: AppColors.text_warning,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ).container(
        padding: EdgeInsets.zero,
        bgColor: AppColors.bg_secondary,
        radius: 50,
        border: Border.all(
          color: AppColors.border_tertiary,
        ),
      ),
    );
  }

  final List<String> tabTitle = [
    'Thông tin cơ bản',
    'Giá dịch vụ',
    'Ảnh dịch vụ',
    'Sản phẩm liên quan',
    'Thông tin bổ sung',
  ];
}
