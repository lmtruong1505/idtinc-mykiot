class PointExchangePackagePayload {
    final String? name;
    final int? point;
    final int? workspace;
    final bool? status;
    final String? note;
    final List<Item>? items;

    PointExchangePackagePayload({
        this.name,
        this.point,
        this.workspace,
        this.status,
        this.note,
        this.items,
    });

    PointExchangePackagePayload copyWith({
        String? name,
        int? point,
        int? workspace,
        bool? status,
        String? note,
        List<Item>? items,
    }) => 
        PointExchangePackagePayload(
            name: name ?? this.name,
            point: point ?? this.point,
            workspace: workspace ?? this.workspace,
            status: status ?? this.status,
            note: note ?? this.note,
            items: items ?? this.items,
        );

    factory PointExchangePackagePayload.fromJson(Map<String, dynamic> json) => PointExchangePackagePayload(
        name: json['name'],
        point: json['point'],
        workspace: json['workspace'],
        status: json['status'],
        note: json['note'],
        items: json['items'] == null ? [] : List<Item>.from(json['items']!.map((x) => Item.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        'name': name,
        'point': point,
        'workspace': workspace,
        'status': status,
        'note': note,
        'items': items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
    };
}

class Item {
    final int? productId;
    final int? unitId;
    final int? quantity;

    Item({
        this.productId,
        this.unitId,
        this.quantity,
    });

    Item copyWith({
        int? productId,
        int? unitId,
        int? quantity,
    }) => 
        Item(
            productId: productId ?? this.productId,
            unitId: unitId ?? this.unitId,
            quantity: quantity ?? this.quantity,
        );

    factory Item.fromJson(Map<String, dynamic> json) => Item(
        productId: json['product_id'],
        unitId: json['unit_id'],
        quantity: json['quantity'],
    );

    Map<String, dynamic> toJson() => {
        'product_id': productId,
        'unit_id': unitId,
        'quantity': quantity,
    };
}
