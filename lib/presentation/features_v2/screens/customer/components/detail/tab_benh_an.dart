import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/base/empty_container.dart';
import 'package:pharmago/presentation/constants/spacing.dart';
import 'package:pharmago/presentation/features/customer/data/models/customer_model.dart';
import 'package:pharmago/presentation/features_v2/blocs/customer/customer_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/enum/enum_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/local/file_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/state/init_state.dart';
import 'package:pharmago/shared/components/button/main_button.dart';
import 'package:pharmago/shared/components/widgets/bloc_to_page.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import '../item_benh_an.dart';

class TabFile extends StatefulWidget {
  final CustomerModel customer;
  final TypeFileCustomer type;
  const TabFile({
    super.key,
    required this.customer,
    required this.type,
  });

  @override
  State<TabFile> createState() => _TabFileState();
}

class _TabFileState extends State<TabFile> with AutomaticKeepAliveClientMixin {
  final fileBloc = FileBloc();
  final bloc = CustomerBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc.getFile(
      customerId: widget.customer.id ?? 0,
      type: widget.type,
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return RefreshIndicator(
      onRefresh: () async {
        await bloc.getFile(
          customerId: widget.customer.id ?? 0,
          type: widget.type,
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BlocListener<FileBloc, CubitState>(
            bloc: fileBloc,
            listener: (context, state) {
              CheckStateBloc.check(
                context,
                state,
                isShowMsg: true,
                success: () {
                  bloc.getFile(
                    customerId: widget.customer.id ?? 0,
                    type: widget.type,
                  );
                },
              );
            },
            child: Padding(
              padding: sp16.pading,
              child: MainButtonV2(
                title: 'Tải lên file',
                onTap: () {
                  fileBloc.uploadFile(
                    customerId: widget.customer.id ?? 0,
                    type: widget.type.code,
                  );
                },
              ),
            ),
          ),
          BlocBuilder<CustomerBloc, CubitState>(
            bloc: bloc,
            builder: (context, state) {
              return LoadPage(
                state: state,
                height: null,
                child: bloc.files.isEmpty
                    ? const EmptyContainer()
                    : ListView.separated(
                        padding: sp16.pading,
                        itemCount: bloc.files.length,
                        separatorBuilder: (context, index) => 16.height,
                        itemBuilder: (context, index) => ItemFile(
                          item: bloc.files[index],
                        ),
                      ),
              );
            },
          ).expanded(),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
