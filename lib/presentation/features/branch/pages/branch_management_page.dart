import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features/branch/bloc/branch_management_bloc/branch_management_bloc.dart';
import 'package:pharmago/presentation/features/branch/pages/pharmacy_list_page.dart';

import '../../../../shared/style_app/color_app.dart';
import '../../../di/di.dart';
import 'clinic_list_page.dart';

@RoutePage()
class BranchManagementPage extends StatefulWidget {
  const BranchManagementPage({super.key});

  @override
  State<BranchManagementPage> createState() => _BranchManagementPageState();
}

class _BranchManagementPageState extends State<BranchManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final myBloc = getIt<BranchManagementBloc>();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.index >= myBloc.branchTypes.length) return;
      myBloc.changeBranchType(myBloc.branchTypes[_tabController.index]);
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => myBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Quản lý cơ sở',
            style: TextStyle(
              color: ColorApp.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: ColorApp.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: ColorApp.white,
          bottom: TabBar(
            controller: _tabController,
            tabs: List.generate(
              myBloc.branchTypes.length,
              (index) => Tab(text: myBloc.branchTypes[index].title),
            ),
            indicatorColor: ColorApp.black,
            labelColor: ColorApp.black,
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            PharmacyListPage(
              myBloc: myBloc,
            ),
            ClinicListPage(
              myBloc: myBloc,
            ),
          ],
        ),
      ),
    );
  }
}
