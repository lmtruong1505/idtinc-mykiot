import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/base/v2/text_row.dart';
import 'package:pharmago/presentation/features/order/cubit/order_create_cubit/order_create_state.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/style_app/init_style.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

import '../../blocs/phieu_kham/detail_prescription_bloc.dart';
import '../../blocs/state/init_state.dart';
import '../../models/calendar/event_model.dart';
import '../../models/prescription/prescription_model.dart';

@RoutePage()
class DetailPrescriptionPage extends StatefulWidget {
  final EventModel model;
  const DetailPrescriptionPage({required this.model});
  @override
  State<DetailPrescriptionPage> createState() => _DetailPrescriptionPageState();
}

class _DetailPrescriptionPageState extends State<DetailPrescriptionPage> {
  final titleStyle = StyleApp.normal(color: ColorApp.grey79);

  final contentStyle = StyleApp.semibold();

  final screenShotController = ScreenshotController();

  final bloc = DetailPrescriptionBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.model.prescription != null) {
      bloc.getDetail(widget.model.prescription ?? '');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailPrescriptionBloc, CubitState>(
      bloc: bloc,
      builder: (context, state) {
        return LoadPage(
          state: state,
          height: null,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SingleChildScrollView(
                padding: 16.pading,
                child: _buildBody(),
              ).expanded(),
              MainButtonV2(
                onTap: () {
                  context
                      .pushRoute(
                    CreatePrescriptionRoute(
                      item: widget.model,
                      model: bloc.model,
                    ),
                  )
                      .then(
                    (value) {
                      if (value is String) {
                        widget.model.prescription = value;
                        bloc.getDetail(widget.model.prescription ?? '');
                      }
                    },
                  );
                },
                title: bloc.model == null
                    ? 'Tạo đơn thuốc'
                    : 'Chỉnh sửa đơn thuốc',
              ).container(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    if (bloc.model?.id == null) {
      return const EmptyContainer(
        msg: 'Bạn chưa tạo đơn thuốc cho phiếu khám này',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Screenshot(
          controller: screenShotController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Đơn thuốc khám bệnh',
                style: StyleApp.semibold(),
                textAlign: TextAlign.center,
              ),
              Center(
                child: QrImageView(
                  data: bloc.model?.code ?? '',
                ).container(height: 200, width: 200),
              ),
              TextRow2(
                title: 'Mã đơn thuốc',
                content: bloc.model?.code,
                titleStyle: titleStyle,
                contentStyle: contentStyle,
              ),
              16.height,
              TextRow2(
                title: 'Họ tên bệnh nhân',
                content: bloc.model?.customer?.fullName,
                titleStyle: titleStyle,
                contentStyle: contentStyle,
              ),
              16.height,
              TextRow2(
                title: 'Bác sĩ khám bệnh',
                content: bloc.model?.doctor?.fullName,
                titleStyle: titleStyle,
                contentStyle: contentStyle,
              ),
              16.height,
              TextRow2(
                title: 'Cơ sở',
                content: getCompanyName ?? '',
                titleStyle: titleStyle,
                contentStyle: contentStyle,
              ),
              16.height,
              TextRow2(
                title: 'Ngày khám',
                content: widget.model.meetingAt.toDate
                    .fomatCustom(fomat: 'HH:mm dd/MM/yyyy'),
                titleStyle: titleStyle,
                contentStyle: contentStyle,
              ),
              16.height,
              TextRow2(
                title: 'Chẩn đoán',
                content: bloc.model?.diagnostic,
                titleStyle: titleStyle,
                contentStyle: contentStyle,
                crossAxisAlignment: CrossAxisAlignment.start,
              ),
              Row(
                children: [
                  Text(
                    'Thuốc điều trị',
                    style: StyleApp.semibold(),
                  ),
                  TextButton(
                    onPressed: () {
                      print(widget.model.uuid);
                      context.pushRoute(
                        OrderCreateProdRoute(
                          typeCreate: OrderType.product,
                          mbUuid: widget.model.uuid,
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerRight,
                    ),
                    child: Text(
                      'Tạo đơn hàng sản phẩm',
                      style: StyleApp.semibold(
                        color: ColorApp.blue20,
                      ),
                    ),
                  ).expanded(),
                ],
              ),
              ...List.generate(
                (bloc.model?.items ?? []).length,
                (index) => itemThuoc(
                  bloc.model!.items![index],
                ),
              ),
            ],
          ).container(),
        ),
        16.height,
        MainButtonV2(
          onTap: () async {
            final Directory tempDir = await getApplicationDocumentsDirectory();
            screenShotController
                .captureAndSave(
              tempDir.path,
              fileName:
                  'don-thuoc-DT1234-${(DateTime.now().millisecondsSinceEpoch / 1000).round()}.png',
            )
                .then(
              (value) {
                if (value != null) {
                  CheckStateBloc.showSnackBar(
                    context,
                    'Tải đơn thuốc thành công',
                  );
                }
              },
            );
          },
          title: 'Tải về',
        ),
        context.padding.bottom.height,
      ],
    );
  }

  Widget itemThuoc(ItemsPrescription item) {
    final units = item.units
            ?.where(
              (element) => element.id == item.unit,
            )
            .toList() ??
        [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextRow2(
          title: (item.variant?.name ?? ''),
          content:
              "${item.quantity.formatPrice()} ${units.isEmpty ? "" : units.first.name ?? ''}",
          titleStyle: StyleApp.semibold(color: ColorApp.grey79),
          contentStyle: StyleApp.semibold(),
        ),
        4.height,
        Text(
          item.lieuDung ?? '',
          style: StyleApp.semibold(),
          textAlign: TextAlign.right,
        ),
      ],
    );
  }
}
