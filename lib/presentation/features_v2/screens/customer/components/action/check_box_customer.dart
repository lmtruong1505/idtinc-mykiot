
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pharmago/presentation/features_v2/blocs/local/bool_bloc.dart';
import 'package:pharmago/shared/ext/init_ext.dart';

import '../../../../../../shared/style_app/init_style.dart';

// ignore: must_be_immutable
class CheckBoxAction extends StatefulWidget {
  String label;
  String content;
  bool value;
  Function(bool)? onChange;
  CheckBoxAction({
    super.key,
    required this.label,
    required this.content,
    this.onChange,
    this.value = false,
  });

  @override
  State<CheckBoxAction> createState() => _CheckBoxActionState();
}

class _CheckBoxActionState extends State<CheckBoxAction> {
  final bloc = BoolBloc();
  @override
  initState() {
    super.initState();
    bloc.change(widget.value);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BoolBloc, bool>(
      bloc: bloc,
      listener: (context, state) => widget.onChange?.call(state),
      builder: (context, state) {
        return Padding(
          padding:Dimensions. sp16.padingTop + Dimensions.sp16.padingHor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.label,
                style: StyleApp.semibold(),
              ),
              Dimensions.sp8.height,
              GestureDetector(
                onTap: () {
                  bloc.change(!state);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorApp.greyF5,
                    borderRadius: Dimensions.sp8.radius,
                  ),
                  child: Row(
                    children: [
                      Checkbox(
                        value: state,
                        activeColor: ColorApp.main,
                        onChanged: (value) {
                          bloc.change(!state);
                        },
                      ),
                      Text(
                        widget.content,
                        style: StyleApp.medium(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
