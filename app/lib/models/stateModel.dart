class States {
  final int? id;
  final String? name;
  final String? iso2;
  States({
    this.id,
    this.name,
    this.iso2,
  });
  factory States.fromJson(Map<String, dynamic> json) {
    return States(
      id: json['id'],
      name: json['name'],
      iso2: json['iso2'],
    );
  }
}
