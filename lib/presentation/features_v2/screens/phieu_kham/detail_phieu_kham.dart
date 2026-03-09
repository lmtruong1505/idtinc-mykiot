import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/phieu_kham/phieu_kham_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../models/calendar/event_model.dart';
import 'components/detail/tab_infor.dart';
import 'components/detail/tab_order.dart';
import 'components/detail/tab_tham_kham.dart';
import 'detail_prescription.dart';

@RoutePage()
class DetailPhieuKhamPage extends StatefulWidget {
  final EventModel item;
  const DetailPhieuKhamPage({
    super.key,
    required this.item,
  });

  @override
  State<DetailPhieuKhamPage> createState() => _DetailPhieuKhamPageState();
}

class _DetailPhieuKhamPageState extends State<DetailPhieuKhamPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final bloc = PhieuKhamBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      vsync: this,
      length: 5,
    );
    bloc.detail(widget.item.id ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(title: 'Chi tiết phiếu khám'),
      body: BlocBuilder<PhieuKhamBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          return LoadPage(
            state: state,
            height: null,
            child: _buildBody(),
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (bloc.phieuKham?.id == null) {
      return const EmptyContainer(
        msg: 'Không tìm thấy phiếu khám',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: ColorApp.white,
          child: TabBar(
            controller: _tabController,
            labelColor: ColorApp.black,
            indicatorColor: ColorApp.main,
            labelStyle: StyleApp.medium(),
            unselectedLabelStyle: StyleApp.normal(),
            unselectedLabelColor: ColorApp.grey79,
            isScrollable: true,
            tabs: const [
              Tab(text: 'Thông tin cơ bản'),
              Tab(text: 'Thăm khám'),
              Tab(text: 'Đơn thuốc'),
              Tab(text: 'Đơn hàng dịch vụ'),
              Tab(text: 'Đơn hàng sản phẩm'),
            ],
          ),
        ),
        TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            TabInforPhieuKham(
              item: bloc.phieuKham!,
            ),
            TabThamKhamPK(
              item: bloc.phieuKham!,
            ),
            DetailPrescriptionPage(
              model: bloc.phieuKham!,
            ),
            TabOrderPhieuKham(
              type: TypeOrderEnum.service,
              item: bloc.phieuKham!,
            ),
            TabOrderPhieuKham(
              type: TypeOrderEnum.sell,
              item: bloc.phieuKham!,
            ),
          ],
        ).expanded(),
      ],
    );
  }
}
