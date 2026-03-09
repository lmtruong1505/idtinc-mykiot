import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/infinite_list.dart';
import 'package:pharmago/presentation/base/loading.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features/product/cubit/service_manager_cubit/service_manager_cubit.dart';
import 'package:pharmago/presentation/features/product/domain/entities/service_entity.dart';
import 'package:pharmago/presentation/features/product/widgets/item_service.dart';
import 'package:pharmago/presentation/features_v2/blocs/calendar/create_event_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/style_app/init_style.dart';
class TabServiceEvent extends StatefulWidget {
  final CreateEventBloc bloc;
  const TabServiceEvent({required this.bloc});

  @override
  State<TabServiceEvent> createState() => _TabServiceEventState();
}

class _TabServiceEventState extends State<TabServiceEvent> with  AutomaticKeepAliveClientMixin {
  final serviceBloc = getIt.get<ServiceManagerCubit>();

  final scroll = ScrollController();
  int _page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    serviceBloc.getServices(_page);
    scroll.onMore(
      () {
        _page++;
        serviceBloc.getServices(_page);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<CreateEventBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return SingleChildScrollView(
          padding: 16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppInputV2(
                hintText: 'Tìm tên dịch vụ',
                borderColor: ColorApp.greyE2,
                backgroundColor: ColorApp.white,
                radius: Dimensions.sp8,
                prefixIcon: const Icon(
                  Icons.search,
                  color: ColorApp.black,
                ),
                onChanged: serviceBloc.searchChange,
                onConfirm: (p0) {},
              ),
              sp16.height,
              InfiniteList(
                shrinkWrap: true,
                getData: (page) async {
                  return serviceBloc.getServices(page);
                },
                itemBuilder:
                    (BuildContext context, ServiceEntity item, int index) {
                  return InkWell(
                    onTap: () {
                      widget.bloc.service = item.id;
                    },
                    child: ItemService(
                      isActive: widget.bloc.service == item.id,
                      item: item,
                    ),
                  );
                },
                scrollController: serviceBloc.scrollController,
                infiniteListController: serviceBloc.servicesILC,
                circularProgressIndicator: const BaseLoading(
                  height: 200,
                ),
                noItemFoundWidget: const EmptyContainer(),
              ),
            ],
          ),
        );
      },
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
