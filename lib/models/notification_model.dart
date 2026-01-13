class NotificationModel {
  final String id;
  final String title;
  final String? content;
  final String type;
  final bool? isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationModel({
    required this.id,
    required this.title,
    this.content,
    required this.type,
    this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      type: json['type'] ?? 'system',
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
