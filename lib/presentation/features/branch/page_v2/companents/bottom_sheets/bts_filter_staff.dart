import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/cubit_state.dart';
import 'package:pharmago/shared/components/bg/bg_bts.dart';
import 'package:pharmago/shared/components/widgets/filter_item.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../features_v2/blocs/role/list_role_bloc.dart';

class BtsFilterStaffBranch extends StatefulWidget {
  final int? value;
  const BtsFilterStaffBranch({this.value});
  @override
  State<BtsFilterStaffBranch> createState() => _BtsFilterStaffBranchState();
}

class _BtsFilterStaffBranchState extends State<BtsFilterStaffBranch> {
  int? select;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    select = widget.value ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    return BgBts(
      label: 'Bộ lọc',
      onCancel: () {
        context.pop(result: 0);
      },
      onConfirm: () {
        context.pop(result: select);
      },
      child: BlocBuilder<ListRoleBloc, CubitState>(
        builder: (context, state) {
          final roles = context.read<ListRoleBloc>().list;
          return FilterItem(
            label: 'Vị trí làm việc',
            onTap: (p0) {
              select = p0;
              setState(() {});
            },
            select: select,
            items: List.generate(
              roles.length + 1,
              (index) => index == 0 ? 'Tất cả' : roles[index - 1].title ?? '',
            ),
          );
        },
      ),
    );
  }
}
