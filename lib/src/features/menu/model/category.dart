class Category {
  final int id;
  final String slug;

  const Category({required this.id, required this.slug});

  @override
  String toString() => slug;

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json['id'], slug: json['slug']);

  Map<String, dynamic> toJson() => {"id": id, "slug": slug};
}
