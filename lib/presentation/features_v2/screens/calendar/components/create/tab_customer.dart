import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features/order/v2/widget/customer_fast_create_view.dart';
import 'package:pharmago/presentation/features_v2/blocs/calendar/create_event_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/customer/customer_bloc.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/style_app/init_style.dart';
import '../../../../blocs/customer/customer_manager_bloc.dart';
import '../../../../blocs/state/init_state.dart';

class TabCustomerEvent extends StatefulWidget {
  final CreateEventBloc bloc;
  TabCustomerEvent({required this.bloc});

  @override
  State<TabCustomerEvent> createState() => _TabCustomerEventState();
}

class _TabCustomerEventState extends State<TabCustomerEvent> with AutomaticKeepAliveClientMixin {
  final search = TextEditingController();
  final customerBloc = CustomerManagerCubit();
  final createCustomerBloc = CustomerBloc();

  final scroll = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    customerBloc.getList();
    scroll.onMore(
      () => customerBloc.getList(isMore: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<CustomerBloc, CubitState>(
      bloc: createCustomerBloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          isShowMsg: true,
          success: () {
            customerBloc.getList();
          },
        );
      },
      child: BlocBuilder<CreateEventBloc, CubitState>(
        bloc: widget.bloc,
        builder: (context, state) {
          return SingleChildScrollView(
            padding: 16.pading,
            controller: scroll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildSearch(),
                sp16.height,
                BlocBuilder<CustomerManagerCubit, CubitState>(
                  bloc: customerBloc,
                  builder: (context, state) {
                    return LoadListPage(
                      state: state,
                      height: 200,
                      listEmpty: customerBloc.list.isEmpty,
                      child: Column(
                        children: List.generate(
                          customerBloc.list.length,
                          (index) => _buildCustomer(
                            customerBloc.list[index],
                          ),
                        ),
                      ),
                    );
                  },
                ),
                context.padding.bottom.height,
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCustomer(CustomerModel customer) {
    return GestureDetector(
      onTap: () {
        widget.bloc.customer = customer.id;
      },
      child: Container(
        padding: 16.pading,
        margin: 16.padingBottom,
        decoration: BoxDecoration(
          border: Border.all(
            color: customer.id == widget.bloc.customer
                ? ColorApp.main
                : ColorApp.greyE2,
          ),
          borderRadius: 8.radius,
          color: ColorApp.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  customer.fullName ?? "",
                  style: StyleApp.medium(fontSize: 16),
                ).expanded(),
                // if (index == select) ...[
                //   16.width,
                //   const Icon(
                //     Icons.check_circle,
                //     color: ColorApp.main,
                //   ),
                // ],
              ],
            ),
            4.height,
            Text(
              '#${customer.code ?? ""}',
              style: StyleApp.normal(color: ColorApp.grey79),
            ),
            8.height,
            Row(
              children: [
                const Icon(
                  CupertinoIcons.phone_fill,
                  color: ColorApp.blue99,
                  size: 17,
                ),
                8.width,
                textRow(
                  title: customer.phone ?? "",
                  content:
                      '${customer.orders ?? 0} Đơn - ${customer.revenue.formatPrice(type: 'đ')}',
                  titleStyle: StyleApp.medium(),
                  contentStyle: StyleApp.semibold(),
                ).expanded(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return AppInputV2(
      controller: search,
      hintText: 'Tìm kiếm khách hàng',
      borderColor: ColorApp.greyE2,
      backgroundColor: ColorApp.white,
      radius: Dimensions.sp8,
      prefixIcon: const Icon(
        Icons.search,
        color: ColorApp.black,
      ),
      suffixIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          12.width,
          InkWell(
            onTap: createCustomer,
            child: SizedBox(
              height: 30,
              child: Center(
                child: Text(
                  'Tạo mới',
                  style: StyleApp.semibold(
                    fontSize: 16,
                    color: ColorApp.main,
                  ),
                ),
              ),
            ),
          ),
          InkWell(
            onTap: () {
              search.clear();
            },
            child: const SizedBox(
              height: 30,
              width: 30,
              child: Icon(
                Icons.close,
                size: 17,
                color: ColorApp.black,
              ),
            ),
          ),
          6.width,
        ],
      ),
      onChanged: (p0) {
        customerBloc.search = p0;
      },
      onConfirm: (p0) {
        context.unFocus();
      },
    );
  }

  createCustomer() {
    context.bottomSheet(
      CustomerFastCreateView(
        onConfirm: (phone, name) {
          context.pop();
          createCustomerBloc.fastCreate(
            name: name,
            phone: phone,
          );
        },
        onCancel: () {
          context.pop();
        },
      ),
    );
  }
  
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
