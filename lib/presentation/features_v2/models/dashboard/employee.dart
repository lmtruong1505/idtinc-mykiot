class DashboardEmployeeModel {
  final int? id;
  final String? phoneNumber;
  final String? fullName;
  final bool? isActive;
  final int? totalOrder;
  final int? totalSales;
  final int? saleQuantity;
  final int? totalRevenue;

  DashboardEmployeeModel({
    this.id,
    this.phoneNumber,
    this.fullName,
    this.isActive,
    this.totalOrder,
    this.totalSales,
    this.saleQuantity,
    this.totalRevenue,
  });

  DashboardEmployeeModel copyWith({
    int? id,
    String? phoneNumber,
    String? fullName,
    bool? isActive,
    int? totalOrder,
    int? totalSales,
    int? saleQuantity,
    int? totalRevenue,
  }) =>
      DashboardEmployeeModel(
        id: id ?? this.id,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        fullName: fullName ?? this.fullName,
        isActive: isActive ?? this.isActive,
        totalOrder: totalOrder ?? this.totalOrder,
        totalSales: totalSales ?? this.totalSales,
        saleQuantity: saleQuantity ?? this.saleQuantity,
        totalRevenue: totalRevenue ?? this.totalRevenue,
      );

  factory DashboardEmployeeModel.fromJson(Map<String, dynamic> json) =>
      DashboardEmployeeModel(
        id: json['id'],
        phoneNumber: json['phone_number'],
        fullName: json['full_name'],
        isActive: json['is_active'],
        totalOrder: json['total_order'],
        totalSales: json['total_sales'],
        saleQuantity: json['sale_quantity'],
        totalRevenue: json['total_revenue'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone_number': phoneNumber,
        'full_name': fullName,
        'is_active': isActive,
        'total_order': totalOrder,
        'total_sales': totalSales,
        'sale_quantity': saleQuantity,
        'total_revenue': totalRevenue,
      };
}
