import 'package:equatable/equatable.dart';

class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object> get props => [];
}

final class SettingInitial extends SettingState {}

final class SettingLoading extends SettingState {}

final class LogoutSuccess extends SettingState {}

final class LogoutFailure extends SettingState {
  final String error;

  const LogoutFailure(this.error);

  @override
  List<Object> get props => [error];
}
