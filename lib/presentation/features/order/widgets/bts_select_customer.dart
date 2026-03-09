import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/customer/cubit/customer_cubit.dart';
import 'package:pharmago/presentation/features/customer/cubit/customer_state.dart';
import 'package:pharmago/presentation/features/customer/domain/entities/customer_entity.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../base/cache_image.dart';
import '../../../base/infinite_list.dart';
import '../../../base/loading.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';

class BtsSelectCustomer extends StatefulWidget {
  const BtsSelectCustomer({
    super.key,
    this.initValue,
    this.onConfirm,
    this.hasRetailCustomer = false,
  });

  final CustomerEntity? initValue;
  final Function(CustomerEntity? value)? onConfirm;
  final bool hasRetailCustomer;

  @override
  State<BtsSelectCustomer> createState() => _BtsSelectCustomerState();
}

class _BtsSelectCustomerState extends State<BtsSelectCustomer> {
  final myBloc = getIt.get<CustomerCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CustomerCubit>(
      create: (context) => myBloc
        ..init(
          dataInit: widget.initValue,
        ),
      child: BlocBuilder<CustomerCubit, CustomerState>(
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(sp16),
            width: widthDevice(context),
            height: heightDevice(context) * 0.9,
            decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(
                  sp12,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Huỷ',
                        style: p5.copyWith(color: borderColor_4),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.onConfirm?.call(state.dataSelected);
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Xác nhận',
                        style: p5.copyWith(color: blue_1),
                      ),
                    ),
                  ],
                ),
                gapHeight(sp16),
                AppInputSupport(
                  hintText: 'Tìm kiếm khách hàng',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                  ),
                  onChanged: myBloc.changeSearch,
                  onConfirm: (value) => myBloc.entityILC.onRefresh(),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    controller: myBloc.scrollController,
                    child: Column(
                      children: [
                        Visibility(
                          visible: widget.hasRetailCustomer,
                          child: InkWell(
                            onTap: () => myBloc.selectCustomer(null),
                            child: Container(
                              margin: const EdgeInsets.only(top: sp16),
                              padding: const EdgeInsets.all(sp16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(sp12),
                                color: bg_4,
                                border: Border.all(
                                  color: mainColor.withOpacity(
                                    state.dataSelected == null ? 1 : 0,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: SizedBox(
                                  height: sp48,
                                  width: sp48,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(sp8),
                                    child: const BaseCacheImage(
                                      url: PrefKeys.avatarDefault,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Khách lẻ (Tuỳ chọn)',
                                  style: p5.copyWith(color: blackColor),
                                ),
                                subtitle: Text(
                                  'KHACH-LE',
                                  style: p6.copyWith(color: greyColor),
                                ),
                              ),
                            ),
                          ),
                        ),
                        gapHeight(sp16),
                        InfiniteList<CustomerEntity>(
                          shrinkWrap: true,
                          getData: (page) async {
                            if (page == 0) {
                              myBloc.entityILC.itemList = [];
                            }
                            return myBloc.getList(page);
                          },
                          itemBuilder: (context, item, index) => InkWell(
                            onTap: () => myBloc.selectCustomer(item),
                            child: Container(
                              padding: const EdgeInsets.all(sp16),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(sp12),
                                color: bg_4,
                                border: Border.all(
                                  color: mainColor.withOpacity(
                                    state.dataSelected == item ? 1 : 0,
                                  ),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0),
                                leading: SizedBox(
                                  height: sp48,
                                  width: sp48,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(sp8),
                                    child: const BaseCacheImage(
                                      url: PrefKeys.avatarDefault,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  item.name ?? '',
                                  style: p5.copyWith(color: blackColor),
                                ),
                                subtitle: Text(
                                  item.code ?? '',
                                  style: p6.copyWith(color: greyColor),
                                ),
                              ),
                            ),
                          ),
                          scrollController: myBloc.scrollController,
                          infiniteListController: myBloc.entityILC,
                          circularProgressIndicator: const BaseLoading(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
