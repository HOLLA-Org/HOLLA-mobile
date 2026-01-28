import 'package:flutter_bloc/flutter_bloc.dart';

import 'notification_event.dart';
import 'notification_state.dart';
import '../../../models/notification_model.dart';
import '../../../repository/notification_repo.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationBloc({required NotificationRepository notificationRepository})
    : _notificationRepository = notificationRepository,
      super(NotificationInitial()) {
    on<GetNotifications>(_onGetNotifications);
    on<DeleteNotification>(_onDeleteNotification);
    on<DeleteAllNotifications>(_onDeleteAllNotifications);
  }

  Future<void> _onGetNotifications(
    GetNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      final results = await Future.wait([
        _notificationRepository.getNotifications(),
        Future.delayed(const Duration(milliseconds: 800)),
      ]);
      final notifications = results[0] as List<NotificationModel>;
      emit(GetNotificationsSuccess(notifications));
    } catch (e) {
      emit(NotificationFailure(_translateError(e.toString())));
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _notificationRepository.deleteNotification(event.notificationId);
      add(GetNotifications());
    } catch (e) {
      emit(NotificationFailure(_translateError(e.toString())));
    }
  }

  Future<void> _onDeleteAllNotifications(
    DeleteAllNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      await _notificationRepository.deleteAllNotifications();
      add(GetNotifications());
    } catch (e) {
      emit(NotificationFailure(_translateError(e.toString())));
    }
  }

  String _translateError(String errorMessage) {
    return errorMessage.replaceFirst('Exception: ', '').trim();
  }
}
