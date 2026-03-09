import '../position/position_model.dart';

class RoleListModel {
  RoleListModel({
    this.id,
    this.title,
    this.code,
    this.note,
    this.subApp,
    this.level,
    this.value,
    this.position,
    this.totalEmployee,
  });

  final int? id;
  final String? title;
  final String? code;
  final String? note;
  final List<RoleListModel>? subApp;
  final int? level;
  bool? value;
  final PositionModel? position;
  final int? totalEmployee;

  factory RoleListModel.fromJson(Map<String, dynamic> json) {
    return RoleListModel(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      totalEmployee: json['total_employee'],
      code: json['code'],
      subApp: json['sub_app'] == null
          ? []
          : List<RoleListModel>.from(
              json['sub_app']!.map((x) => RoleListModel.fromJson(x)),
            ),
      level: json['level'],
      position: json['position'] == null
          ? null
          : PositionModel.fromJson(json['position']),
      value: json['value'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'code': code,
        'note': note,
        'sub_app': subApp?.map((x) => x.toJson()).toList(),
        'level': level,
        'position': position?.toJson(),
        'value': value,
      };

  RoleListModel copyWith({
    int? id,
    String? title,
    String? code,
    String? note,
    List<RoleListModel>? subApp,
    int? level,
    bool? value,
    PositionModel? position,
  }) {
    return RoleListModel(
      id: id ?? this.id,
      title: title ?? this.title,
      code: code ?? this.code,
      note: note ?? this.note,
      subApp: subApp ?? this.subApp,
      level: level ?? this.level,
      value: value ?? this.value,
      position: position ?? this.position,
    );
  }
}

/*
{
	"id": 1,
	"title": "Quản lý khách hàng",
	"code": "CUSTOMER",
	"sub_app": [
		{
			"id": 2,
			"title": "Xem danh sách khách hàng",
			"code": "CUSTOMER-1",
			"level": 2
		},
		{
			"id": 3,
			"title": "Tạo mới khách hàng",
			"code": "CUSTOMER-2",
			"level": 2
		},
		{
			"id": 4,
			"title": "Xem chi tiết khách hàng",
			"code": "CUSTOMER-3",
			"level": 2
		},
		{
			"id": 5,
			"title": "Chỉnh sửa khách hàng",
			"code": "CUSTOMER-4",
			"level": 2
		},
		{
			"id": 6,
			"title": "Xoá khách hàng",
			"code": "CUSTOMER-5",
			"level": 2
		}
	],
	"level": 1
}*/