import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/constants/pref_key.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../../../../../../shared/components/input/overlay_input.dart';
import '../../../../../../shared/components/widgets/fa_icon.dart';
import '../../../../../config/app_style/init_app_style.dart';
import '../../../../../shared/utils/event.dart';
import '../../../../blocs/event/list_staff_bloc.dart';
import '../../../../blocs/order_v2/product_selection_bloc.dart';
import '../../../../blocs/order_v2/service_selection_bloc.dart';
import '../../../../models/service/service.dart';
import '../bts/bts_edit_price_service.dart';
import '../service_order_item.dart';

class ServiceSelection extends StatefulWidget {
  const ServiceSelection({
    super.key,
    required this.bloc,
    required this.empBloc,
    this.prodBloc,
  });

  final ServiceSelectionBloc bloc;
  final ProductSelectionBloc? prodBloc;
  final ListStaffServiceBloc empBloc;

  @override
  State<ServiceSelection> createState() => _ServiceSelectionState();
}

class _ServiceSelectionState extends State<ServiceSelection> {
  final textCtrl = TextEditingController();

  ServiceSelectionBloc get _bloc => widget.bloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceSelectionBloc, CubitState>(
      bloc: widget.bloc,
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Dịch vụ',
              style: AppStyle.headingLg,
            ),
            12.height,
            _buildSearch,
            if (widget.bloc.list.isNotEmpty) ...[
              12.height,
              _buildHuongDan,
              12.height,
              _buildList,
            ],
            if (widget.bloc.list.isEmpty)
              Column(
                children: [
                  // Image.asset('${AssetsPath.image}/img_service_empty.png'),
                  Text(
                    'Chưa có dịch vụ \n Vui lòng tìm và lựa chọn dịch vụ',
                    textAlign: TextAlign.center,
                    style: AppStyle.bodyMdRegular.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                  ),
                ],
              ).container(padding: 32.padingVer + 16.padingHor),
          ],
        );
      },
    );
  }

  Widget get _buildSearch {
    return OverlayInput<ServiceV2Model>(
      itemBuilder: (BuildContext context, item, int index) {
        return _itemSearch(item);
      },
      onChanged: (item) {
        _bloc.addService(item);
      },
      hintText: 'Tìm tên dịch vụ',
      itemHeight: 84,
      lazyLoad: (isMore) => widget.bloc.getList(textCtrl.text, isMore: isMore),
      controller: textCtrl,
      borderRadius: 999,
      header: Text(
        'Chọn dịch vụ',
        style: AppStyle.headingMd.copyWith(
          color: AppColors.text_quaternary,
        ),
      ).padding(16.pading.copyWith(top: 12, bottom: 6)),
      elevation: 1,
      prefix: const Icon(
        Icons.search,
        size: sp16,
        color: greyTextColor,
      ),
    );
  }

  Widget get _buildList {
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
                  _editPrice(widget.bloc.list[index]);
                },
                backgroundColor: blue_1,
                foregroundColor: whiteColor,
                icon: Icons.edit,
                label: 'Sửa giá',
              ),
              SlidableAction(
                flex: 1,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(sp12),
                  bottomRight: Radius.circular(sp12),
                ),
                onPressed: (context) {
                  widget.bloc.removeservice(index);
                },
                backgroundColor: red_1,
                foregroundColor: whiteColor,
                icon: Icons.delete,
                label: 'Xóa',
              ),
            ],
          ),
          child: ServiceOrderItem(
            model: widget.bloc.list[index],
            empBloc: widget.empBloc,
            onUpdate: widget.bloc.updateService,
            proBloc: widget.prodBloc,
          ),
        );
      },
      separatorBuilder: (context, index) => 8.height,
    );
  }

  Widget get _buildHuongDan {
    return Stack(
      children: [
        Container(
          width: widthDevice(context),
          padding: 20.padingVer + 12.padingHor,
          decoration: BoxDecoration(
            color: greyFF,
            borderRadius: 12.radius,
          ),
        ),
        Container(
          width: widthDevice(context) - sp48,
          padding: 20.padingVer + 12.padingHor,
          decoration: BoxDecoration(
            color: greyFF,
            borderRadius: 12.radius,
            border: const Border(
              right: BorderSide(
                color: whiteColor,
                width: sp2,
              ),
            ),
          ),
        ),
        Container(
          width: widthDevice(context) - sp64,
          padding: 12.padingVer + 12.padingHor,
          decoration: BoxDecoration(
            color: greyFF4,
            borderRadius: 12.radius,
            border: const Border(
              right: BorderSide(
                color: whiteColor,
                width: sp2,
              ),
            ),
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
        ),
      ],
    );
  }

  Widget _itemSearch(ServiceV2Model item) {
    return ListTile(
      contentPadding: const EdgeInsets.all(sp0),
      leading: Image.network(
        (item.images?.length ?? 0) > 0
            ? item.images!.first
            : PrefKeys.imgProductDefault,
      ),
      title: Text(
        item.title ?? '',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: AppStyle.bodySmMedium.copyWith(
          color: AppColors.text_tertiary,
        ),
      ),
      subtitle: Text(
        '${FormatCurrency(item.price?.price)} đ / ${item.price?.priceNameSub}',
      ),
    );
  }

  void _editPrice(ServiceV2Model model) {
    context.bottomSheet(BtsEditPriceService(model: model)).then((value) {
      if (value != null && value is ServiceV2Model) {
        widget.bloc.addService(value);
      }
    });
  }
}
