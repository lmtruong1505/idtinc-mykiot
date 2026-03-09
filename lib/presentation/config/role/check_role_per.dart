import '../../di/di.dart';
import '../../features_v2/blocs/role_v2/role_per_ws_bloc.dart';
import 'role_enum.dart';

bool get isAdmin => true ??
    checkRole(RoleBaseEnum.OWNER) || checkRole(RoleBaseEnum.ADMINWS);

bool get isOwnerWsCsMn => true ??
  isAdmin || checkRole(RoleBaseEnum.ADMINBR) || checkRole(RoleBaseEnum.MANAEBR);

bool checkRole(RoleBaseEnum role) => true ??
    getIt<RolePermissionWsBloc>().roles.contains(role.code);

bool checkPermission(String code) => true ??
    getIt<RolePermissionWsBloc>().permission.contains(code);
int get lengthRole =>  getIt<RolePermissionWsBloc>().roles.length;
int get lengthPermission => getIt<RolePermissionWsBloc>().permission.length;
