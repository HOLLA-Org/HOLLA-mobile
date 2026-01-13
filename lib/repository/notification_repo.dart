import '../models/notification_model.dart';

abstract class NotificationRepository {
  Future<List<NotificationModel>> getNotifications();
  Future<void> deleteNotification(String id);
  Future<void> deleteAllNotifications();
}
