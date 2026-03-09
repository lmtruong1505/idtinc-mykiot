

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:pharmago/data/local/get_data.dart';
import 'package:pharmago/gen/flutter_assets.dart';
import 'package:pharmago/presentation/base/dialog.dart';
import 'package:pharmago/presentation/di/di.dart';
import 'package:pharmago/presentation/features_v2/repositories/service/serrvice_v2_repository.dart';
import 'package:pharmago/presentation/router/router.gr.dart';
import 'package:pharmago/shared/components/toast/toast_custom.dart';
import 'package:pharmago/shared/ext/init_ext.dart';
import 'package:pharmago/shared/utils/delay_callback.dart';

import '../../../config/app_style/init_app_style.dart';
import '../../models/product/product_v2_model.dart';
import '../../models/service/service.dart';
import '../enum/enum_bloc.dart';
import '../state/init_state.dart';

part 'list_service_bloc.dart';
part 'service_type_bloc.dart';
part 'config_price_bloc.dart';
part 'add_prd_bloc.dart';
part 'create_service_bloc.dart';
part 'detail_service_bloc.dart';
part 'update_service_bloc.dart';
