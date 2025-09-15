class Category {
  int? id;
  final String name;
  bool isSynced;

  Category({this.id, required this.name, this.isSynced = false});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'isSynced': isSynced ? 1 : 0};
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      isSynced: map['isSynced'] == 1,
    );
  }
}
