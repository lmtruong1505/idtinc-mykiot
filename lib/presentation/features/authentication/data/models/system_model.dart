class SystemData {
    final int? id;
    final String? title;
    final String? code;

    SystemData({
        this.id,
        this.title,
        this.code,
    });

    SystemData copyWith({
        int? id,
        String? title,
        String? code,
    }) => 
        SystemData(
            id: id ?? this.id,
            title: title ?? this.title,
            code: code ?? this.code,
        );

    factory SystemData.fromJson(Map<String, dynamic> json) => SystemData(
        id: json["id"],
        title: json["title"],
        code: json["code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "code": code,
    };
}