enum ImageReceiptSourceEnum {
  camera,
  gallery
}

class ImageReceiptEntity {
    final String? path;
    final String? name;
    final int? statusAi;
    final String? messageAi;
    final int? count;
    final ImageReceiptSourceEnum? source;

    ImageReceiptEntity({
        this.path,
        this.name,
        this.statusAi,
        this.messageAi,
        this.count,
        this.source,
    });

    ImageReceiptEntity copyWith({
        String? path,
        String? name,
        int? statusAi,
        int? count,
        String? messageAi,
        ImageReceiptSourceEnum? source,
    }) => 
        ImageReceiptEntity(
            path: path ?? this.path,
            name: name ?? this.name,
            statusAi: statusAi ?? this.statusAi,
            count: count ?? this.count,
            messageAi: messageAi ?? this.messageAi,
            source: source ?? this.source,
        );

    Map<String, dynamic> toJson() => {
        'path': path,
        'name': name,
        'statusAi': statusAi,
        'messageAi': messageAi,
        'source': source,
    };
}
