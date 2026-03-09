import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:pharmago/presentation/features_v2/models/phieu_kham/detail_pk_v2_model.dart';

@RoutePage()
class PrintMedicalWifiPage extends StatelessWidget {
  final DetailPkV2Model medical;
  const PrintMedicalWifiPage({
    super.key,
    required this.medical,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
