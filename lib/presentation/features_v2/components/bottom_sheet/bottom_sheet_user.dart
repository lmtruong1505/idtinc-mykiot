import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/employee/employee/data/models/employee_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/customer/customer_manager_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/staff/staff_manager_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/components/input/app_input.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/ext_controller.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';

import '../../../features/customer/data/models/customer_model.dart';

class BtsUser extends StatefulWidget {
  final bool isCustomerOrDoctor;
  final bool multi;
  final String? title;

  const BtsUser({
    super.key,
    required this.isCustomerOrDoctor,
    this.multi = false,
    this.title,
  });

  @override
  State<BtsUser> createState() => _BtsUserState();
}

class _BtsUserState extends State<BtsUser> {
  CustomerModel? customer;
  EmployeeModel? doctor;
  final customerBloc = CustomerManagerCubit();
  final doctorBloc = StaffManagerBloc();
  final scroll = ScrollController();
  final List<int> ids = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isCustomerOrDoctor) {
      customerBloc.getList();
    } else {
      doctorBloc.getList();
    }
    scroll.onMore(
      () {
        if (widget.isCustomerOrDoctor) {
          customerBloc.getList(isMore: true);
        } else {
          doctorBloc.getList(isMore: true);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          color: ColorApp.white,
          borderRadius: 8.radius,
        ),
        padding: 16.pading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            8.height,
            Text(
              widget.title ??
                  (widget.isCustomerOrDoctor ? 'Lọc khách hàng' : 'Lọc bác sĩ'),
              style: StyleApp.semibold(fontSize: 16),
            ),
            16.height,
            if (widget.multi) ...[
              TabBar(
                indicatorColor: ColorApp.main,
                labelColor: ColorApp.main,
                unselectedLabelColor: ColorApp.grey79,
                isScrollable: true,
                onTap: (value) {},
                tabs: [
                  const Tab(
                    text: 'Danh sách',
                  ),
                  Tab(
                    text: 'Đã chọn (${ids.length})',
                  ),
                ],
              ),
              16.height,
              TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildBody(),
                  _multiBody(),
                ],
              ).expanded(),
            ],
            if (!widget.multi) ...[
              widget.isCustomerOrDoctor
                  ? _buildCustomer().expanded()
                  : _buildDoctor().expanded(),
            ],
            RowBtn(
              onCancel: () => context.pop(),
              onConfirm: () {
                context.pop(
                  result: widget.multi
                      ? ids
                      : widget.isCustomerOrDoctor
                          ? customer
                          : doctor,
                );
              },
            ).padding(12.padingTop),
          ],
        ),
      ),
    );
  }

  ListView _multiBody() {
    final List<CustomerModel> customers = customerBloc.list
        .where(
          (element) => ids.contains(element.id),
        )
        .toList();
    final List<EmployeeModel> staffs = doctorBloc.list
        .where(
          (element) => ids.contains(element.id),
        )
        .toList();
    return ListView.separated(
      controller: scroll,
      itemCount: (widget.isCustomerOrDoctor ? customers : staffs).length,
      separatorBuilder: (context, index) => sp16.height,
      itemBuilder: (context, index) {
        return _buildItem(
          onTap: () {
            if (widget.isCustomerOrDoctor) {
              customer = customers[index];
              addIdList(customers[index].id ?? 0);
            } else {
              doctor = staffs[index];
              addIdList(staffs[index].id ?? 0);
            }

            setState(() {});
          },
          name: widget.isCustomerOrDoctor
              ? customers[index].fullName.validator
              : staffs[index].fullName.validator,
          phone: widget.isCustomerOrDoctor
              ? customers[index].phone.validator
              : staffs[index].username.validator,
          image: widget.isCustomerOrDoctor
              ? customers[index].image.validator
              : null,
          isActive: ids.contains(
            widget.isCustomerOrDoctor ? customers[index].id : staffs[index].id,
          ),
        );
      },
    );
  }

  addIdList(int id) {
    if (ids.contains(id)) {
      ids.remove(id);
    } else {
      ids.add(id);
    }
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppInputV2(
          hintText: widget.isCustomerOrDoctor
              ? 'Tìm kiếm tên khách hàng'
              : 'Tìm kiếm tên  bác sĩ',
          borderColor: ColorApp.greyE2,
          backgroundColor: ColorApp.white,
          radius: Dimensions.sp8,
          prefixIcon: const Icon(
            Icons.search,
            color: ColorApp.black,
          ),
          onChanged: (p0) {
            if (widget.isCustomerOrDoctor) {
              customerBloc.search = p0;
            } else {
              doctorBloc.search(p0);
            }
          },
        ),
        16.height,
        widget.isCustomerOrDoctor
            ? _buildCustomer().expanded()
            : _buildDoctor().expanded(),
      ],
    );
  }

  Widget _buildCustomer() {
    return BlocBuilder<CustomerManagerCubit, CubitState>(
      bloc: customerBloc,
      builder: (context, state) {
        return LoadListPage(
          state: state,
          listEmpty: customerBloc.list.isEmpty,
          child: ListView.separated(
            controller: scroll,
            itemCount: customerBloc.list.length,
            separatorBuilder: (context, index) => sp16.height,
            itemBuilder: (context, index) {
              final model = customerBloc.list[index];
              return _buildItem(
                onTap: () {
                  customer = model;
                  addIdList(model.id ?? 0);
                  setState(() {});
                },
                name: model.fullName ?? '',
                phone: model.phone ?? '',
                image: model.image,
                isActive: widget.multi
                    ? ids.contains(model.id)
                    : customer?.id == model.id,
              );
            },
          ).expanded(),
        );
      },
    );
  }

  Widget _buildDoctor() {
    return BlocBuilder<StaffManagerBloc, CubitState>(
      bloc: doctorBloc,
      builder: (context, state) {
        return LoadListPage(
          state: state,
          listEmpty: doctorBloc.list.isEmpty,
          child: ListView.separated(
            controller: scroll,
            itemCount: doctorBloc.list.length,
            separatorBuilder: (context, index) => sp16.height,
            itemBuilder: (context, index) {
              final model = doctorBloc.list[index];
              return _buildItem(
                onTap: () {
                  doctor = model;
                  addIdList(model.id ?? 0);
                  setState(() {});
                },
                name: model.fullName ?? '',
                phone: model.username ?? '',
                isActive: widget.multi
                    ? ids.contains(model.id)
                    : doctor?.id == model.id,
              );
            },
          ).expanded(),
        );
      },
    );
  }

  Widget _buildItem({
    required String name,
    required String phone,
    String? image,
    bool isActive = false,
    Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: 16.pading,
        margin: 16.padingBottom,
        decoration: BoxDecoration(
          border: Border.all(
            color: isActive ? ColorApp.main : ColorApp.greyE2,
          ),
          borderRadius: 8.radius,
        ),
        child: Row(
          children: [
            if (image != null) ...[
              BaseCacheImage(
                url: image,
                borderRadius: 40.radius,
                width: 48,
                height: 48,
              ),
              8.width,
            ],
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  name,
                  style: StyleApp.medium(fontSize: 16),
                ),
                4.height,
                Text(
                  phone,
                  style: StyleApp.normal(),
                ),
              ],
            ).expanded(),
            if (isActive) ...[
              16.width,
              const Icon(
                Icons.check_circle,
                color: ColorApp.main,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
