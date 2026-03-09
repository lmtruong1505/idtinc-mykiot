import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/blocs/order_v2/product_selection_bloc.dart';
import 'package:pharmago/presentation/features_v2/screens/order/components/selection/product_selection.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

class DonThuocTab extends StatefulWidget {
  const DonThuocTab({super.key, required this.bloc});

  final ProductSelectionBloc bloc;

  @override
  State<DonThuocTab> createState() => _DonThuocTabState();
}

class _DonThuocTabState extends State<DonThuocTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: 24.padingTop + 16.padingHor,
      child: ProductSelection(
        bloc: widget.bloc,
        ghiChu: true,
        isPrescription: true,
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
