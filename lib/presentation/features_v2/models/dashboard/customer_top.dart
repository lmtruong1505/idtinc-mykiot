class DashboardCustomerTopModel {
  int? customerCount;
  double? pricePerCustomer;
  double? orderPerCustomer;
  List<CustomersDashboard>? customers;

  DashboardCustomerTopModel({
    this.customerCount,
    this.pricePerCustomer,
    this.orderPerCustomer,
    this.customers,
  });

  DashboardCustomerTopModel.fromJson(Map<String, dynamic> json) {
    customerCount = json['customer_count'];
    pricePerCustomer = double.tryParse(json['price_per_customer'].toString());
    orderPerCustomer = double.tryParse(json['order_per_customer'].toString());
    if (json['customers'] != null) {
      customers = <CustomersDashboard>[];
      json['customers'].forEach((v) {
        customers!.add(CustomersDashboard.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_count'] = customerCount;
    data['price_per_customer'] = pricePerCustomer;
    data['order_per_customer'] = orderPerCustomer;
    if (customers != null) {
      data['customers'] = customers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomersDashboard {
  int? id;
  String? fullName;
  int? totalOrder;
  double? totalPrice;

  CustomersDashboard({
    this.id,
    this.fullName,
    this.totalOrder,
    this.totalPrice,
  });

  CustomersDashboard.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'];
    totalOrder = json['total_order'];
    totalPrice = json['total_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['total_order'] = totalOrder;
    data['total_price'] = totalPrice;
    return data;
  }
}
