class DiscountModel {
  final String id;
  final String code;
  final int value;
  final String description;
  final int maxUsage;
  final DateTime? expiresAt;

  DiscountModel({
    required this.id,
    required this.code,
    required this.value,
    required this.description,
    required this.maxUsage,
    this.expiresAt,
  });

  factory DiscountModel.fromJson(Map<String, dynamic> json) {
    return DiscountModel(
      id: json['_id'] ?? '',
      code: json['code'] ?? '',
      value: json['value'] ?? 0,
      description: json['description'] ?? '',
      maxUsage: json['max_usage'] ?? 0,
      expiresAt:
          json['expires_at'] != null
              ? DateTime.parse(json['expires_at'])
              : null,
    );
  }
}
