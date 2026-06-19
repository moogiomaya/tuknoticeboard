class Category {
  final int categoryId;
  final String categoryName;
  final String targetAudience;

  Category({
    required this.categoryId,
    required this.categoryName,
    required this.targetAudience,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'] ?? 0,
      categoryName: json['category_name'] ?? '',
      targetAudience: json['target_audience'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'category_id': categoryId,
        'category_name': categoryName,
        'target_audience': targetAudience,
      };
}