import 'package:flutter/material.dart';
import 'package:pharmago/presentation/constants/colors.dart';
import 'package:pharmago/presentation/constants/size_device.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../shared/components/button/double_button.dart';
import '../../../../../shared/components/input/overlay_input.dart';
import '../../../../config/app_style/init_app_style.dart';
import '../../../../constants/spacing.dart';
import '../../../../di/di.dart';
import '../../data/models/pathology_model.dart';
import '../cubits/medical_schedule_manager_cubit/medical_schedule_manager_cubit.dart';
import 'pathology_create_bts.dart';

class PathologyBts extends StatefulWidget {
  const PathologyBts({
    super.key,
    this.pathologies,
    this.callBack,
    this.createPathologyCallBack,
  });

  final List<PathologyModel>? pathologies;
  final Function(List<PathologyModel>)? callBack;
  final Function(String, String)? createPathologyCallBack;

  static void show(
    BuildContext context, {
    List<PathologyModel>? pathologies,
    Function(List<PathologyModel>)? callBack,
    Function(String, String)? createPathologyCallBack,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.vertical(
          top: Radius.circular(sp16),
        ),
      ),
      isScrollControlled: true,
      builder: (context) {
        return PathologyBts(
          pathologies: pathologies,
          callBack: callBack,
          createPathologyCallBack: createPathologyCallBack,
        );
      },
    );
  }

  @override
  State<PathologyBts> createState() => _PathologyBtsState();
}

class _PathologyBtsState extends State<PathologyBts> {
  List<PathologyModel> pathologies = [];
  late TextEditingController textCtrl;
  int page = 1;

  @override
  void initState() {
    super.initState();

    pathologies = widget.pathologies ?? [];
    textCtrl = TextEditingController()
      ..addListener(
        () {
          page = 1;
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightDevice(context) * 0.95,
      child: Padding(
        padding: EdgeInsetsGeometry.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          children: [
            Container(
              width: sp64,
              height: sp4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(sp24),
                color: AppColors.bg_disable,
              ),
            ),
            sp16.height,
            Text(
              'Chuẩn đoán',
              style: s16w700.copyWith(
                color: AppColors.text_primary,
              ),
            ),
            sp16.height,
            Row(
              children: [
                Expanded(child: _buildSearch),
                sp12.width,
                InkWell(
                  onTap: () {
                    PathologyCreateBts.show(
                      context,
                      onConfirm: widget.createPathologyCallBack,
                    );
                  },
                  child: const CircleAvatar(
                    backgroundColor: mainColor,
                    child: Icon(Icons.add_rounded),
                  ),
                ),
              ],
            ),
            sp16.height,
            Expanded(
              child: ListView.separated(
                itemBuilder: (context, index) {
                  final item = pathologies[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: sp8,
                      horizontal: sp12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.bg_disable,
                      borderRadius: BorderRadius.circular(sp8),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child:
                                Text('${item.code ?? '***'} - ${item.nameVn}')),
                        sp8.width,
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              pathologies.removeAt(index);
                            });
                          },
                          child: const Icon(
                            Icons.close_rounded,
                            color: AppColors.icon_iconPrimary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (_, __) => sp12.height,
                itemCount: pathologies.length,
              ),
            ),
            const Spacer(),
            DoubleButton(
              cancelText: 'Huỷ',
              onCancel: () {
                context.pop();
              },
              confirmText: 'Xác nhận',
              onConfirm: () {
                context.pop();
                widget.callBack?.call(pathologies);
              },
            ).size(height: 32),
            sp32.height,
          ],
        ).padding(const EdgeInsets.all(sp16)),
      ),
    );
  }

  SizedBox get _buildSearch {
    return OverlayInput<PathologyModel>(
      itemBuilder: (BuildContext context, item, int index) {
        final isSelected = pathologies.contains(item);
        return Container(
          padding: const EdgeInsets.symmetric(vertical: sp8, horizontal: sp12),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${item.nameVn}',
                ),
              ),
              if (isSelected) ...[
                sp8.width,
                const Icon(
                  Icons.check_circle_rounded,
                  size: sp16,
                  color: AppColors.green50,
                ),
              ],
            ],
          ),
        );
      },
      onChanged: (item) {
        final index = pathologies.indexWhere((e) => e.id == item.id);
        if (index == -1) {
          setState(() {
            pathologies.add(item);
          });
        }
      },
      header: Text(
        'Chọn chuẩn đoán',
        style: AppStyle.headingMd.copyWith(
          color: AppColors.text_quaternary,
        ),
      ).padding(16.pading.copyWith(top: 12, bottom: 6)),
      hintText: 'Tìm chuẩn đoán',
      lazyLoad: (isMore) {
        if (isMore) {
          page += 1;
        }
        return getIt.get<MedicalScheduleManagerCubit>().pathologies(
              page: page,
              search: textCtrl.text,
            );
      },
      controller: textCtrl,
      borderRadius: 999,
      elevation: 1,
      prefix: const Icon(
        Icons.search,
        size: 24,
      ),
    ).size(height: 40);
  }
}
