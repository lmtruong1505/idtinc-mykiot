import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/shared/components/widgets/title_add.dart';
import 'package:pharmago/presentation/features_v2/screens/service/components/items/item_price_create.dart';
import 'package:pharmago/shared/components/widgets/empty_view.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../blocs/service/bloc_index.dart';
import '../../../../blocs/state/init_state.dart';
import '../../../../models/service/service.dart';
import '../bottom_sheet/bts_config_service.dart';
import '../bottom_sheet/bts_price_ticket.dart';
import '../bottom_sheet/bts_price_time.dart';
import '../bottom_sheet/bts_price_treatment.dart';

class TabPriceCreateService extends StatefulWidget {
  final CreateServiceV2Bloc bloc;
  const TabPriceCreateService({
    super.key,
    required this.bloc,
  });

  @override
  State<TabPriceCreateService> createState() => _TabPriceCreateServiceState();
}

class _TabPriceCreateServiceState extends State<TabPriceCreateService>
    with AutomaticKeepAliveClientMixin {
  final bloc = ConfigPriceBloc();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.addTypes(widget.bloc.groupPrice);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    bloc.close();
  }

  configService() {
    context
        .bottomSheet(
      BtsConfigService(
        types: bloc.list,
      ),
    )
        .then((value) {
      if (value is List<ServiceTypeV2Model>) {
        bloc.addTypes(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ConfigPriceBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        if (bloc.list.isEmpty) {
          return _buildEmpty();
        }

        return SingleChildScrollView(
          padding: 16.pading,
          child: Form(
            key: widget.bloc.priceKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TitleAdd(
                  title: 'Loại giá dịch vụ',
                  labelButton: 'Cấu hình',
                  styleTitle: AppStyle.bodyBsMedium.copyWith(
                    color: AppColors.text_tertiary,
                  ),
                  suffixIcon: FaIcon(
                    iconCode: 'f013',
                    color: AppColors.button_neutral_alpha_iconDefault,
                  ),
                  onPressed: configService,
                ),
                const Divider(
                  color: AppColors.border_tertiary,
                  height: 0,
                  thickness: 1,
                ),
                16.height,
                FormField(
                  validator: (value) {
                    if (bloc.isError) {
                      return 'Chưa có giá cơ sở';
                    }
                    return null;
                  },
                  builder: (field) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.circle,
                              color: AppColors.ultility_carrot_60,
                              size: 15,
                            ),
                            8.width,
                            Text(
                              'Giá cơ sở',
                              style: AppStyle.bodyBsMedium.copyWith(
                                color: AppColors.text_secondary,
                              ),
                            ),
                            25.width,
                            if (field.hasError)
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  children: [
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: FaIcon(
                                        iconCode: 'f071',
                                        color: AppColors.ultility_negative_60,
                                        size: 12,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '  ${field.errorText ?? ""}',
                                      style: AppStyle.bodyBsRegular.copyWith(
                                        color: AppColors.ultility_negative_60,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ).expanded(),
                          ],
                        ),
                        16.height,
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: 14.radius,
                            border: Border.all(
                              color: field.hasError
                                  ? AppColors.ultility_negative_60
                                  : Colors.transparent,
                            ),
                          ),
                          padding: 2.pading,
                          child: ListView.separated(
                            itemBuilder: (context, index) => ItemPriceCreate(
                              item: bloc.list[index],
                              removePrice: (p0) {
                                bloc.removePrice(index, p0);
                                widget.bloc.prices = bloc.mapDataPrices;
                              },
                              callBack: () {
                                widget.bloc.prices = bloc.mapDataPrices;
                              },
                              setDefault: (p0) {
                                bloc.setPriceDefault(index, p0);
                                widget.bloc.prices = bloc.mapDataPrices;
                              },
                              addOrUpdate: (p0) {
                                addPrice(index: p0, group: bloc.list[index]);
                              },
                              remove: () {
                                bloc.remove(index);
                                widget.bloc.prices = bloc.mapDataPrices;
                              },
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            separatorBuilder: (context, index) => 16.height,
                            itemCount: bloc.list.length,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmpty() {
    return EmptyComfirm(
      labelBtn: 'Cấu hình giá dịch vụ',
      text: 'Giá dịch vụ',
      onPressed: configService,
      btnColor: AppColors.button_neutral_solid_backgroundDefault,
      icon: FaIcon(
        iconCode: 'f02b',
        type: FaIconType.solid,
        size: 32,
        color: AppColors.fg_tertiary,
      ),
      suffixIcon: FaIcon(
        iconCode: 'f013',
        color: AppColors.button_neutral_solid_iconDefault,
      ),
    );
  }

  void addPrice({int? index, required ServiceTypeV2Model group}) {
    final PriceTypeService? price = index == null ? null : group.prices![index];
    if (group.type == 'SINGLE') {
      context
          .bottomSheet(
        BtsPriceTicket(
          price: price,
          isDefault: bloc.isError,
        ),
      )
          .then(
        (value) {
          if (value is PriceTypeService) {
            value.type = ServiceTypeV2Model(type: 'SINGLE');
            setData(
              value: value,
              index: index,
              group: group,
            );
          }
        },
      );
      return;
    }
    if (group.type == 'MEMBERSHIP') {
      context
          .bottomSheet(
        BtsPriceTime(
          price: price,
          namePrice: group.choices ?? [],
          isDefault: bloc.isError,
        ),
      )
          .then(
        (value) {
          if (value is PriceTypeService) {
            setData(
              value: value,
              index: index,
              group: group,
            );
          }
        },
      );
      return;
    }
    if (group.type == 'TREATMENT') {
      context
          .bottomSheet(
        BtsPriceTreatment(
          price: price,
          namePrice: group.choices ?? [],
          isDefault: bloc.isError,
        ),
      )
          .then(
        (value) {
          if (value is PriceTypeService) {
            setData(
              value: value,
              index: index,
              group: group,
            );
          }
        },
      );
      return;
    }
  }

  setData({
    int? index,
    required PriceTypeService value,
    required ServiceTypeV2Model group,
  }) {
    if (index != null) {
      group.prices![index] = value;
    } else {
      group.prices!.add(value);
    }

    if (value.isActive) {
      bloc.setPriceDefault(bloc.list.indexOf(group), group.prices!.length - 1);
    }
    widget.bloc.prices = bloc.mapDataPrices;

    setState(() {});
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
