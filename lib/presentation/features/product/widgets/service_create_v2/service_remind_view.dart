import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/select.dart';
import 'package:pharmago/presentation/features/product/cubit/service_create_cubit/service_create_cubit.dart';
import 'package:pharmago/shared/ext/ext_num.dart';

import '../../../../base/text_field.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/spacing.dart';
import '../../cubit/service_create_cubit/service_create_state.dart';

class ServiceRemindView extends StatefulWidget {
  const ServiceRemindView({
    super.key,
    required this.myBloc,
  });

  final ServiceCreateCubit myBloc;

  @override
  State<ServiceRemindView> createState() => _ServiceRemindViewState();
}

class _ServiceRemindViewState extends State<ServiceRemindView>
    with AutomaticKeepAliveClientMixin {
  late TextEditingController _tec;

  @override
  void initState() {
    _tec = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _tec.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<ServiceCreateCubit, ServiceCreateState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: 12.pading,
                margin: 12.pading,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(sp12),
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.1),
                      offset: const Offset(1, 1),
                      blurRadius: 1,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: AppInputSupport(
                            hintText: 'Chọn thời gian nhắc hẹn ',
                            label: 'Thời gian nhắc hẹn',
                            backgroundColor: whiteColor,
                            borderColor: greyColor,
                            initialValue: state.servicePayload.reminderTime != null
                                ? state.servicePayload.reminderTime.toString()
                                : '',
                            textInputType: TextInputType.number,
                            maxLines: 1,
                            onChanged: (value) {
                              widget.myBloc.reminderTimeChange(value.trim());
                            },
                          ),
                        ),
                        6.width,
                        Expanded(
                          flex: 2,
                          child: CommonDropdown(
                            label: 'Đơn vị',
                            hintText: 'Chọn đơn vị',
                            value: state.servicePayload.frequency,
                            items: const [
                              DropdownMenuItem(
                                value: 'ngày',
                                child: Text('Ngày'),
                              ),
                              DropdownMenuItem(
                                value: 'tuần',
                                child: Text('Tuần'),
                              ),
                              DropdownMenuItem(
                                value: 'tháng',
                                child: Text('Tháng'),
                              ),
                            ],
                            showIconRemove: false,
                            onChanged: (value) {
                              widget.myBloc.infoFormChange(frequency: value);
                            },
                          ),
                        ),
                      ],
                    ),
                    16.height,
                    AppInputSupport(
                      label: 'Gửi tin nhắc hẹn qua',
                      hintText: 'Zalo',
                      backgroundColor: whiteColor,
                      borderColor: greyColor,
                      textInputType: TextInputType.text,
                      suffixIcon:
                          const Icon(Icons.keyboard_arrow_down_outlined),
                      onChanged: (value) {},
                    ),
                    16.height,
                    AppInputSupport(
                      label: 'Lời nhắn',
                      hintText: '',
                      initialValue: state.servicePayload.message,
                      backgroundColor: whiteColor,
                      borderColor: greyColor,
                      textInputType: TextInputType.text,
                      onChanged: (value) {
                        widget.myBloc.infoFormChange(message: value.trim());
                      },
                    ),
                  ],
                ),
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
