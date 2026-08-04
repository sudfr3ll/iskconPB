class Cities {
  final int? id;
  final String? name;
  Cities({
    this.id,
    this.name,
  });
  factory Cities.fromJson(Map<String, dynamic> json) {
    return Cities(
      id: json['id'],
      name: json['name'],
    );
  }
}
