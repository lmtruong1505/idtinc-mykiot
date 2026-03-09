import 'dart:developer';

import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_thermal_printer/flutter_thermal_printer.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/base/button.dart';
import 'package:pharmago/presentation/config/app_style/init_app_style.dart';
import 'package:pharmago/presentation/features_v2/blocs/print_invoice/print_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/widgets/divider_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

@RoutePage()
class SelectPrintScreen extends StatefulWidget {
  const SelectPrintScreen({
    super.key,
    required this.bloc,
  });
  final PrintBloc bloc;

  @override
  State<SelectPrintScreen> createState() => _SelectPrintScreenState();
}

class _SelectPrintScreenState extends State<SelectPrintScreen> {
  PrintBloc get bloc => widget.bloc;

  final _flutterThermalPrinterPlugin = FlutterThermalPrinter.instance;
  @override
  void initState() {
    super.initState();

    bloc.checkPermission();
  }

  @override
  void dispose() {
    bloc.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BaseAppBar(
        title: 'Chọn máy in',
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.re),
          //   onPressed: _isConnected ? null : _requestPermissions,
          //   tooltip: 'Quét lại thiết bị',
          // ),
        ],
      ),
      body: BlocBuilder<PrintBloc, CubitState>(
        bloc: bloc,
        builder: (context, state) {
          // if (state.status == BlocStatus.loading) {
          //   return const BaseLoading();
          // }
          return RefreshIndicator(
            onRefresh: () async {
              bloc.startScan();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('THIẾT BỊ BLUETOOTH', style: s14w500),
                if (state.status == BlocStatus.loading) ...[
                  24.height,
                  const Center(
                    child: Text(
                      'Đang tìm kiếm thiết bị...',
                      style: s14w500,
                    ),
                  ),
                  24.height,
                  const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.brand,
                      strokeWidth: 4,
                    ),
                  ),
                ] else ...[
                  if (bloc.printers.isEmpty)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          16.height,
                          const Icon(
                            Icons.bluetooth,
                            size: 50,
                            color: AppColors.text_tertiary,
                          ),
                          16.height,
                          Text(
                            'Không tìm thấy thiết bị',
                            style: s14w500.copyWith(
                              color: AppColors.text_tertiary,
                            ),
                          ),
                          16.height,
                          MainButton(
                            event: bloc.requestPermissions,
                            title: 'QUÉT LẠI THIẾT BỊ',
                          ),
                        ],
                      ),
                    ).expanded()
                  else
                    ListView.separated(
                      separatorBuilder: (context, index) => DividerCustom(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: bloc.printers.length,
                      itemBuilder: (context, index) {
                        final printer = bloc.printers[index];

                        final isConnected = printer.isConnected == true;
                        return ListTile(
                          onTap: () async {
                            Navigator.of(context).pop(printer);
                            if (printer.isConnected ?? false) {
                              await _flutterThermalPrinterPlugin
                                  .disconnect(printer);
                            } else {
                              final isConnected =
                                  await _flutterThermalPrinterPlugin
                                      .connect(printer);
                              log('Devices: $isConnected');
                            }
                          },
                          title: Text(printer.name ?? 'No Name'),
                          subtitle: printer.isConnected == true
                              ? const Text('Đã kết nối')
                              : null,
                          trailing: Icon(
                            Icons.bluetooth,
                            color: isConnected
                                ? AppColors.blue60
                                : AppColors.text_tertiary,
                          ),
                        );
                      },
                    ).expanded(),
                ],
              ],
            ),
          ).padding(16.pading);
        },
      ),
    );
  }
}
