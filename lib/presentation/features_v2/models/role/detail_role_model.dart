import '../employee/pre_emp_model.dart';
import '../position/position_model.dart';
import 'role_model.dart';

class DetailRoleModel {
  DetailRoleModel({
    this.role,
    this.items,
    this.employees,
  });

  final RoleDetail? role;
  final List<RoleListModel>? items;
  final List<PreEmpModel>? employees;

  factory DetailRoleModel.fromJson(Map<String, dynamic> json) {
    return DetailRoleModel(
      role: json['role'] == null ? null : RoleDetail.fromJson(json['role']),
      items: json['items'] == null
          ? []
          : List<RoleListModel>.from(
              json['items']!.map((x) => RoleListModel.fromJson(x)),
            ),
      employees: json['employees'] == null
          ? []
          : List<PreEmpModel>.from(
              json['employees']!.map((x) => PreEmpModel.fromJson(x)),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
        'role': role?.toJson(),
        'items': items?.map((x) => x.toJson()).toList(),
        'employees': employees?.map((x) => x.toJson()).toList(),
      };
}

class RoleDetail {
  RoleDetail({
    this.id,
    this.title,
    this.note,
    this.company,
    this.userCreatedName,
    this.userUpdatedName,
    this.createdAt,
    this.code,
    this.updatedAt,
    this.totalEmployee,
    this.position,
    this.isDefault,
  });

  final int? id;
  final String? title;
  final String? note;
  final String? code;
  final int? company;
  final int? totalEmployee;
  final String? userCreatedName;
  final String? userUpdatedName;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final PositionModel? position;
  final bool? isDefault;

  factory RoleDetail.fromJson(Map<String, dynamic> json) {
    return RoleDetail(
      id: json['id'],
      title: json['title'],
      code: json['code'],
      totalEmployee: json['total_employee'],
      note: json['note'],
      company: json['company'],
      userCreatedName: json['user_created_name'],
      userUpdatedName: json['user_updated_name'],
      createdAt: DateTime.tryParse(json['created_at'] ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? ''),
      isDefault: json['is_default'],
      position: json['position'] == null
          ? null
          : PositionModel.fromJson(json['position']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
        'note': note,
        'company': company,
        'user_created_name': userCreatedName,
        'user_updated_name': userUpdatedName,
        'total_employee': totalEmployee,
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'position': position?.toJson(),
        'is_default': isDefault,
  };
}

/*
{
	"role": {
		"id": 6,
		"title": "123",
		"note": "",
		"company": 18,
		"user_created_name": "Tạ Trung Kiên",
		"user_updated_name": "Trương Huyền Diệu",
		"created_at": "2024-07-17T04:56:25.457282Z",
		"updated_at": "0001-01-01T00:00:00Z"
	},
	"items": [
		{
			"id": 1,
			"title": "Quản lý khách hàng",
			"code": "CUSTOMER",
			"sub_app": [
				{
					"id": 2,
					"title": "Xem danh sách khách hàng",
					"code": "CUSTOMER-1",
					"level": 2,
					"value": false
				},
				{
					"id": 3,
					"title": "Tạo mới khách hàng",
					"code": "CUSTOMER-2",
					"level": 2,
					"value": false
				},
				{
					"id": 4,
					"title": "Xem chi tiết khách hàng",
					"code": "CUSTOMER-3",
					"level": 2,
					"value": false
				},
				{
					"id": 5,
					"title": "Chỉnh sửa khách hàng",
					"code": "CUSTOMER-4",
					"level": 2,
					"value": false
				},
				{
					"id": 6,
					"title": "Xoá khách hàng",
					"code": "CUSTOMER-5",
					"level": 2,
					"value": false
				}
			],
			"level": 1
		},
		{
			"id": 7,
			"title": "Quản lý nhóm khách hàng",
			"code": "G-CUSTOMER",
			"sub_app": [
				{
					"id": 8,
					"title": "Xem danh sách nhóm khách hàng",
					"code": "G-CUSTOMER-1",
					"level": 2,
					"value": false
				},
				{
					"id": 9,
					"title": "Tạo mới nhóm khách hàng",
					"code": "G-CUSTOMER-2",
					"level": 2,
					"value": false
				},
				{
					"id": 10,
					"title": "Xem chi tiết nhóm khách hàng",
					"code": "G-CUSTOMER-3",
					"level": 2,
					"value": false
				},
				{
					"id": 11,
					"title": "Chỉnh sửa nhóm khách hàng",
					"code": "G-CUSTOMER-4",
					"level": 2,
					"value": false
				},
				{
					"id": 12,
					"title": "Xoá nhóm khách hàng",
					"code": "G-CUSTOMER-5",
					"level": 2,
					"value": false
				}
			],
			"level": 1
		},
		{
			"id": 13,
			"title": "Quản lý tồn kho",
			"code": "INVENTORY",
			"sub_app": [
				{
					"id": 14,
					"title": "Điều chỉnh tồn kho",
					"code": "INVENTORY-1",
					"level": 2,
					"value": false
				},
				{
					"id": 15,
					"title": "Xuất dữ liệu",
					"code": "INVENTORY-2",
					"level": 2,
					"value": false
				},
				{
					"id": 16,
					"title": "Danh sách tồn kho",
					"code": "INVENTORY-3",
					"level": 2,
					"value": false
				}
			],
			"level": 1
		},
		{
			"id": 17,
			"title": "Quản lý nhập kho",
			"code": "IMPORT",
			"sub_app": [
				{
					"id": 18,
					"title": "Tạo mới nhập kho",
					"code": "IMPORT-1",
					"level": 2,
					"value": false
				},
				{
					"id": 19,
					"title": "Chi tiết nhập kho",
					"code": "IMPORT-2",
					"level": 2,
					"value": false
				},
				{
					"id": 20,
					"title": "Chỉnh sửa nhập kho",
					"code": "IMPORT-3",
					"level": 2,
					"value": false
				},
				{
					"id": 21,
					"title": "Huỷ đơn nhập kho",
					"code": "IMPORT-4",
					"level": 2,
					"value": false
				},
				{
					"id": 22,
					"title": "Xác nhận đơn nhập kho",
					"code": "IMPORT-5",
					"level": 2,
					"value": false
				},
				{
					"id": 23,
					"title": "Danh sách nhập kho",
					"code": "IMPORT-6",
					"level": 2,
					"value": false
				}
			],
			"level": 1
		},
		{
			"id": 24,
			"title": "Quản lý xuất kho",
			"code": "EXPORT",
			"sub_app": [
				{
					"id": 25,
					"title": "Danh sách đơn xuất kho",
					"code": "EXPORT-1",
					"level": 2,
					"value": false
				},
				{
					"id": 26,
					"title": "Chi tiết đơn xuất kho",
					"code": "EXPORT-2",
					"level": 2,
					"value": false
				}
			],
			"level": 1
		},
		{
			"id": 27,
			"title": "Quản lý nhà cung cấp",
			"code": "SUPPLIER",
			"sub_app": [
				{
					"id": 28,
					"title": "Xem danh sách nhà cung cấp",
					"code": "SUPPLIER-1",
					"level": 2,
					"value": false
				},
				{
					"id": 29,
					"title": "Tạo mới nhà cung cấp",
					"code": "SUPPLIER-2",
					"level": 2,
					"value": false
				},
				{
					"id": 30,
					"title": "Xem chi tiết nhà cung cấp",
					"code": "SUPPLIER-3",
					"level": 2,
					"value": false
				},
				{
					"id": 31,
					"title": "Chỉnh sửa nhà cung cấp",
					"code": "SUPPLIER-4",
					"level": 2,
					"value": false
				},
				{
					"id": 32,
					"title": "Xoá nhà cung cấp",
					"code": "SUPPLIER-5",
					"level": 2,
					"value": false
				}
			],
			"level": 1
		},
		{
			"id": 33,
			"title": "Quản lý nhóm nhà cung cấp",
			"code": "G-SUPPLIER",
			"sub_app": [
				{
					"id": 34,
					"title": "Xem danh sách nhóm nhà cung cấp",
					"code": "G-SUPPLIER-1",
					"level": 2,
					"value": false
				},
				{
					"id": 35,
					"title": "Tạo mới nhóm nhà cung cấp",
					"code": "G-SUPPLIER-2",
					"level": 2,
					"value": false
				},
				{
					"id": 36,
					"title": "Xem chi tiết nhóm nhà cung cấp",
					"code": "G-SUPPLIER-3",
					"level": 2,
					"value": false
				},
				{
					"id": 37,
					"title": "Chỉnh sửa nhóm nhà cung cấp",
					"code": "G-SUPPLIER-4",
					"level": 2,
					"value": false
				},
				{
					"id": 38,
					"title": "Xoá nhóm nhà cung cấp",
					"code": "G-SUPPLIER-5",
					"level": 2,
					"value": false
				}
			],
			"level": 1
		},
		{
			"id": 39,
			"title": "Quản lý nhân viên",
			"code": "EMPLOYEE",
			"sub_app": [
				{
					"id": 40,
					"title": "Xem danh sách nhân viên",
					"code": "EMPLOYEE-1",
					"level": 2,
					"value": false
				},
				{
					"id": 41,
					"title": "Tạo mới nhân viên",
					"code": "EMPLOYEE-2",
					"level": 2,
					"value": false
				},
				{
					"id": 42,
					"title": "Xem chi tiết nhân viên",
					"code": "EMPLOYEE-3",
					"level": 2,
					"value": false
				},
				{
					"id": 43,
					"title": "Đổi mật khẩu nhân viên",
					"code": "EMPLOYEE-4",
					"level": 2,
					"value": false
				},
				{
					"id": 44,
					"title": "Kích hoạt/Vô hiệu hóa nhân viên",
					"code": "EMPLOYEE-5",
					"level": 2,
					"value": false
				}
			],
			"level": 1
		},
		{
			"id": 45,
			"title": "Quản lý đơn hàng",
			"code": "ORDER",
			"sub_app": [
				{
					"id": 46,
					"title": "Xem danh sách đơn hàng",
					"code": "ORDER-1",
					"level": 2,
					"value": false
				},
				{
					"id": 47,
					"title": "Tạo mới đơn hàng",
					"code": "ORDER-2",
					"level": 2,
					"value": false
				},
				{
					"id": 48,
					"title": "Xem chi tiết đơn hàng",
					"code": "ORDER-3",
					"level": 2,
					"value": false
				},
				{
					"id": 49,
					"title": "Chỉnh sửa đơn hàng",
					"code": "ORDER-4",
					"level": 2,
					"value": false
				}
			],
			"level": 1
		},
		{
			"id": 50,
			"title": "Quản lý sản phẩm",
			"code": "PRODUCT",
			"sub_app": [
				{
					"id": 51,
					"title": "Xem danh sách sản phẩm",
					"code": "PRODUCT-1",
					"level": 2,
					"value": false
				},
				{
					"id": 52,
					"title": "Tạo mới sản phẩm",
					"code": "PRODUCT-2",
					"level": 2,
					"value": false
				},
				{
					"id": 53,
					"title": "Xem chi tiết sản phẩm",
					"code": "PRODUCT-3",
					"level": 2,
					"value": false
				},
				{
					"id": 54,
					"title": "Chỉnh sửa sản phẩm",
					"code": "PRODUCT-4",
					"level": 2,
					"value": false
				}
			],
			"level": 1
		}
	]
}*/