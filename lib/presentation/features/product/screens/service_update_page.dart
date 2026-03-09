
import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/product/widgets/service_update/service_update_info.dart';
import 'package:pharmago/presentation/features/product/widgets/service_update/service_update_unit_form.dart';

import '../../../../shared/constants/pref_key.dart';
import '../../../base/app_bar.dart';
import '../../../base/button.dart';
import '../../../base/cache_image.dart';
import '../../../base/dialog.dart';
import '../../../base/row_item.dart';
import '../../../base/text_field.dart';
import '../../../constants/colors.dart';
import '../../../constants/size_device.dart';
import '../../../constants/spacing.dart';
import '../../../constants/typography.dart';
import '../../../di/di.dart';
import '../../../shared/utils/event.dart';
import '../cubit/service_update_cubit/service_update_detail_cubit.dart';
import '../cubit/service_update_cubit/service_update_detail_state.dart';
import '../domain/entities/variant_entity.dart';

@RoutePage()
class ServiceUpdatePage extends StatefulWidget {
  const ServiceUpdatePage({required this.id, super.key});

  final int id;

  @override
  State<ServiceUpdatePage> createState() => _ServiceUpdatePageState();
}

class _ServiceUpdatePageState extends State<ServiceUpdatePage> {
  
  final myBloc = getIt.get<ServiceUpdateDetailCubit>();
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc..getDetail(widget.id),
      child: BlocBuilder<ServiceUpdateDetailCubit, ServiceUpdateDetailState>(
        builder: (BuildContext context, ServiceUpdateDetailState state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
              backgroundColor: bg_5,
              appBar: const BaseAppBar(
                title: 'Sửa dịch vụ',
              ),
              body: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: sp24,
                  horizontal: sp16,
                ),
                height: heightDevice(context),
                width: widthDevice(context),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // ============= Info Basic Form =============
                        ServiceUpdateInfoBasic(myBloc: myBloc),
                        gapHeight(sp16),

                        // ============= Unit Form =============
                        ServiceUpdateUnitFormView(myBloc: myBloc),
                        gapHeight(sp16),

                        //ServiceAttachProduct(canAdd: true, myBloc: myBloc, ),
                        _buildAttachProduct(myBloc),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  color: whiteColor,
                  boxShadow: [
                    BoxShadow(
                      color: blackColor.withOpacity(0.1),
                      offset: const Offset(0, -1),
                      blurRadius: sp4,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(sp16),
                width: double.infinity,
                child: MainButton(
                  title: 'Xác nhận',
                  event: _updateServiceHandle,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  void _updateServiceHandle() {
    final validate = _formKey.currentState!.validate();
    if (!validate) {
      return;
    }
    DialogUtils.showLoadingDialog(context, 'Đang tạo dịch vụ...');
    // myBloc.updateService().then((value) {
    //   context.router.maybePop();
    // });
  }
  Widget _buildAttachProduct(ServiceUpdateDetailCubit myBloc) {
    return Container(
      padding: const EdgeInsets.all(sp16).copyWith(top: sp0),
      decoration: BoxDecoration(
        borderRadius:
        const BorderRadius.vertical(bottom: Radius.circular(sp12)),
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Danh sách danh mục',
                style: p3.copyWith(color: blackColor),
              ),
            ],
          ),
          gapHeight(sp16),
          AppInputSupport(
            hintText: 'Tìm kiếm theo tên/mã',
            prefixIcon: const Icon(Icons.search_rounded),
            backgroundColor: whiteColor,
            onChanged: (value) {
             // myBloc.searchVariant(value);
            },
          ),
          gapHeight(sp16),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: myBloc.state.variants.length,
            itemBuilder: (BuildContext context, int index) {
              final item = myBloc.state.variants[index];
              return Container(
                padding: const EdgeInsets.all(sp16),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(sp12),
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
                    _buildVariant(item),
                    gapHeight(sp16),
                    RowItem(title: 'Giá nhập', content: FormatCurrency(item.priceSell ?? 0)),
                    gapHeight(sp12),
                    const RowItem(title: 'Số lượng', content: 'Fix'),
                    gapHeight(sp12),
                    const RowItem(title: 'Tổng tiền', content: 'Fix'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVariant(VariantEntity item) {
    return SizedBox(
      width: widthDevice(context),
      child: ListTile(
        contentPadding:const EdgeInsets.all(0),
        leading: SizedBox(
          height: sp48,
          width: sp48,
          child: BaseCacheImage(
            url: (item.media?.isNotEmpty ?? false)
                ? (item.media ?? PrefKeys.imgProductDefault)
                : PrefKeys.imgProductDefault,
          ),
        ),
        title: Text(
          item.name ?? '',
          style: p5.copyWith(
            color: blue_3,
          ),
        ),
        subtitle: Text(
          item.code ?? '',
          style: p6.copyWith(
            color: greyColor,
          ),
          maxLines: 2,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          color: Colors.red,
          onPressed: () {
            myBloc.removeVariant(item);
          },
        ),
      ),
    );
  }
}


