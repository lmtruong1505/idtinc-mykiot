class BrandDashboardModel {
  int? workspaceId;
  String? name;
  double? totalRevenue;
  double? totalRevenuePercentage;

  BrandDashboardModel(
      {this.workspaceId,
      this.name,
      this.totalRevenue,
      this.totalRevenuePercentage});

  BrandDashboardModel.fromJson(Map<String, dynamic> json) {
    workspaceId = json['workspace_id'];
    name = json['name'];
    totalRevenue = json['total_revenue'];
    totalRevenuePercentage = json['total_revenue_percentage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['workspace_id'] = this.workspaceId;
    data['name'] = this.name;
    data['total_revenue'] = this.totalRevenue;
    data['total_revenue_percentage'] = this.totalRevenuePercentage;
    return data;
  }
}
