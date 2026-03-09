class MediaDatum {
    final int? id;
    final String? image;
    final dynamic alt;
    final DateTime? createdAt;

    MediaDatum({
        this.id,
        this.image,
        this.alt,
        this.createdAt,
    });

    MediaDatum copyWith({
        int? id,
        String? image,
        dynamic alt,
        DateTime? createdAt,
    }) => 
        MediaDatum(
            id: id ?? this.id,
            image: image ?? this.image,
            alt: alt ?? this.alt,
            createdAt: createdAt ?? this.createdAt,
        );

    factory MediaDatum.fromJson(Map<String, dynamic> json) => MediaDatum(
        id: json["id"],
        image: json["image"],
        alt: json["alt"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "alt": alt,
        "created_at": createdAt?.toIso8601String(),
    };
}