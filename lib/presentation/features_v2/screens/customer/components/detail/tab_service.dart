import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/customer/service_customer_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../../../../../../shared/style_app/init_style.dart';
import '../../../../models/customer/service_customer_model.dart';
class TabServiceCustomer extends StatefulWidget {
  final CustomerModel customer;
  const TabServiceCustomer({
    super.key,
    required this.customer,
  });

  @override
  State<TabServiceCustomer> createState() => _TabServiceCustomerState();
}

class _TabServiceCustomerState extends State<TabServiceCustomer>
    with AutomaticKeepAliveClientMixin {
  final bloc = ServiceCustomerBloc();
  final scroll = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getList(widget.customer.id ?? 0);
    scroll.onMore(
      () => bloc.getList(
        widget.customer.id ?? 0,
        isMore: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ServiceCustomerBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            await bloc.getList(widget.customer.id ?? 0);
          },
          child: LoadListPage(
            state: state,
            listEmpty: bloc.list.isEmpty,
            child: ListView.separated(
              padding: sp16.pading,
              controller: scroll,
              physics: const AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) => _buildService(bloc.list[index]),
              separatorBuilder: (context, index) => sp16.height,
              itemCount: bloc.list.length,
            ).expanded(),
          ),
        );
      },
    );
  }

  Widget _buildService(ServiceCustomerModel item) {
    return Container(
      padding: 16.pading,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: 8.radius,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BaseCacheImage(
            url: PrefKeys.imgProductDefault,
            height: 50,
            width: 50,
          ),
          sp16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                item.title ?? '',
                overflow: TextOverflow.ellipsis,
                style: StyleApp.medium(fontSize: 16),
              ),
              8.height,
              Text(
                'Sử dụng ${item.used ?? 0} ${item.unit ?? ''}',
                overflow: TextOverflow.ellipsis,
                style: StyleApp.normal(
                  fontSize: 16,
                  color: ColorApp.main,
                ),
              ),
              8.height,
              Text(
                item.staff ?? 'Chưa có thông tin',
                overflow: TextOverflow.ellipsis,
                style: StyleApp.medium(fontSize: 16),
              ),
            ],
          ).expanded(),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
