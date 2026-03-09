import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/app_bar.dart';
import 'package:pharmago/presentation/features_v2/blocs/role/list_role_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/presentation/shared/utils/get.dart';
import 'package:pharmago/shared/components/button/custom_btn.dart';
import 'package:pharmago/shared/components/input/input_column.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../shared/style_app/init_style.dart';
import '../../blocs/role/list_core_role_bloc.dart';
import '../../blocs/role/param/create_role_param.dart';
import '../../blocs/role/role_bloc.dart';
import '../../models/role/detail_role_model.dart';
import '../customer/components/bg_action.dart';

@RoutePage()
class CreateRolePage extends StatefulWidget {
  final DetailRoleModel? model;
  const CreateRolePage({
    super.key,
    this.model,
  });

  @override
  State<CreateRolePage> createState() => _CreateRolePageState();
}

class _CreateRolePageState extends State<CreateRolePage> {
  final coreRoleBloc = ListCoreRoleBloc();
  final bloc = RoleBloc();
  final param = CreateRoleParam();
  final _keyForm = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    coreRoleBloc.getList(
      values: widget.model?.items,
    );
    param.company = getCompany;
    if (widget.model != null) {
      param.company = widget.model!.role?.company;
      param.title = widget.model!.role?.title;
      param.code = widget.model!.role?.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RoleBloc, CubitState>(
      bloc: bloc,
      listener: (context, state) {
        CheckStateBloc.check(
          context,
          state,
          successBtnText: 'Danh sách',
          success: () {
            context.read<ListRoleBloc>().getList();
            context.pop();
            context.pop(result: true);
          },
        );
      },
      child: Scaffold(
        backgroundColor: ColorApp.greyF5,
        appBar: BaseAppBar(
          title: widget.model == null ? 'Tạo vai trò' : 'Cập nhật vai trò',
        ),
        bottomNavigationBar: RowBtn(
          onCancel: () => context.pop(),
          onConfirm: () {
            if (_keyForm.currentState!.validate()) {
              param.items = coreRoleBloc.mapItems(coreRoleBloc.list);
              if (widget.model == null) {
                bloc.create(param);
              } else {
                bloc.update(widget.model?.role?.id ?? 0, param);
              }
            }
          },
        ).container(),
        body: SingleChildScrollView(
          padding: 16.pading,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Form(
                key: _keyForm,
                child: BgAction(
                  title: widget.model == null
                      ? 'Thêm mới vai trò'
                      : 'Cập nhật vai trò',
                  click: true,
                  colorTitle: ColorApp.grey,
                  isTextClick: false,
                  fontSize: 14,
                  child: InputColumn(
                    label: 'Tên vai trò',
                    isRequired: true,
                    initialValue: param.title,
                    onChanged: (p0) => param.title = p0,
                  ).padding(16.padingBottom),
                ),
              ),
              BlocBuilder<ListCoreRoleBloc, CubitState>(
                bloc: coreRoleBloc,
                builder: (context, state) {
                  return LoadPage(
                    state: state,
                    height: 200,
                    listEmpty: coreRoleBloc.list.isEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Phân quyền vai trò',
                              style: StyleApp.medium(),
                            ).expanded(),
                            12.width,
                            Text(
                              'Chọn tất cả',
                              style: StyleApp.medium(),
                            ),
                            Checkbox(
                              value: coreRoleBloc.isAll,
                              onChanged: (value) {
                                coreRoleBloc.checkAll(value ?? false);
                              },
                              activeColor: ColorApp.main,
                              visualDensity:
                                  const VisualDensity(horizontal: -4),
                            ),
                          ],
                        ),
                        ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => _buildItem(index),
                          separatorBuilder: (context, index) => 16.height,
                          itemCount: coreRoleBloc.list.length,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final role = coreRoleBloc.list[index];
    final items = role.subApp ?? [];
    return BgAction(
      title: role.title ?? '',
      isCheckBox: true,
      valueBox: role.value ?? false,
      onChangeBox: (p0) {
        coreRoleBloc.chooseCheckBox(
          value: p0 ?? false,
          index: index,
        );
      },
      click: true,
      colorTitle: ColorApp.black,
      isTextClick: false,
      fontSize: 16,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(
          items.length,
          (indexV2) {
            return CheckboxListTile(
              value: items[indexV2].value ?? false,
              onChanged: (value) {
                coreRoleBloc.chooseCheckBox(
                  value: value ?? false,
                  index: index,
                  indexV2: indexV2,
                );
              },
              activeColor: ColorApp.main,
              controlAffinity: ListTileControlAffinity.leading,
              visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
              contentPadding: 8.padingHor,
              title: Text(
                items[indexV2].title ?? '',
                style: StyleApp.normal(),
              ),
            );
          },
        ),
      ),
    );
  }
}
