import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/cache_image.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/bg/bg_detail.dart';
import 'package:pharmago/shared/components/widgets/app_bar_custom.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/components/widgets/fa_icon.dart';
import 'package:pharmago/shared/components/widgets/icon_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../blocs/phieu_kham_v2/detail_pk_v2_bloc.dart';
import '../../models/phieu_kham/detail_pk_v2_model.dart';
import 'components/detail/info_detail_pk.dart';

@RoutePage()
class DetailPkV2Page extends StatefulWidget {
  final int id;
  const DetailPkV2Page({super.key, required this.id});

  @override
  State<DetailPkV2Page> createState() => _DetailPkV2PageState();
}

class _DetailPkV2PageState extends State<DetailPkV2Page> {
  final _bloc = DetailPkV2Bloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _bloc.getDetail(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarCustom(
        title: 'Chi tiết đơn hàng dịch vụ',
        subTitle: 'Chi tiết kết luận',
      ),
      // bottomNavigationBar: BgBtnNavBar(
      //   child: LabelButton(
      //     label: 'Tạo đơn sản phẩm',
      //     onPressed: () {
      //       context.router.push(CreateOrderRoute(type: 'product'));
      //     },
      //   ),
      // ),
      body: BlocBuilder<DetailPkV2Bloc, CubitState>(
        bloc: _bloc,
        builder: (context, state) {

          return LoadPage(
            state: state,
            height: null,
            child: BgDetail(
              child: SingleChildScrollView(
                padding: 16.pading,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    InfoDetailPk(
                      phieuKham: _bloc.state.data ?? DetailPkV2Model(),
                    ),
                    DividerCustom().padding(24.padingVer),
                    Text(
                      'Dịch vụ:',
                      style: AppStyle.headingLg,
                    ),
                    12.height,
                    _buildService(),
                    24.height,
                    _buildPathologies(),
                    12.height,
                    _buildNoteDoctor(),
                    24.height,
                    prescriptionView(),
                    context.padding.bottom.height,
                  ],
                ).container(
                  radius: 16,
                  border: Border.all(
                    color: AppColors.border_tertiary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPathologies() {
    final pathologies = _bloc.state.data?.pathologies ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconBorderCustom(
              icon: FaIcon(
                iconCode: 'f0f1',
                size: 20,
                type: FaIconType.solid,
              ),
              color: AppColors.fg_tertiary,
            ),
            Text(
              'Chẩn đoán:',
              style: AppStyle.headingMd,
            ).expanded(),
          ],
        ),
        2.height,
        ...List.generate(
          pathologies.length,
          (index) => Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.circle,
                size: 4,
                color: AppColors.text_secondary,
              ).padding(10.pading),
              Text(
                pathologies[index].nameVn ?? '',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_secondary,
                  height: 1.5,
                ),
              ).expanded(),
            ],
          ).padding(12.padingHor),
        ),
        12.height,
      ],
    ).container(
      bgColor: AppColors.bg_secondary_subtle,
      radius: 12,
      padding: 0.pading,
    );
  }

  Widget _buildService() {
    final service = _bloc.state.data?.service;
    final employee = _bloc.state.data?.employee;

    final images = service?.images ?? [];

    return Row(
      children: [
        BaseCacheImage(
          url: images.isEmpty ? '' : images.first,
          width: 40,
          height: 40,
          borderRadius: 4.radius,
        ),
        12.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              service?.title ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bodySmRegular.copyWith(
                color: AppColors.text_tertiary,
                height: 1.5,
              ),
            ),
            6.height,
            RichText(
              text: TextSpan(
                text: 'Bác sĩ ',
                style: AppStyle.bodySmRegular.copyWith(
                  color: AppColors.text_tertiary,
                ),
                children: [
                  TextSpan(
                    text: '${employee?.name.validator} ',
                    style: AppStyle.bodySmSemiBold.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ),
                  TextSpan(
                    text: '${employee?.phone.validator} ',
                    style: AppStyle.bodySmRegular.copyWith(
                      color: AppColors.text_secondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ).expanded(),
      ],
    );
  }

  Widget prescriptionView() {
    final prescriptions = _bloc.state.data?.prescriptions ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(
        prescriptions.length,
        (index) {
          final items = prescriptions[index].items ?? [];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Đơn thuốc',
                style: AppStyle.headingLg,
              ),
              12.height,
              ListView.separated(
                itemBuilder: (context, indexPrd) =>
                    _buildPrd(indexPrd, items[indexPrd]),
                separatorBuilder: (context, index) => DividerCustom(),
                itemCount: items.length,
                padding: 0.pading,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
              ),
              12.height,
              DividerCustom(),
              24.height,
              Text(
                'Lời dặn của Bác sĩ',
                style: AppStyle.bodyBsRegular.copyWith(
                  color: AppColors.text_secondary,
                ),
              ),
              Text(
                prescriptions[index].note ?? 'Không có lời dặn',
                style: AppStyle.bodyBsMedium.copyWith(
                  height: 1.5,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildNoteDoctor() {
    final medicalBill = _bloc.state.data?.medicalBill;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconBorderCustom(
              icon: FaIcon(
                iconCode: 'f7f5',
                size: 20,
                type: FaIconType.solid,
              ),
              color: AppColors.fg_tertiary,
            ),
            Text(
              'Kết luận',
              style: AppStyle.headingMd,
            ).expanded(),
          ],
        ),
        2.height,
        Text(
          medicalBill?.conclusion ?? 'Không có kết luận',
          style: AppStyle.bodyBsRegular.copyWith(
            color: AppColors.text_secondary,
            height: 1.5,
          ),
        ).padding(12.padingHor),
        12.height,
      ],
    ).container(
      bgColor: AppColors.bg_secondary_subtle,
      radius: 12,
      padding: 0.pading,
    );
  }

  Widget _buildPrd(index, ItemsPrescriptions item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${index + 1}.',
              style: AppStyle.bodyBsMedium.copyWith(
                color: AppColors.text_tertiary,
              ),
            ),
            8.width,
            BaseCacheImage(
              url: item.image ?? '',
              height: 40,
              width: 40,
              borderRadius: 4.radius,
            ),
          ],
        ),
        12.width,
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              item.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppStyle.bodySmRegular.copyWith(
                color: AppColors.text_tertiary,
                height: 1.5,
              ),
            ),
            6.height,
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: 'SL: ',
                    style: AppStyle.bodySmRegular.copyWith(
                      color: AppColors.text_tertiary,
                    ),
                    children: [
                      TextSpan(
                        text: item.quantity.formatPrice(),
                        style: AppStyle.bodyBsMedium.copyWith(
                          color: AppColors.text_secondary,
                        ),
                      ),
                      TextSpan(
                        text: ' ${item.unit ?? ""}',
                        style: AppStyle.bodySmRegular.copyWith(
                          color: AppColors.text_tertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  item.price.formatPrice(type: ' đ'),
                  style: AppStyle.headingBs,
                ),
              ],
            ),
            6.height,
            Text(
              item.lieuDung ?? '',
              style: AppStyle.bodyBsBold,
            ).container(
              radius: 6,
              padding: 8.padingHor + 4.padingVer,
              bgColor: AppColors.bg_secondary,
            ),
          ],
        ).expanded(),
      ],
    ).padding(12.padingVer);
  }
}
