class WarehouseV2Model {
  int? id;
  String? maVach;
  String? soQuyetDinh;
  String? soDangKy;
  String? batchCode;
  String? manufacturingDate;
  String? note;
  String? invoiceImport;
  double? purchasePrice;
  bool? dangBan;
  int? initialStock;
  int? numberInStock;
  double? importPrice;
  int? productId;
  String? storageLocation;
  int? userCreatedId;
  int? userUpdatedId;
  String? createdAt;
  String? updatedAt;

  WarehouseV2Model(
      {this.id,
        this.maVach,
        this.soQuyetDinh,
        this.soDangKy,
        this.batchCode,
        this.manufacturingDate,
        this.note,
        this.invoiceImport,
        this.purchasePrice,
        this.dangBan,
        this.initialStock,
        this.numberInStock,
        this.importPrice,
        this.productId,
        this.storageLocation,
        this.userCreatedId,
        this.userUpdatedId,
        this.createdAt,
        this.updatedAt});

  WarehouseV2Model.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    maVach = json['ma_vach'];
    soQuyetDinh = json['so_quyet_dinh'];
    soDangKy = json['so_dang_ky'];
    batchCode = json['batch_code'];
    manufacturingDate = json['manufacturing_date'];
    note = json['note'];
    invoiceImport = json['invoice_import'];
    purchasePrice = json['purchase_price'];
    dangBan = json['dang_ban'];
    initialStock = json['initial_stock'];
    numberInStock = json['number_in_stock'];
    if(json['import_price'] != null) {
      importPrice = json['import_price'].toDouble();
    }
    productId = json['product_id'];
    storageLocation = json['storage_location'];
    userCreatedId = json['user_created_id'];
    userUpdatedId = json['user_updated_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['ma_vach'] = maVach;
    data['so_quyet_dinh'] = soQuyetDinh;
    data['so_dang_ky'] = soDangKy;
    data['batch_code'] = batchCode;
    data['manufacturing_date'] = manufacturingDate;
    data['note'] = note;
    data['invoice_import'] = invoiceImport;
    data['purchase_price'] = purchasePrice;
    data['dang_ban'] = dangBan;
    data['initial_stock'] = initialStock;
    data['number_in_stock'] = numberInStock;
    data['import_price'] = importPrice;
    data['product_id'] = productId;
    data['storage_location'] = storageLocation;
    data['user_created_id'] = userCreatedId;
    data['user_updated_id'] = userUpdatedId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data.removeWhere((key, value) => value == null);
    return data;
  }
}
