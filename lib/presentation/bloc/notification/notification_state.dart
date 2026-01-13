import 'package:equatable/equatable.dart';
import '../../../models/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class GetNotificationsSuccess extends NotificationState {
  final List<NotificationModel> notifications;

  const GetNotificationsSuccess(this.notifications);

  @override
  List<Object?> get props => [notifications];
}

class NotificationDeleteSuccess extends NotificationState {}

class NotificationDeleteAllSuccess extends NotificationState {}

class NotificationFailure extends NotificationState {
  final String error;

  const NotificationFailure(this.error);

  @override
  List<Object?> get props => [error];
}
